include(CPM)
cpmaddpackage(
  NAME benchmark
  GITHUB_REPOSITORY google/benchmark
  VERSION 1.9.4
  OPTIONS "BENCHMARK_ENABLE_TESTING Off"
)

set(BENCHMARK_COMPARE_SRC "${benchmark_SOURCE_DIR}/tools/compare.py")
set(BENCHMARK_COMPARE_LINK "${CMAKE_BINARY_DIR}/compare.py")

if(EXISTS "${BENCHMARK_COMPARE_SRC}")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E create_symlink
            "${BENCHMARK_COMPARE_SRC}" "${BENCHMARK_COMPARE_LINK}"
        RESULT_VARIABLE symlink_result
    )
    if(NOT symlink_result EQUAL 0)
        message(WARNING "Failed to create symlink for compare.py")
    endif()
endif()

# if(benchmark_ADDED)
#   # enable c++11 to avoid compilation errors
#   set_target_properties(benchmark PROPERTIES CXX_STANDARD 11)
# endif()

macro(add_benchmark target)
    target_link_libraries(${target} PRIVATE benchmark::benchmark_main)
endmacro()
