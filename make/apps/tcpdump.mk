SOURCE=$(APPS_DIR)/tcpdump/tcpdump-$(VERSION)
LIBPCAP=$(APPS_DIR)/tcpdump/libpcap-$(LIBPCAP_VERSION)
VERSION=4.7.4
LIBPCAP_VERSION=1.6.2

all: libpcap tcpdump

tcpdump: config build install

build: config 
	@cd $(SOURCE) && $(MAKE)

config: libpcap-config libpcap-build
	@if [ ! -f $(SOURCE)/Makefile ]; then \
	    cd $(SOURCE) && ./configure --libdir=$(LIBPCAP) CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS); \
	fi

libpcap: libpcap-config libpcap-build libpcap-install


libpcap-config:
	@if [ ! -f $(LIBPCAP)/Makefile ]; then \
	    cd $(LIBPCAP) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS); \
	fi

libpcap-build:
	@cd $(LIBPCAP) && $(MAKE)


libpcap-install:
	@cd $(LIBPCAP) && $(MAKE) DESTDIR=$(ROOT_DIR) install

install:
	@cd $(SOURCE) && $(MAKE) DESTDIR=$(ROOT_DIR) install

clean:
	@cd $(LIBPCAP) && $(MAKE) clean
	@cd $(SOURCE) && $(MAKE) clean

distclean:
	@cd $(LIBPCAP) && $(MAKE) distclean
	@cd $(SOURCE) && $(MAKE) distclean

.PHONY: build config install all clean
