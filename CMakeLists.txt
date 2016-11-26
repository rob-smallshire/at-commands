cmake_minimum_required(VERSION 3.6)
project(atcommands)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR})

find_package(RAGEL 6.6 REQUIRED)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

#RAGEL_TARGET(parser parser.rl ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
RAGEL_TARGET(parser parser.rl ${CMAKE_CURRENT_SOURCE_DIR}/_parser.cpp)

set(SOURCE_FILES
    ${RAGEL_parser_OUTPUTS} commands.cpp commands.hpp radio.cpp radio.hpp)

add_executable(atcommands ${SOURCE_FILES})
