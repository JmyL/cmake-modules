find_package(CUDAToolkit)

if(NOT CUDAToolkit_FOUND)
    message(FATAL_ERROR "CUDA Toolkit NOT found!")
endif()

message(STATUS "CUDA Toolkit found!")
message(STATUS "Host compiler: ${CMAKE_CXX_COMPILER}")
set(CMAKE_CUDA_HOST_COMPILER
    "${CMAKE_CXX_COMPILER}"
    CACHE FILEPATH
    "Host compiler for NVCC"
)
enable_language(CUDA) # Enables CUDA language support
include_directories(${CUDAToolkit_INCLUDE_DIRS})

if(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo" OR CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -lineinfo")
endif()
