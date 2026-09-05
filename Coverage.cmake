function(enable_coverage target)
    if(CMAKE_BUILD_TYPE STREQUAL Debug)
        target_compile_options(${target} PRIVATE --coverage -fno-inline)
        target_link_options(${target} PUBLIC --coverage)
    endif()
endfunction()

function(clean_coverage target)
    add_custom_command(
        TARGET ${target}
        PRE_BUILD
        COMMAND find ${CMAKE_BINARY_DIR} -type f -name '*.gcda' -exec rm {} +
    )
endfunction()

function(add_coverage target)
    find_program(LCOV_PATH lcov)
    if(NOT LCOV_PATH)
        message(WARNING "lcov not found! Coverage target will not be created.")
        return()
    endif()

    find_program(GENHTML_PATH genhtml)
    if(NOT GENHTML_PATH)
        message(
            WARNING
            "genhtml not found! Coverage target will not be created."
        )
        return()
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        find_program(LLVM_COV_PATH NAMES llvm-cov llvm-cov-18)
        if(NOT LLVM_COV_PATH)
            message(WARNING "llvm-cov not found! Coverage target will not be created.")
            return()
        endif()

        set(LLVM_GCOV_PATH "${CMAKE_BINARY_DIR}/llvm-gcov")
        file(WRITE "${LLVM_GCOV_PATH}"
            "#!/bin/sh\nexec \"${LLVM_COV_PATH}\" gcov \"\\$@\"\n"
        )
        file(CHMOD "${LLVM_GCOV_PATH}" PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE
            GROUP_READ GROUP_EXECUTE
            WORLD_READ WORLD_EXECUTE
        )
        set(LCOV_TOOL_ARGS
            --gcov-tool "${LLVM_GCOV_PATH}"
            --ignore-errors mismatch,version,inconsistent
        )
        set(GENHTML_TOOL_ARGS --ignore-errors inconsistent)
    else()
        find_program(GCOV_PATH gcov)
        if(NOT GCOV_PATH)
            message(WARNING "gcov not found! Coverage target will not be created.")
            return()
        endif()
        set(LCOV_TOOL_ARGS --gcov-tool "${GCOV_PATH}")
        set(GENHTML_TOOL_ARGS)
    endif()

    add_custom_target(
        coverage-${target}
        COMMAND ${LCOV_PATH} ${LCOV_TOOL_ARGS} -d . --zerocounters
        COMMAND $<TARGET_FILE:${target}>
        COMMAND ${LCOV_PATH} ${LCOV_TOOL_ARGS} -d . --capture -o coverage.info
        COMMAND ${LCOV_PATH} ${LCOV_TOOL_ARGS} -r coverage.info '/usr/include/*' -o filtered.info
        COMMAND ${GENHTML_PATH} ${GENHTML_TOOL_ARGS} -o coverage-${target} filtered.info --legend
        COMMAND rm -rf coverage.info filtered.info
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )
endfunction()
