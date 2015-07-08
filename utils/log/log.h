#pragma once
#include "boost/log/trivial.hpp"

#define U_LOG_TRACE()   BOOST_LOG_TRIVIAL(trace)
#define U_LOG_DEBUG()   BOOST_LOG_TRIVIAL(debug)
#define U_LOG_INFO()    BOOST_LOG_TRIVIAL(info)
#define U_LOG_WARNING() BOOST_LOG_TRIVIAL(warning)
#define U_LOG_ERROR()   BOOST_LOG_TRIVIAL(error)
#define U_LOG_FATAL()   BOOST_LOG_TRIVIAL(fatal)