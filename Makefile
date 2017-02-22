PROG=cfgtrack

install:
	cp src/cfgtrack /usr/bin/cfgtrack
	cp src/cfgtrack_mail /usr/bin/cfgtrack_mail
	gzip -c src/cfgtrack.1 > /usr/share/man/man1/cfgtrack.1.gz

uninstall:
	rm /usr/share/man/man1/cfgtrack.1.gz
	rm /usr/bin/cfgtrack_mail
	rm /usr/bin/cfgtrack
	echo "To remove configuration for cfgtrack, rm -rf /var/lib/cfgtrack/"

release: release_src release_deb release_rpm

release_src:
	@echo "Making release for version $(REL_VERSION)"

	@if [ -z "$(REL_VERSION)" ]; then echo "REL_VERSION required"; exit 1; fi

	# Prepare source
	rm -rf $(PROG)-$(REL_VERSION)
	mkdir $(PROG)-$(REL_VERSION)
	cp src/cfgtrack $(PROG)-$(REL_VERSION)/
	cp src/cfgtrack_mail $(PROG)-$(REL_VERSION)/
	cp src/cfgtrack.1 $(PROG)-$(REL_VERSION)/
	cp LICENSE.txt $(PROG)-$(REL_VERSION)/
	cp README.md $(PROG)-$(REL_VERSION)/
	cp contrib/release_Makefile $(PROG)-$(REL_VERSION)/Makefile

	# Bump version numbers
	find $(PROG)-$(REL_VERSION)/ -type f -print0 | xargs -0 sed -i "s/%%VERSION%%/$(REL_VERSION)/g" 

	# Create archives
	zip -r $(PROG)-$(REL_VERSION).zip $(PROG)-$(REL_VERSION)
	tar -vczf $(PROG)-$(REL_VERSION).tar.gz  $(PROG)-$(REL_VERSION)

	# Cleanup
	rm -rf $(PROG)-$(REL_VERSION)

release_deb:
	@if [ -z "$(REL_VERSION)" ]; then echo "REL_VERSION required"; exit 1; fi

	mkdir -p rel_deb/usr/bin
	mkdir -p rel_deb/usr/share/doc/$(PROG)
	mkdir -p rel_deb/usr/share/man/man1

	# Copy the source to the release directory structure.
	cp LICENSE.txt rel_deb/usr/share/doc/$(PROG)
	cp README.md rel_deb/usr/share/doc/$(PROG)
	cp src/$(PROG) rel_deb/usr/bin/$(PROG)
	cp src/$(PROG).1 rel_deb/usr/share/man/man1
	cp src/cfgtrack_mail rel_deb/usr/bin/
	cp -ar contrib/debian/DEBIAN rel_deb/

	# Bump version numbers
	find rel_deb/ -type f -print0 | xargs -0 sed -i "s/%%VERSION%%/$(REL_VERSION)/g" 

	# Create debian pacakge
	fakeroot dpkg-deb --build rel_deb > /dev/null
	mv rel_deb.deb $(PROG)-$(REL_VERSION).deb

	# Cleanup
	rm -rf rel_deb

release_rpm: release_deb
	alien -r -g -v cfgtrack-$(REL_VERSION).deb
	sed -i 's#%dir "/"##' cfgtrack-$(REL_VERSION)/cfgtrack-$(REL_VERSION)-2.spec
	sed -i 's#%dir "/usr/bin/"##' cfgtrack-$(REL_VERSION)/cfgtrack-$(REL_VERSION)-2.spec
	cd cfgtrack-$(REL_VERSION) && rpmbuild --target=noarch --buildroot $(shell readlink -f cfgtrack-$(REL_VERSION)) -bb cfgtrack-$(REL_VERSION)-2.spec 

clean:
	rm -rf *.tar.gz
	rm -rf *.zip
	rm -rf *.deb
	rm -rf rel_deb
	rm -rf cfgtrack-*
