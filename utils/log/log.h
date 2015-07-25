#pragma once
#pragma warning(disable : 4714) // disabled: function marked as _forceinline not inlined
#if defined(_MSC_VER)
    #pragma warning(push) // Save warning settings.
    #pragma warning(disable : 4512) // disabled: assignment operator couldn't be generated
    #pragma warning(disable : 4100) // disabled: unreferenced formal parameter
#endif 
#define BOOST_ALL_NO_LIB // disable automatic library loading
//#undef BOOST_LOG_DYN_LINK
#include "boost/log/trivial.hpp"
#if defined(_MSC_VER)
    #pragma warning(pop) // Restore warnings to previous state.
#endif 

#define U_LOG_TRACE()   BOOST_LOG_TRIVIAL(trace)
#define U_LOG_DEBUG()   BOOST_LOG_TRIVIAL(debug)
#define U_LOG_INFO()    BOOST_LOG_TRIVIAL(info)
#define U_LOG_WARNING() BOOST_LOG_TRIVIAL(warning)
#define U_LOG_ERROR()   BOOST_LOG_TRIVIAL(error)
#define U_LOG_FATAL()   BOOST_LOG_TRIVIAL(fatal)