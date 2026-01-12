# Deep Dive: `zk_proof_test.cc`

This document provides a detailed walkthrough of the source code in `zk_proof_test.cc`.

## 1. Headers & Setup / 헤더 및 설정

The code includes necessary headers for arithmetic operations (`algebra/`), circuit logic (`circuits/`), and ZK protocols (`zk/`).

```cpp
#include "zk/zk_proof.h"
#include "zk/zk_prover.h"
#include "zk/zk_verifier.h"
#include "circuits/compiler/compiler.h"
// ...
```

- **English**: These headers provide the building blocks: fields (finite arithmetic), circuits (logic constraints), and the prover/verifier classes.
- **Korean**: 이 헤더들은 유한체 연산(Fields), 논리 제약(Circuits), 그리고 증명자/검증자 클래스 등 핵심 구성 요소를 제공합니다.

## 2. Circuit Definition / 회로 정의

The `RunZkTest` function starts by defining the arithmetic circuit.

```cpp
// 1. Setup Field and Types
using Field = Fp256Base;
using CompilerBackend = CompilerBackend<Field>;
using LogicCircuit = Logic<Field, CompilerBackend>;
// ...
QuadCircuit<Field> Q(Fg);
CompilerBackend cbk(&Q);
const LogicCircuit LC(&cbk, Fg);
```

### Logic / 로직
The circuit proves $a \times b = c$.

```cpp
EltW c = LC.eltw_input(); // Public input 0
Q.private_input();        // Separator
EltW a = LC.eltw_input(); // Private input 0
EltW b = LC.eltw_input(); // Private input 1

EltW product = LC.mul(&a, b);
LC.assert_eq(&product, c);
```

- **English**: `eltw_input` registers inputs. `mul` multiplies $a$ and $b$. `assert_eq` constrains the result to match $c$. `Q.private_input()` marks the boundary between public and private inputs.
- **Korean**: `eltw_input`은 입력을 등록합니다. `mul`은 $a$와 $b$를 곱합니다. `assert_eq`는 그 결과가 $c$와 일치하도록 제약을 겁니다. `Q.private_input()`은 공개 입력과 비공개 입력을 구분하는 경계선입니다.

## 3. Witness Creation / 위트니스 생성

The witness allows the prover to generate the proof.

```cpp
auto val_c = Fg.of_scalar(30);
auto val_a = Fg.of_scalar(5);
auto val_b = Fg.of_scalar(6);

filler.push_back(val_one); 
filler.push_back(val_c); // c (public)
filler.push_back(val_a); // a (private)
filler.push_back(val_b); // b (private)
```

- **English**: The witness vector is populated with the actual values ($30, 5, 6$) that satisfy the circuit equations. Order matters: `1`, Public Inputs, then Private Inputs.
- **Korean**: 회로 방정식을 만족하는 실제 값들($30, 5, 6$)로 위트니스 벡터를 채웁니다. 순서가 중요합니다: `1`, 공개 입력, 그 다음 비공개 입력 순입니다.

## 4. Prover / 증명자

```cpp
ZkProof<Field> zk_proof(*circuit, rate, req);
Transcript tp((uint8_t*)"test_transcript", 15);
ZkProver<Field, RSFactory> prover(*circuit, Fg, rsf);

prover.commit(zk_proof, W, tp, rng);
if (!prover.prove(zk_proof, W, tp)) { ... }
```

- **English**:
    - `Transcript`: Initializes the Fiat-Shamir state for non-interactive proofs.
    - `commit`: Encodes the witness and commits to it (Merkle tree).
    - `prove`: Responses to challenges derived from the transcript to complete the proof.
- **Korean**:
    - `Transcript`: 비상호작용 증명을 위한 Fiat-Shamir 상태를 초기화합니다.
    - `commit`: 위트니스를 인코딩하고 커밋합니다(Merkle 트리 사용).
    - `prove`: 트랜스크립트에서 파생된 챌린지에 응답하여 증명을 완성합니다.

## 5. Verifier / 검증자

The verifier checks the proof without knowing $a$ and $b$.

```cpp
auto Pub = Dense<Field>(1, circuit->ninputs);
// ... fill only with public inputs ...
pub_filler.push_back(Fg.of_scalar(30)); // c known
pub_filler.push_back(Fg.zero());        // a masked
pub_filler.push_back(Fg.zero());        // b masked

auto verifier = ZkVerifier<Field, RSFactory>(*circuit, rsf, rate, req, Fg);
verifier.recv_commitment(zk_proof_verify, tp_verify);
bool result = verifier.verify(zk_proof_verify, Pub, tp_verify);
```

- **English**: The verifier reconstructs the public portion of the witness (filling private slots with zeros) and uses the `zk_proof` object to cryptographically verify that the constraints hold.
- **Korean**: 검증자는 위트니스의 공개 부분만 재구성하고(비공개 슬롯은 0으로 채움), `zk_proof` 객체를 사용하여 제약 조건이 성립함을 암호학적으로 검증합니다.
