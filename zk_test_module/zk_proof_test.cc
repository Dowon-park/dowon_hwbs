#include <iostream>
#include <memory>
#include <vector>
#include <cstring>
#include <iomanip>
#include <sstream>
#include <algorithm>

#include "algebra/fp2.h"
#include "zk/zk_proof.h"
#include "zk/zk_prover.h"
#include "zk/zk_verifier.h"
#include "circuits/compiler/compiler.h"
#include "circuits/logic/logic.h"
#include "circuits/logic/compiler_backend.h"
#include "sumcheck/circuit.h"
#include "ec/p256.h"
#include "algebra/fp_p256.h"
#include "algebra/convolution.h"
#include "algebra/reed_solomon.h"

using namespace proofs;

// Helper to print bytes as hex
std::string HexString(const std::vector<uint8_t>& bytes) {
    std::stringstream ss;
    ss << std::hex << std::setfill('0');
    for (uint8_t b : bytes) {
        ss << std::setw(2) << (int)b;
    }
    return ss.str();
}

template <typename Field>
void PrintFieldElement(const char* label, const Field& F, const typename Field::Elt& e) {
    std::vector<uint8_t> bytes(Field::kBytes);
    F.to_bytes_field(bytes.data(), e);
    std::cout << label << ": 0x" << HexString(bytes) << std::endl;
}

// Define a simple circuit: prove we know x such that x^2 + x + 5 = y
// For simplicity, let's just prove we know x such that x = x (trivial) or something slightly more complex but easy to implement with available ops.
// Let's try the example from the test: 2n = (s-2)m^2 - (s - 4)*m
// Or even simpler: a * b = c

