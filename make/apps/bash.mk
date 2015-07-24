SOURCE=$(APPS_DIR)/bash/bash-$(VERSION)
VERSION=4.3

all: build install 

build: config 
	@cd $(SOURCE) && make

config:
	@if [ !-f "$(SOURCE)/Makefile" ]; then \
	    echo "-----------------------------------------------------"; \
	    echo "		Configure	Bash"			; \
	    echo "-----------------------------------------------------"; \
	    cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) --disable-werror; \
	if


install:
	$(INSTALL) $(SOURCE)/bash $(ROOT_DIR)/bin/bash
	$(STRIP) $(ROOT_DIR)/bin/bash
	@cd $(ROOT_DIR)/bin && ln -sf bash sh

clean:
	@cd $(SOURCE) && make clean

.PHONY: config build clean install
