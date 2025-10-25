find_program(GPROF_EXECUTABLE gprof)
if(GPROF_EXECUTABLE)
    message(STATUS "gprof found: ${GPROF_EXECUTABLE}")
else()
    message(FATAL_ERROR "gprof not found on your system.")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
