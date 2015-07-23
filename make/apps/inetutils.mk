.PHONY: build config install all

SOURCE=$(APPS_DIR)/inetutils/inetutils-$(VERSION)
VERSION=1.9.4

all: build install 

build: config 
	@cd $(SOURCE); \
	make 

config:
	@cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) --disable-werror


install:
	find $(SOURCE) -name "*d" | xargs -i sudo $(INSTALL) {} $(ROOT_DIR)/usr/sbin/

clean:
	@cd $(SOURCE); \
	make clean

.PHONY: config build clean install
