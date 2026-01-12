# Zero-Knowledge Proof Process (`longfellow-zk`)

This document explains the internal process of the `zk_test_module`, which uses the `longfellow-zk` library to generate and verify proofs for the statement $a \times b = c$.

## 1. Circuit Definition
The logical relationship is defined using a "Circuit".
- **Inputs**:
    - **Public Input**: $c$ (The result of the multiplication).
    - **Private Inputs**: $a, b$ (The secret factors).
- **Gate Logic**:
    - An assertion is made: `ASSERT(a * b == c)`.
    - The circuit compiler translates this into constraints over a finite field (typically using R1CS or similar arithmetic representations under the hood).

## 2. Witness Preparation
A "Witness" is the set of values that satisfy the circuit constraints.
- The prover constructs a `Dense<Field>` vector containing:
    1. The constant `1` (for affine operations).
    2. The public input $c$.
    3. The private inputs $a$ and $b$.
- This witness is used to generate the proof but remains hidden (except for the public parts).

## 3. Proving Process (Prover)
The prover performs the following steps:
1.  **Commitment**: The prover commits to the witness using a commitment scheme (Ligero in this case). This involves encoding the witness using Reed-Solomon codes and Merkle trees.
2.  **Challenge (Fiat-Shamir)**: A random challenge is derived from the transcript (hashed state of public inputs and commitments). This makes the proof non-interactive.
3.  **Opening/Response**: The prover acts on the challenge to provide specific evaluations or columns of the committed data, proving that the constraints hold without revealing the private inputs.

## 4. Verification Process (Verifier)
The verifier performs the following steps:
1.  **Reconstruct Circuit**: The verifier builds the exact same circuit structure.
2.  **Public Input Setup**: The verifier constructs a witness vector containing *only* the public inputs. Private inputs are set to zero or placeholders.
3.  **Verify Commitment**: The verifier checks that the provided proof matches the commitment and satisfies the arithmetic constraints relative to the public inputs.

---

# 영지식 증명 프로세스 (`longfellow-zk`) (Korean)

이 문서는 `longfellow-zk` 라이브러리를 사용하여 $a \times b = c$ 명제에 대한 증명을 생성하고 검증하는 `zk_test_module`의 내부 프로세스를 설명합니다.

## 1. 회로 (Circuit) 정의
논리적 관계는 "회로(Circuit)"를 통해 정의됩니다.
- **입력값 (Inputs)**:
    - **공개 입력 (Public Input)**: $c$ (곱셈의 결과값).
    - **비공개 입력 (Private Inputs)**: $a, b$ (숨겨진 인수들).
- **게이트 로직 (Gate Logic)**:
    - `ASSERT(a * b == c)`와 같은 단언문(Assertion)이 작성됩니다.
    - 회로 컴파일러는 이를 유한체(Finite Field) 상의 제약 조건으로 변환합니다.

## 2. 위트니스 (Witness) 준비
"위트니스(Witness)"는 회로의 제약 조건을 만족하는 값들의 집합입니다.
- 증명자(Prover)는 다음을 포함하는 `Dense<Field>` 벡터를 생성합니다:
    1. 상수 `1` (아핀 연산을 위해).
    2. 공개 입력 $c$.
    3. 비공개 입력 $a$와 $b$.
- 이 위트니스는 증명을 생성하는 데 사용되지만, 공개된 부분을 제외하고는 숨겨집니다.

## 3. 증명 과정 (Prover)
증명자는 다음 단계들을 수행합니다:
1.  **커밋 (Commitment)**: 증명자는 커밋 스킴(이 경우 Ligero)을 사용하여 위트니스에 대한 커밋을 생성합니다. 이는 Reed-Solomon 코드와 Merkle 트리 등을 사용하여 위트니스를 인코딩하는 과정을 포함합니다.
2.  **챌린지 (Challenge)**: 트랜스크립트(공개 입력과 커밋의 해시 상태)로부터 무작위 챌린지 값을 생성합니다. 이를 통해 상호작용 없는(Non-interactive) 증명이 가능해집니다 (Fiat-Shamir 휴리스틱).
3.  **오픈/응답 (Opening/Response)**: 증명자는 챌린지에 대응하여 커밋된 데이터의 특정 부분이나 평가값을 제공함으로써, 비공개 입력을 드러내지 않고도 제약 조건을 만족함을 증명합니다.

## 4. 검증 과정 (Verifier)
검증자(Verifier)는 다음 단계들을 수행합니다:
1.  **회로 재구성**: 검증자는 증명자와 완전히 동일한 회로 구조를 생성합니다.
2.  **공개 입력 설정**: 검증자는 *오직* 공개 입력값만 포함하는 위트니스 벡터를 구성합니다. 비공개 입력 자리에는 0이나 임의의 값을 채웁니다.
3.  **증명 검증**: 검증자는 제출된 증명이 커밋과 일치하는지, 그리고 공개 입력에 대해 산술적 제약 조건을 만족하는지 확인합니다.
