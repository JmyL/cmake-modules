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
add_compile_options($<$<COMPILE_LANGUAGE:CUDA>:-lineinfo>)

# See https://developer.nvidia.com/blog/separate-compilation-linking-cuda-device-code/
set(CMAKE_CUDA_SEPARABLE_COMPILATION ON)

# See https://github.com/clangd/clangd/discussions/1676
set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_INCLUDES 0)

# See https://cmake.org/cmake/help/latest/prop_tgt/CUDA_ARCHITECTURES.html
set(CMAKE_CUDA_ARCHITECTURES native)
