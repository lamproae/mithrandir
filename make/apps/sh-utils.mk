.PHONY: build config install all

SOURCE=$(APPS_DIR)/sh-utils/sh-utils-$(VERSION)
VERSION=2.0

#all: build install 
all:  

build: config 
	@cd $(SOURCE); \
	make 

config:
	@cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) --disable-werror


install:
	sudo $(INSTALL) $(SOURCE)/env $(ROOT_DIR)/bin/env

clean:
	@cd $(SOURCE); \
	make clean

.PHONY: config build clean install
