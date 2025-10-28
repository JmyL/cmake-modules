enable_testing()

include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.15.2
)
# For Windows: Prevent overriding the parent project's
# compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
option(INSTALL_GMOCK "Install GMock" OFF)
option(INSTALL_GTEST "Install GTest" OFF)
FetchContent_MakeAvailable(googletest)

include(GoogleTest)
include(Coverage)
include(Memcheck)

macro(add_test_suite target)
    set(options NO_GTEST_MAIN)
    cmake_parse_arguments(TEST_SUITE "${options}" "" "" ${ARGN})

    add_coverage(${target})
    if(TEST_SUITE_NO_GTEST_MAIN)
        target_link_libraries(${target} PRIVATE gmock)
    else()
        target_link_libraries(${target} PRIVATE gtest_main gmock)
    endif()
    gtest_discover_tests(
        ${target}
        EXTRA_ARGS --gtest_color=yes
        PROPERTIES ENVIRONMENT "ASAN_OPTIONS=color=always"
    )
    add_memcheck(${target})
endmacro()
