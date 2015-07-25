SOURCE=$(APPS_DIR)/iproute2

all: build install 

build: config 
	@cd $(SOURCE) && $(MAKE)

config:
	@if [ ! -f $(SOURCE)/Makefile ]; then \
	    cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS); \
	fi


install:
	@cd $(SOURCE) && $(MAKE) DESTDIR=$(ROOT_DIR) install

clean:
	@cd $(SOURCE) && $(MAKE) clean


.PHONY: build config install all clean
