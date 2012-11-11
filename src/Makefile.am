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

EXTRACOMPILEFLAGS = \
    -g -Wall \
    -O -Wuninitialized \
    -Wbad-function-cast -Wcast-align \
    -Wcast-qual -Wchar-subscripts -Winline \
    -Wmissing-prototypes -Wnested-externs -Wpointer-arith \
    -Wredundant-decls -Wshadow -Wstrict-prototypes \
    -Wpointer-arith -Wno-long-long

AM_CPPFLAGS = \
    -I$(top_srcdir)/src
    $(XACML_CFLAGS) \
    $(ADD_THESE_DEFINES)

bin_PROGRAMS = xacmlfuzz

xacmlfuzz_SOURCES = \
    xacml_io_example.h \
    xacml_io_example.c \
    main.c

xacmlfuzz_CFLAGS  = ${EXTRACOMPILEFLAGS}
xacmlfuzz_LDFLAGS = -lxacml
