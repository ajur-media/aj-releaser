#!/usr/bin/make

PKG_ROOT = $(DESTDIR)/usr/local/etc/aj-releaser
PKG_LAUNCH = $(DESTDIR)/usr/local/bin

install: pkg_part
	find $(DESTDIR) -depth -name '.*' -exec rm -rf {} \;

pkg_part:
	install -d $(PKG_ROOT)
	install -d $(PKG_LAUNCH)
	cp ./ajr.sh $(PKG_ROOT)/
	cp ./lib.sh $(PKG_ROOT)/
	cp ./config.cfg $(PKG_ROOT)/
	cp ./pkgvars.cfg $(PKG_ROOT)/
	cp ./readme.txt $(PKG_ROOT)/
	ln -s /usr/local/etc/aj-releaser/ajr.sh $(PKG_LAUNCH)/ajr
	mkdir -p $(HOME)/.ajr