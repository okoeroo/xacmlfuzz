dnl Licensed under the Apache License, Version 2.0 (the "License");
dnl you may not use this file except in compliance with the License.
dnl You may obtain a copy of the License at
dnl 
dnl     http://www.apache.org/licenses/LICENSE-2.0
dnl 
dnl Unless required by applicable law or agreed to in writing, software
dnl distributed under the License is distributed on an "AS IS" BASIS,
dnl WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
dnl See the License for the specific language governing permissions and
dnl limitations under the License.
dnl 
dnl Authors:
dnl 2010-
dnl     Oscar Koeroo <okoeroo@nikhef.nl>
dnl     Mischa Sall\'e <msalle@nikhef.nl>
dnl     NIKHEF Amsterdam, the Netherlands
dnl
dnl Usage: AC_XACML
dnl  sets *_CFLAGS and *_LIBS

AC_DEFUN([AC_XACML],
[
    dnl Make sure autoconf (bootstrap) fails when macro is undefined
    ifdef([PKG_CHECK_MODULES],
          [],
          [m4_fatal([macro PKG_CHECK_MODULES is not defined])])

    AC_ARG_WITH([xacml-prefix],
		[AC_HELP_STRING([--with-xacml-prefix=DIR],
		    [Prefix where SAML2-XACML2-C-lib is installed (default /usr)])],
		[ac_xacml_prefix=$withval],
		[ac_xacml_prefix=/usr])

    AC_ARG_WITH([xacml-libdir],
                [AC_HELP_STRING([--with-xacml-libdir=DIR],
                    [Directory where SAML2-XACML2-C-lib libraries are installed (default either XACML-PREFIX/lib or XACML-PREFIX/lib64)])],
                [ac_xacml_libdir=$withval],
                [])

    if test "x$with_xacml_prefix" = "x" ; then
	PKG_CHECK_MODULES(XACML, xacml, have_xacml=yes, have_xacml=no)
	if test "$have_xacml" = "no" ; then
	    XACML_DIRECT_CHECK(XACML, have_xacml=yes, have_xacml=no)
	fi
    else
	XACML_DIRECT_CHECK(XACML, have_xacml=yes, have_xacml=no)
	if test "$have_xacml" = "no" ; then
	    PKG_CHECK_MODULES(XACML, xacml, have_xacml=yes, have_xacml=no)
	fi
    fi
    
    AC_SUBST(XACML_CFLAGS)
    AC_SUBST(XACML_LIBS)
])    

AC_DEFUN([XACML_DIRECT_CHECK],
[
    ac_save_LIBS=$LIBS
    ac_save_CFLAGS=$CFLAGS

    # check whether we have specified libdir otherwise specified a prefix
    if test "x$ac_xacml_libdir" != "x" -o "x$with_xacml_prefix" != "x" ; then
	# If we haven't specified/determined a libdir, do it now from prefix
        if test "x$ac_xacml_libdir" = "x" ; then
	    if test "x$host_cpu" = "xx86_64" \
	     -a -e $with_xacml_prefix/lib64 \
	     -a ! -h $with_xacml_prefix/lib64 ; then
		ac_xacml_libdir="$ac_xacml_prefix/lib64"
	    else
		ac_xacml_libdir="$ac_xacml_prefix/lib"
	    fi
	fi    

	if test "x$LD_LIBRARY_PATH" != "x" ; then
            ac_save_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH="$ac_xacml_libdir:$LD_LIBRARY_PATH"
        else
            export LD_LIBRARY_PATH="$ac_xacml_libdir"
        fi

        if test "x$DYLD_LIBRARY_PATH" != "x" ; then
            ac_save_DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH
            export DYLD_LIBRARY_PATH="$ac_xacml_libdir:$DYLD_LIBRARY_PATH"
        else
            export DYLD_LIBRARY_PATH="$ac_xacml_libdir"
        fi

	ac_try_CFLAGS="-I$ac_xacml_prefix/include"
	ac_try_LIBS="-L$ac_xacml_libdir -lxacml"
	AC_MSG_CHECKING([for $1 at system default and $ac_xacml_prefix])
    else
	ac_try_CFLAGS=""
	ac_try_LIBS="-lxacml"
	AC_MSG_CHECKING([for $1 at system default])
    fi

    dnl We want to add the cmdline specified CFLAGS and LIBS, but only for
    dnl checking, not to the *_CFLAGS etc.
    CFLAGS="$ac_try_CFLAGS $CFLAGS"
    LIBS="$ac_try_LIBS $LIBS"
    AC_LINK_IFELSE([AC_LANG_SOURCE( [#include <xacml.h>
		     int main(void) {return 0;}] )],
                    [have_mod=yes], [have_mod=no])
    AC_MSG_RESULT([$have_mod])

    if test "x$have_mod" = "xyes" ; then
	[$2]
	$1_CFLAGS=$ac_try_CFLAGS
	$1_LIBS="$ac_try_LIBS"
    else
	[$3]
	$1_CFLAGS=""
	$1_LIBS=""
    fi

    CFLAGS=$ac_save_CFLAGS
    CPPFLAGS=$ac_save_CPPFLAGS
    LIBS=$ac_save_LIBS

    if test "x$ac_save_LD_LIBRARY_PATH" = "x" ; then
	unset LD_LIBRARY_PATH
    else
	LD_LIBRARY_PATH=$ac_save_LD_LIBRARY_PATH
    fi
    if test "x$ac_save_DYLD_LIBRARY_PATH" = "x" ; then
	unset DYLD_LIBRARY_PATH
    else
	DYLD_LIBRARY_PATH=$ac_save_DYLD_LIBRARY_PATH
    fi
    if test "x$ac_save_LD_LIBRARY_PATH" = "x" ; then
        unset LD_LIBRARY_PATH
    else
        LD_LIBRARY_PATH=$ac_save_LD_LIBRARY_PATH
    fi
    if test "x$ac_save_DYLD_LIBRARY_PATH" = "x" ; then
        unset DYLD_LIBRARY_PATH
    else
        DYLD_LIBRARY_PATH=$ac_save_DYLD_LIBRARY_PATH
    fi

])
