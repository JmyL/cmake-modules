function(add_clangtidy target)
    find_program(CLANGTIDY_PATH clang-tidy)
    if(NOT CLANGTIDY_PATH)
        message(
            WARNING
            "clang-tidy not found! Clang-Tidy target will not work."
        )
        return()
    endif()

    set_target_properties(
        ${target}
        PROPERTIES CXX_CLANGTIDY "${CLANGTIDY_PATH}"
    )
endfunction()
