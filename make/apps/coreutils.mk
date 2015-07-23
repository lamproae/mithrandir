.PHONY: build config install all

SOURCE=$(APPS_DIR)/ltrace/ltrace-$(VERSION)
VERSION=0.7.3

all: build install 

build: config 
	@cd $(SOURCE); \
	make 

config:
	@cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) --disable-werror


install:
	sudo $(INSTALL) $(SOURCE)/ltrace $(ROOT_DIR)/bin/ltrace

clean:
	@cd $(SOURCE); \
	make clean

.PHONY: config build clean install
