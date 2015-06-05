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

set(SDL_STATIC OFF)
if (WIN32)
    set (BOOST_DIR ${3RDPARTY_DIR}/boost_windows/boost_windows)
elseif(APPLE)
    set (BOOST_DIR ${3RDPARTY_DIR}/boost_mac/boost_mac)
else()
    set (BOOST_DIR ${3RDPARTY_DIR}/boost_linux/boost_linux)
endif()

add_subdirectory(_unpack/gtest)
add_subdirectory(_unpack/lua)
add_subdirectory(_unpack/SDL2)

# import boost libraries
message(INFO "boost dir: ${BOOST_DIR}")
file(GLOB boost_files "${BOOST_DIR}/libs/*.ext")
foreach(file ${files})
	message(INFO ${file})
  #   find_library(libEGL libEGL)
  #   add_library(libEGL STATIC IMPORTED)
  #   set_target_properties(libEGL PROPERTIES IMPORTED_LOCATION ${ANGLE_DIR}/lib/libEGL.lib)

  # ... calculate ${i} to get the test name
  # add_test(validate_${i}, "validator", ${file})
endforeach()


set_property (TARGET gtest            PROPERTY FOLDER "3rdParty/gtest")
set_property (TARGET lua              PROPERTY FOLDER "3rdParty/lua")
set_property (TARGET SDL2             PROPERTY FOLDER "3rdParty/SDL")
set_property (TARGET SDL2main         PROPERTY FOLDER "3rdParty/SDL")
if (SDL_STATIC)
    set_property (TARGET SDL2-static      PROPERTY FOLDER "3rdParty/SDL")
endif()

set_target_properties(gtest PROPERTIES COMPILE_FLAGS -DGTEST_HAS_TR1_TUPLE=0)

