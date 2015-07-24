.EXPORT_ALL_VARIABLES:

include $(MAKE_DIR)/.rule

INSTALL		= 	sudo  install --owner=root --group=root -D --verbose

STRIP		= 	sudo strip
CP		=	sudo cp
CHOWN		=	sudo chown
CHGRP		=	sudo chgrp
CHMOD		=	sudo chmod

MAKE		=	make
MKDIR		=	mkdir

APP_MAKE = $(MAKE_DIR)/apps

APPS = $(wildcard $(APP_MAKE)/*.mk)

all: prepare build

prepare:
	$(MAKE) -f prepare.mk

build: apps modules rootfs kernel

rootfs:
	$(MAKE) -f rootfs.mk

apps:
	for i in $(APPS); do  \
	    $(MAKE) -f $$i; \
	done	

modules:

kernel: 
	$(MAKE) -f kernel.mk
	
clean:
	for i in $(APPS); do \
	    $(MAKE) -f $$i clean; \
	done	
	$(MAKE) -f kernel.mk clean

.PHONY: rootfs all apps modules kernel prepare
