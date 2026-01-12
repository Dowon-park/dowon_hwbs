# Install script for directory: /mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-src/lib

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/testing/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/util/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/algebra/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/arrays/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/merkle/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/ligero/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/proto/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/random/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/sumcheck/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/gf2k/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/cbor/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/ec/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/zk/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/anoncred/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/base64/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/cbor_parser/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/compiler/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/ecdsa/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/jwt/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/logic/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/mac/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/mdoc/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/sha/cmake_install.cmake")
  include("/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/sha3/cmake_install.cmake")

endif()

