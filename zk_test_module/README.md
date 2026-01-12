# zk_test_module Documentation

This module demonstrates how to generate and verify Zero-Knowledge (ZK) proofs using the `longfellow-zk` library. Specifically, it proves knowledge of factors $a$ and $b$ such that $a \times b = c$, where $c$ is a public input.

## Prerequisites

- **OS**: Windows (via WSL2) or Linux (Ubuntu 20.04+ recommended)
- **Compiler**: GCC 10+ or Clang 12+ (Must support C++17)
- **Build System**: CMake 3.14+
- **Dependencies**: OpenSSL (libssl-dev), pkg-config

For a detailed explanation of the internal ZK process, see [ZK_PROCESS.md](ZK_PROCESS.md).
For a deep dive into the code implementation, see [ZK_PROOF_TEST_DETAILS.md](ZK_PROOF_TEST_DETAILS.md).

## Building the Project

This project is designed to run in a Linux environment (like WSL on Windows).

1.  **Open WSL Terminal**
    Open your terminal (e.g., PowerShell or Command Prompt) and enter WSL:
    ```bash
    wsl
    ```

2.  **Navigate to the project directory**
    ```bash
    cd /mnt/c/Users/dwp15/Antigravity/zk_test_module
    ```

3.  **Configure the project**
    Create a build directory and run CMake:
    ```bash
    cmake -S . -B build
    ```

4.  **Build the executable**
    Compile the code:
    ```bash
    cmake --build build
    ```

## Running the Test

Run the generated executable from the build directory:

```bash
./build/zk_proof_test
```

### Expected Output

If successful, you should see output similar to this:

```text
Starting ZK Proof Test...
Defining Circuit...
Circuit created. Inputs: 4
Creating Witness...
Public Key (c): 0x1e000000...
...
Generating Proof...
Proof Generated. Size: ... bytes (approx)
...
Verifying Proof...
SUCCESS: Proof verified successfully!
```

---

# zk_test_module 문서 (Korean)

이 모듈은 `longfellow-zk` 라이브러리를 사용하여 영지식 증명(Zero-Knowledge Proof)을 생성하고 검증하는 방법을 보여줍니다. 구체적으로, $a \times b = c$인 $a$와 $b$를 알고 있다는 것을 증명합니다 ($c$는 공개 입력).

## 필수 조건

- **운영체제**: Windows (WSL2 사용) 또는 Linux (Ubuntu 20.04+ 권장)
- **컴파일러**: GCC 10+ 또는 Clang 12+ (C++17 지원 필수)
- **빌드 시스템**: CMake 3.14+
- **의존성**: OpenSSL (libssl-dev), pkg-config

## 프로젝트 빌드 방법

이 프로젝트는 Linux 환경(Windows의 경우 WSL)에서 실행되도록 설계되었습니다.

1.  **WSL 터미널 열기**
    터미널(PowerShell 또는 CMD)을 열고 WSL로 진입합니다:
    ```bash
    wsl
    ```

2.  **프로젝트 디렉토리로 이동**
    ```bash
    cd /mnt/c/Users/dwp15/Antigravity/zk_test_module
    ```

3.  **프로젝트 설정**
    빌드 디렉토리를 생성하고 CMake를 실행합니다:
    ```bash
    cmake -S . -B build
    ```

4.  **실행 파일 빌드**
    코드를 컴파일합니다:
    ```bash
    cmake --build build
    ```

## 테스트 실행

빌드 디렉토리에서 생성된 실행 파일을 실행합니다:

```bash
./build/zk_proof_test
```

### 예상 출력 결과

성공할 경우 다음과 같은 출력을 확인할 수 있습니다:

```text
Starting ZK Proof Test...
Defining Circuit...
Circuit created. Inputs: 4
Creating Witness...
Public Key (c): 0x1e000000...
...
Generating Proof...
Proof Generated. Size: ... bytes (approx)
...
Verifying Proof...
SUCCESS: Proof verified successfully!
```
