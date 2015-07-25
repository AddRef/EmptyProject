# General variables
set(3RDPARTY_DIR ${ROOT_DIRECTORY}/3rdparty/_unpack)
# Boost config
if (WIN32)
    set (BOOST_DIR ${3RDPARTY_DIR}/boost_windows)
elseif(APPLE)
    set (BOOST_DIR ${3RDPARTY_DIR}/boost_mac)
else()
    set (BOOST_DIR ${3RDPARTY_DIR}/boost_linux)
endif()
set(Boost_USE_STATIC_LIBS       ON)
set(Boost_USE_STATIC_RUNTIME    ON)
set(Boost_USE_MULTITHREADED     ON)
set(BOOST_INCLUDEDIR ${BOOST_DIR}/include/)
set(BOOST_LIBRARYDIR ${BOOST_DIR}/libs/)
set(Boost_DEBUG ON)

# SDL config
set(SDL_STATIC OFF)
if (WIN32)
    add_definitions(-DSDL_VIDEO_OPENGL_EGL)
    add_definitions(-DSDL_VIDEO_OPENGL_ES2)
endif()

# Configure WinSDK
# if (WIN32)
#     if(${ARCH_64})
#         set (WINSDK_DIR ${3RDPARTY_DIR}/_unpack/WindowsKits/8.0/Lib/win8/um/x64)
#     else()
#         set (WINSDK_DIR ${3RDPARTY_DIR}/_unpack/WindowsKits/8.0/Lib/win8/um/x86)
#     endif()
#     set (CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${WINSDK_DIR})
# endif()

# find required packages
find_package(OpenGL REQUIRED)
find_package(Boost COMPONENTS log system thread log_setup REQUIRED)

