cmake_minimum_required(VERSION 3.0.2)
set_property (GLOBAL PROPERTY USE_FOLDERS ON)
project(EmptyProject)

include(cmake/utils.cmake)
include(cmake/config.cmake)
include(3rdParty/config.cmake)

update_compiler_settings()
check_apple_platform()

# Add projects
add_subdirectory(3rdParty)
add_subdirectory(main)
add_subdirectory(utils)
