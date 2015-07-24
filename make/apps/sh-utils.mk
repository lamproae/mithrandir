SOURCE=$(APPS_DIR)/sh-utils/sh-utils-$(VERSION)
VERSION=2.0

#all: build install 
all:  
	echo "This has problem"

build: config 
	@cd $(SOURCE) && make 

config:
	@if [ !-f "$(SOURCE)/Makefile" ]; then \
	    @cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS); \
	fi


install:
	sudo $(INSTALL) $(SOURCE)/env $(ROOT_DIR)/bin/env

clean:
	@cd $(SOURCE) && make clean

.PHONY: config build clean install
