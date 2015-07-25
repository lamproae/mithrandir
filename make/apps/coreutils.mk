SOURCE=$(APPS_DIR)/coreutils/coreutils-$(VERSION)
VERSION=8.24

all: build install 

build: config 
	@cd $(SOURCE) && make 

config:
	@if [ ! -f $(SOURCE)/Makefile ]; then \
	    cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) --disable-werror; \
	fi


install:
	find $(SOURCE)/src/ -perm 775 -a ! -name ".deps" -a ! -type d | xargs -i $(INSTALL) {} $(ROOT_DIR)/bin/

clean:
	@cd $(SOURCE) && make clean

.PHONY: config build clean install
