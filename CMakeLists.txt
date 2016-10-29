cmake_minimum_required(VERSION 3.6)
project(atcommands)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR})

find_package(RAGEL 6.6 REQUIRED)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

RAGEL_TARGET(testragel test.rl ${CMAKE_CURRENT_BINARY_DIR}/testrl.c)

set(SOURCE_FILES
    ${RAGEL_testragel_OUTPUTS})

add_executable(atcommands ${SOURCE_FILES})
