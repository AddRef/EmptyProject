# the file contains useful macros for cmake build

# set MT property for C++ runtime
macro(force_multithreaded)
  if (MSVC)
    foreach (flag_var
             CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE 
             CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO
             CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
             CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO)
      string(REPLACE "/MD" "-MT" ${flag_var} "${${flag_var}}")
    endforeach()
  endif()
endmacro()

# increase warning level to W4
macro(force_warning_level)
  if (MSVC)
    foreach (flag_var
             CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
             CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO 
             CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
             CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO)
      string(REPLACE "/W3" "-W4" ${flag_var} "${${flag_var}}")
    endforeach()
  endif()
endmacro()

# increase warning level to W4
macro(disable_warning_level)
  if(MSVC)
    # Force to always compile with W4
    foreach (flag_var
             CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
             CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO 
             CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
             CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO)
      if(${flag_var} MATCHES "/W[0-4]")
        string(REGEX REPLACE "/W[0-4]" "/W0" ${flag_var} "${${flag_var}}")
      endif()
      if(${flag_var} MATCHES "-W[0-4]")
        string(REGEX REPLACE "-W[0-4]" "-W0" ${flag_var} "${${flag_var}}")
      endif()
    endforeach()
  endif()
endmacro()


# set all compiler properties (W4 and MT)
macro(update_compiler_settings)
  if (MSVC)
    foreach (flag_var
             CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE 
             CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO
             CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
             CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO)
        string(REPLACE "/MD" "-MT" ${flag_var} "${${flag_var}}")
        string(REPLACE "/W3" "-W4" ${flag_var} "${${flag_var}}")
    endforeach()
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -WX")
  endif()
endmacro()

# Check if we compile for iphone
macro(check_apple_platform)
  if(APPLE)
    include(CheckCSourceCompiles)
    check_c_source_compiles("
      #include \"TargetConditionals.h\"
      int main(int argc, char *argv[]) {
      #if !TARGET_OS_MAC
        -1
      #endif
      }
    " OS_OSX)
    check_c_source_compiles("
      #include \"TargetConditionals.h\"
      int main(int argc, char *argv[]) {
      #if !TARGET_OS_IPHONE
        -1
      #endif
      }
    " OS_IPHONE)
  endif()
endmacro()

function(bin2cpp in_file out_file)
    add_custom_command(
        OUTPUT ${out_file}
        COMMAND ${BIN2CPP} ${in_file} ${out_file}
        DEPENDS ${in_file}
    )
endfunction()
