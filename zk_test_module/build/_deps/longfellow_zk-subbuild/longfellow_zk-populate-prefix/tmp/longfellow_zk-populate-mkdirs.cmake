# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-src"
  "/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build"
  "/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-subbuild/longfellow_zk-populate-prefix"
  "/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-subbuild/longfellow_zk-populate-prefix/tmp"
  "/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-subbuild/longfellow_zk-populate-prefix/src/longfellow_zk-populate-stamp"
  "/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-subbuild/longfellow_zk-populate-prefix/src"
  "/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-subbuild/longfellow_zk-populate-prefix/src/longfellow_zk-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-subbuild/longfellow_zk-populate-prefix/src/longfellow_zk-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-subbuild/longfellow_zk-populate-prefix/src/longfellow_zk-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
