SOURCE=$(APPS_DIR)/inetutils/inetutils-$(VERSION)
VERSION=1.9.4

all: build install 

build: config 
	@cd $(SOURCE) && make

config:
	@if [ !-f "$(SOURCE)/Makefile" ]; then \
	    cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS); \
	fi


install:
	find $(SOURCE) -name "*d" !-name "*.valgrind" !-name "*.sed" | xargs -i sudo $(INSTALL) {} $(ROOT_DIR)/usr/sbin/

clean:
	@cd $(SOURCE) && make clean

.PHONY: config build clean install
