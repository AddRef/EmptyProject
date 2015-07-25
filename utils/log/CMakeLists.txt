cmake_minimum_required(VERSION 3.0.2)

add_library(log STATIC log.h src/log.cpp)
target_include_directories(log PUBLIC ${Boost_INCLUDE_DIR})
target_link_libraries(log ${Boost_LOG_LIBRARY} ${Boost_LOG_SETUP_LIBRARY} ${Boost_SYSTEM_LIBRARY} ${Boost_THREAD_LIBRARY})