add_test([=[ECDSA.VerifyExternalP256]=]  /mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/ecdsa/verify_external_test [==[--gtest_filter=ECDSA.VerifyExternalP256]==] --gtest_also_run_disabled_tests)
set_tests_properties([=[ECDSA.VerifyExternalP256]=]  PROPERTIES WORKING_DIRECTORY /mnt/c/Users/dwp15/Antigravity/zk_test_module/build/_deps/longfellow_zk-build/circuits/ecdsa SKIP_REGULAR_EXPRESSION [==[\[  SKIPPED \]]==])
set(  verify_external_test_TESTS ECDSA.VerifyExternalP256)
