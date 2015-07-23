.PHONY: build config install all

SOURCE=$(APPS_DIR)/coreutils/coreutils-$(VERSION)
VERSION=8.24

all: 
#all: build install 

build: config 
	@cd $(SOURCE); \
	make 

config:
	@cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) --disable-werror


install:
	find $(SOURCE)/src -perm 775 ! -name ".deps" | xargs -i sudo $(INSTALL) {} $(ROOT_DIR)/bin/

clean:
	@cd $(SOURCE); \
	make clean

.PHONY: config build clean install
