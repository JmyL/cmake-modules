function(add_cppcheck target)
    find_program(CPPCHECK_PATH cppcheck)
    if(NOT CPPCHECK_PATH)
        message(WARNING "cppcheck not found! Coverage target will not work.")
        return()
    endif()

    set_target_properties(
        ${target}
        PROPERTIES
            CXX_CPPCHECK
                "${CPPCHECK_PATH};--enable=style,performance,portability;--error-exitcode=10;--std=c++${CMAKE_CXX_STANDARD};--suppress=missingIncludeSystem"
    )
endfunction()
