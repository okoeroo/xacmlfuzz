# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Authors:
# 2012-
#    Oscar Koeroo <okoeroo@gmail.com>
#

AC_PREREQ(2.57)
AC_INIT([xacmlfuzz], [0.0.1])
AM_INIT_AUTOMAKE([1.6.3 subdir-objects foreign])
AC_CONFIG_MACRO_DIR([m4])

AC_COPYRIGHT([Copyright (c) 2012 Oscar Koeroo])

#Environment.
WORKDIR=`pwd`
AC_SUBST(WORKDIR)

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_MAKE_SET
AC_PROG_LIBTOOL
AM_PROG_CC_C_O
AC_PROG_INSTALL

# Set XACML variables
AC_XACML
if test "x$have_xacml" = "xno" ; then
    AC_MSG_FAILURE(["no SAML2-XACML2-C-library interface found"])
fi

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([dlfcn.h malloc.h stdlib.h string.h syslog.h unistd.h utime.h values.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_SIZE_T
AC_STRUCT_TM

# Checks for library functions.
AC_FUNC_CLOSEDIR_VOID
AC_FUNC_MALLOC
AC_FUNC_MEMCMP
AC_FUNC_REALLOC
AC_FUNC_STAT

# Check for OpenSSL/libcrypto
# Openssl is not even needed, it would seem
#AC_CHECK_LIB([ssl], [SSL_library_init])

# Configuration items
AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([src/Makefile])

AC_OUTPUT
