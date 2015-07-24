SOURCE=$(APPS_DIR)/strace/strace-$(VERSION)
VERSION=4.8

all: build install 

build: config 
	@cd $(SOURCE) && make 

config:
	@if [ !-f "$(SOURCE)/Makefile" ]; then \
	    cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS); \
	fi


install:
	$(INSTALL) $(SOURCE)/strace $(ROOT_DIR)/bin/strace
	$(STRIP) $(ROOT_DIR)/bin/strace

clean:
	@cd $(SOURCE) && make clean


.PHONY: build config install all clean
