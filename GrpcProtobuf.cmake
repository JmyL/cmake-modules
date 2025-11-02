find_package(Protobuf CONFIG REQUIRED)
message(STATUS "Using Protobuf ${Protobuf_VERSION}")
find_program(_PROTOBUF_PROTOC protoc)

find_package(gRPC CONFIG REQUIRED)
message(STATUS "Using gRPC ${gRPC_VERSION}")
find_program(_GRPC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)

function(add_proto_target TARGET_NAME PROTO_FILE)
    get_filename_component(STEM ${PROTO_FILE} NAME_WE)
    get_filename_component(PROTO_ABS ${PROTO_FILE} ABSOLUTE)
    get_filename_component(PROTO_DIR ${PROTO_ABS} DIRECTORY)
    set(GEN_SRC "${CMAKE_CURRENT_BINARY_DIR}/${STEM}.pb.cc")
    set(GEN_HDR "${CMAKE_CURRENT_BINARY_DIR}/${STEM}.pb.h")
    set(GEN_GRPC_SRC "${CMAKE_CURRENT_BINARY_DIR}/${STEM}.grpc.pb.cc")
    set(GEN_GRPC_HDR "${CMAKE_CURRENT_BINARY_DIR}/${STEM}.grpc.pb.h")

    add_custom_command(
        OUTPUT ${GEN_SRC} ${GEN_HDR} ${GEN_GRPC_SRC} ${GEN_GRPC_HDR}
        COMMAND ${_PROTOBUF_PROTOC}
        ARGS
            --grpc_out=${CMAKE_CURRENT_BINARY_DIR}
            --cpp_out=${CMAKE_CURRENT_BINARY_DIR} -I ${PROTO_DIR}
            --plugin=protoc-gen-grpc=${_GRPC_CPP_PLUGIN_EXECUTABLE} ${PROTO_ABS}
        DEPENDS ${PROTO_ABS}
        COMMENT "Generating C++ code from ${PROTO_FILE}"
        VERBATIM
    )

    add_library(${TARGET_NAME} ${GEN_SRC} ${GEN_GRPC_SRC})
    target_include_directories(
        ${TARGET_NAME}
        PUBLIC ${CMAKE_CURRENT_BINARY_DIR}
    )
    target_link_libraries(
        ${TARGET_NAME}
        PUBLIC gRPC::grpc++_reflection gRPC::grpc++ protobuf::libprotobuf
    )
endfunction()
