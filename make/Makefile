.EXPORT_ALL_VARIABLES:

include $(MAKE_DIR)/.rule

INSTALL		= install --owner=root --group=root -D --verbose
STRIP		= strip

APP_MAKE = $(MAKE_DIR)/apps

APPS = $(wildcard $(APP_MAKE)/*.mk)

all: apps modules rootfs kernel

rootfs:

apps:
	for i in $(APPS); do \
	    $(MAKE) -f $$i; \
# 	    $(MAKE) -f $$i || exit 1; \
	done	

modules:

kernel:


.PHONY: rootfs all apps modules kernel
