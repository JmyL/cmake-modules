function(format target directory)
    find_program(CLANGFORMAT_PATH clang-format)
    if(NOT CLANGFORMAT_PATH)
        message(WARNING "clang-format not found! Format target will not work.")
        return()
    endif()
    set(EXPRESSION
        h
        hpp
        hh
        c
        cc
        cxx
        cpp
    )
    list(TRANSFORM EXPRESSION PREPEND "${directory}/*.")
    file(
        GLOB_RECURSE SOURCE_FILES
        FOLLOW_SYMLINKS
        LIST_DIRECTORIES false
        ${EXPRESSION}
    )
    add_custom_command(
        TARGET ${target}
        PRE_BUILD
        COMMAND ${CLANGFORMAT_PATH} -i --style=file ${SOURCE_FILES}
    )
endfunction()
