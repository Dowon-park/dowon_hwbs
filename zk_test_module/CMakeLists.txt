cmake_minimum_required(VERSION 3.14)
project(zk_test_module)

set(CMAKE_CXX_STANDARD 17)

# Suppress OpenSSL deprecation warnings
add_compile_definitions(OPENSSL_SUPPRESS_DEPRECATED=1)

include(FetchContent)

FetchContent_Declare(
  longfellow_zk
  GIT_REPOSITORY https://github.com/google/longfellow-zk.git
  GIT_TAG        main
)

FetchContent_GetProperties(longfellow_zk)
if(NOT longfellow_zk_POPULATED)
  FetchContent_Populate(longfellow_zk)
  add_subdirectory(${longfellow_zk_SOURCE_DIR}/lib ${longfellow_zk_BINARY_DIR})
endif()

find_package(OpenSSL REQUIRED)
# zstd is required by util. longfellow-zk might have found it, or we need to.
# If longfellow-zk uses 'zstd' target, we should be fine if we link 'util'.
# But we might need to find it if it's not exported.
find_package(PkgConfig)
pkg_check_modules(ZSTD libzstd)

add_executable(zk_proof_test zk_proof_test.cc)

# Link against object libraries from longfellow-zk
# Note: linking object libraries directly requires CMake 3.12+
target_link_libraries(zk_proof_test
    PRIVATE
    $<TARGET_OBJECTS:ec>
    $<TARGET_OBJECTS:algebra>
    $<TARGET_OBJECTS:util>
    OpenSSL::SSL
    OpenSSL::Crypto
)

if(ZSTD_FOUND)
    target_link_libraries(zk_proof_test PRIVATE ${ZSTD_LIBRARIES})
    target_include_directories(zk_proof_test PRIVATE ${ZSTD_INCLUDE_DIRS})
else()
    # Fallback: try to link -lzstd if pkg-config didn't work but library is present
    target_link_libraries(zk_proof_test PRIVATE zstd)
endif()

# Add compiler flags for performance/intrinsics (copied from longfellow-zk logic)
if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64")
    target_compile_options(zk_proof_test PRIVATE -mpclmul -maes)
endif()

# Ensure we can find headers
target_include_directories(zk_proof_test PRIVATE
    ${longfellow_zk_SOURCE_DIR}/lib
)
