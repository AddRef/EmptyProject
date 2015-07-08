cmake_minimum_required(VERSION 3.0.2)
include(../utils.cmake)

disable_warning_level()

message("Unpacking 3rdparty")
message("========================================================")
set (UNPACK_COMMAND python ${CMAKE_CURRENT_LIST_DIR}/unpack.py)
execute_process(COMMAND ${UNPACK_COMMAND} 
				RESULT_VARIABLE var 
				ERROR_VARIABLE err
				WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
if (rv) 
	message(${rv})
endif()
if (err)
	message(${err})
endif()
message("========================================================")

# variables
set(3RDPARTY_DIR ${ROOT_DIRECTORY}/3rdparty/_unpack)
set(SDL_STATIC OFF)
if (WIN32)
    set (BOOST_DIR ${3RDPARTY_DIR}/boost_windows)
elseif(APPLE)
    set (BOOST_DIR ${3RDPARTY_DIR}/boost_mac)
else()
    set (BOOST_DIR ${3RDPARTY_DIR}/boost_linux)
endif()
# export variables to root script
set(3RDPARTY_DIR ${3RDPARTY_DIR} PARENT_SCOPE)
# import boost libraries
# set hints for include and library folders for 'find_package' command
set(BOOST_INCLUDEDIR ${BOOST_DIR}/include/)
set(BOOST_LIBRARYDIR ${BOOST_DIR}/libs/)
find_package(Boost)

add_subdirectory(_unpack/gtest)
add_subdirectory(_unpack/lua)
add_subdirectory(_unpack/SDL2)

set_property (TARGET gtest            PROPERTY FOLDER "3rdparty/gtest")
set_property (TARGET lua              PROPERTY FOLDER "3rdparty/lua")
set_property (TARGET SDL2             PROPERTY FOLDER "3rdparty/SDL")
set_property (TARGET SDL2main         PROPERTY FOLDER "3rdparty/SDL")
if (SDL_STATIC)
    set_property (TARGET SDL2-static      PROPERTY FOLDER "3rdparty/SDL")
endif()

set_target_properties(gtest PROPERTIES COMPILE_FLAGS -DGTEST_HAS_TR1_TUPLE=0)

