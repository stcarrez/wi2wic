NAME=wi2wic
GPRPATH=${NAME}.gpr

-include Makefile.conf

include Makefile.defaults

LIBNAME=lib${NAME}

ROOTDIR=.

build::
	$(GNATMAKE) -m -p -P "$(GPRPATH)" $(MAKE_ARGS)

install::
	$(MKDIR) -p $(DESTDIR)$(prefix)/bin
	$(MKDIR) -p $(DESTDIR)$(prefix)/share/wi2wic/web
	$(INSTALL) bin/wi2wic-server $(DESTDIR)$(prefix)/bin
	(cd web && tar --exclude='*~' -cf - . )| (cd $(DESTDIR)${prefix}/share/wi2wic/web && tar xf -)

uninstall::
	rm -rf $(DESTDIR)$(prefix)/share/wi2wic $(DESTDIR)$(prefix)/bin/wi2wic-server
