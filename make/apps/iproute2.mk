SOURCE=$(APPS_DIR)/iproute2/iproute2-$(VERSION)
VERSION=4.0.0

all: build install 

build: config 
	@cd $(SOURCE) && $(MAKE)

config:
	cd $(SOURCE) && ./configure --host=$(ARCH) CC=$(CC) CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS)

install:
	@cd $(SOURCE) && $(MAKE) DESTDIR=$(ROOT_DIR) install

clean:
	@cd $(SOURCE) && $(MAKE) clean

distclean:
	@cd $(SOURCE) && $(MAKE) distclean


.PHONY: build config install all clean
