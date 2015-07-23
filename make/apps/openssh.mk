.PHONY: build config install all

SOURCE=$(APPS_DIR)/openssh/openssh-$(VERSION)
VERSION=6.9p1

all: build install 

build: config 
	@cd $(SOURCE); \
	make 

config:
	@cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) --disable-werror


install:
	find $(SOURCE)/ -perm 775 | xargs -i sudo $(INSTALL) {} $(ROOT_DIR)/sbin/

clean:
	@cd $(SOURCE); \
	make clean

.PHONY: config build clean install
