.PHONY: build config install all

SOURCE=$(APPS_DIR)/strace/strace-$(VERSION)
VERSION=4.8

all: build install 

build: config 
	@cd $(SOURCE); \
	make 

config:
	@cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) 


install:
	sudo $(INSTALL) $(SOURCE)/strace $(ROOT_DIR)/bin/strace
	$(STRIP) $(ROOT_DIR)/bin/strace

clean:
	@cd $(SOURCE); \
	make clean