void RunZkTest() {
    std::cout << "Starting ZK Proof Test..." << std::endl;

    // 1. Setup Field and Types
    using Field = Fp256Base;
    using CompilerBackend = CompilerBackend<Field>;
    using LogicCircuit = Logic<Field, CompilerBackend>;
    using EltW = LogicCircuit::EltW;

    const Field& Fg = p256_base;

    // 2. Define the Circuit
    std::cout << "Defining Circuit..." << std::endl;
    std::unique_ptr<Circuit<Field>> circuit;
    
    {
        QuadCircuit<Field> Q(Fg);
        CompilerBackend cbk(&Q);
        const LogicCircuit LC(&cbk, Fg);

        // Inputs: c (public), a, b (private)
        // Proving a * b = c
        
        EltW c = LC.eltw_input(); // Public input 0
        Q.private_input();        // Separator for public inputs
        EltW a = LC.eltw_input(); // Private input 0
        EltW b = LC.eltw_input(); // Private input 1

        EltW product = LC.mul(&a, b);
        LC.assert_eq(&product, c);

        circuit = Q.mkcircuit(1); // 1 is the number of parallel instances (batch size)
    }

    if (!circuit) {
        std::cerr << "Failed to create circuit!" << std::endl;
        return;
    }
    std::cout << "Circuit created. Inputs: " << circuit->ninputs << std::endl;

    // 3. Create Witness
    std::cout << "Creating Witness..." << std::endl;
    auto W = Dense<Field>(1, circuit->ninputs);
    DenseFiller<Field> filler(W);
    
    // Values
    auto val_one = Fg.one();
    auto val_c = Fg.of_scalar(30);
    auto val_a = Fg.of_scalar(5);
    auto val_b = Fg.of_scalar(6);

    // Print Inputs
    PrintFieldElement("Public Key (c)", Fg, val_c);
    PrintFieldElement("Private Key (a)", Fg, val_a);
    PrintFieldElement("Private Key (b)", Fg, val_b);
    
    // Order: 1, Public Inputs, Private Inputs
    filler.push_back(val_one); 
    filler.push_back(val_c); // c (public)
    filler.push_back(val_a);  // a (private)
    filler.push_back(val_b);  // b (private)

    // 4. Generate Proof
    std::cout << "Generating Proof..." << std::endl;
    
    // Setup parameters
    size_t rate = 4;
    size_t req = 16; 
    
    ZkProof<Field> zk_proof(*circuit, rate, req);
    
    // Transcript
    // Note: ZkProver uses the SAME transcript for commit and prove in the reference implementation.
    Transcript tp((uint8_t*)"test_transcript", 15);

    // Setup Factories
    // P256 requires extension field for Ligero
    using Field2 = Fp2<Field>;
    using Elt2 = typename Field2::Elt;
    using FftExtConvolutionFactory = FFTExtConvolutionFactory<Field, Field2>;
    using RSFactory = ReedSolomonFactory<Field, FftExtConvolutionFactory>;

    // Roots of unity from zk_test.cc
    auto omega_x = Fg.of_string("0xf90d338ebd84f5665cfc85c67990e3379fc9563b382a4a4c985a65324b242562");
    auto omega_y = Fg.of_string("0xb9e81e42bc97cc4da04fc2e20106e34084738a6474d232c6dbf4174f60a43eac");
    uint64_t omega_order = 1ull << 31;

    const Field2 base_2(Fg);
    const Elt2 omega{omega_x, omega_y};
    const FftExtConvolutionFactory fft(Fg, base_2, omega, omega_order);
    const RSFactory rsf(fft, Fg);
    
    // Random Engine
    class SimpleRandomEngine : public RandomEngine {
     public:
      void bytes(uint8_t* buf, size_t n) override {
        for(size_t i=0; i<n; ++i) buf[i] = rand() % 256;
      }
    };
    SimpleRandomEngine rng;
    
    // Prover
    ZkProver<Field, RSFactory> prover(*circuit, Fg, rsf);
    
    // Commit
    prover.commit(zk_proof, W, tp, rng);
    
    // Prove
    if (!prover.prove(zk_proof, W, tp)) {
        std::cerr << "Prover failed!" << std::endl;
        return;
    }

    std::cout << "Proof Generated. Size: " << zk_proof.size() << " bytes (approx)" << std::endl;

    // Serialize/Deserialize
    std::vector<uint8_t> proof_bytes;
    zk_proof.write(proof_bytes, Fg);
    
    std::cout << "Signature Value (Proof Snippet): 0x" << HexString(std::vector<uint8_t>(proof_bytes.begin(), proof_bytes.begin() + std::min((size_t)32, proof_bytes.size()))) << "..." << std::endl;

    // 5. Verify Proof
    std::cout << "Verifying Proof..." << std::endl;
    
    ZkProof<Field> zk_proof_verify(*circuit, rate, req);
    ReadBuffer rb(proof_bytes);
    if (!zk_proof_verify.read(rb, Fg)) {
        std::cerr << "Failed to read proof bytes!" << std::endl;
        return;
    }

    // Verify
    // Re-initialize transcript for verification (must match prover's initial state)
    Transcript tp_verify((uint8_t*)"test_transcript", 15);

    // Public Input
    auto Pub = Dense<Field>(1, circuit->ninputs);
    DenseFiller<Field> pub_filler(Pub);
    pub_filler.push_back(Fg.one());
    pub_filler.push_back(Fg.of_scalar(30)); // c (public)
    pub_filler.push_back(Fg.zero()); // a (private, masked)
    pub_filler.push_back(Fg.zero()); // b (private, masked)
    
    // Verifier
    auto verifier = ZkVerifier<Field, RSFactory>(*circuit, rsf, rate, req, Fg);
    
    // 1. Receive Commitment
    verifier.recv_commitment(zk_proof_verify, tp_verify);

    // 2. Verify Proof
    bool result = verifier.verify(zk_proof_verify, Pub, tp_verify);

    if (result) {
        std::cout << "SUCCESS: Proof verified successfully!" << std::endl;
    } else {
        std::cout << "FAILURE: Proof verification failed." << std::endl;
    }
}

int main() {
    RunZkTest();
    return 0;
}
