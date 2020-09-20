NAME=wi2wic
GPRPATH=${NAME}.gpr

-include Makefile.conf

include Makefile.defaults

LIBNAME=lib${NAME}

ROOTDIR=.

build::
	$(GNATMAKE) -m -p -P "$(GPRPATH)" $(MAKE_ARGS)
