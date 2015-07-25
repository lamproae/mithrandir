.EXPORT_ALL_VARIABLES:

include $(MAKE_DIR)/.rule
include $(SCRIPT_DIR)/function.mk

INSTALL		= 	sudo  install --owner=root --group=root -D --verbose

STRIP		= 	sudo strip
CP		=	sudo cp
CHOWN		=	sudo chown
CHGRP		=	sudo chgrp
CHMOD		=	sudo chmod

MAKE		=	make
MKDIR		=	mkdir

APP_MAKE = $(MAKE_DIR)/apps

# APPS = $(wildcard $(APP_MAKE)/*.mk)
APPS = $(basename $(notdir $(wildcard $(APP_MAKE)/*.mk)))

all: prepare build

prepare:
	$(call print_build, $@)
	$(MAKE) -f $@.mk

build: apps modules rootfs kernel

rootfs:
	$(MAKE) -f $@.mk

apps:
	@for i in $(APPS); do  \
	    echo "--------------------------------------------------------------" ; \
	    echo "" ; \
	    echo "			Building "$$i"		";	\
	    echo "" ; \
	    echo "--------------------------------------------------------------"; \
	    $(MAKE) -f apps/$$i.mk || exit 1; \
	done	

modules:

kernel: 
	$(MAKE) -f $@.mk

config:
	@for i in $(APPS); do  \
	    echo "--------------------------------------------------------------" ; \
	    echo "" ; \
	    echo "			Configuring "$$i"		";	\
	    echo "" ; \
	    echo "--------------------------------------------------------------"; \
	    $(MAKE) -f apps/$$i.mk $@ || exit 1; \
	done	
	$(MAKE) -f kernel.mk $@

clean:
	for i in $(APPS); do \
	    echo "--------------------------------------------------------------" ; \
	    echo "" ; \
	    echo "			Cleaning "$$i"		";	\
	    echo "" ; \
	    echo "--------------------------------------------------------------"; \
	    $(MAKE) -f apps/$$i.mk $@ || exit 1; \
	done	
	$(MAKE) -f kernel.mk $@ 

distclean:
	for i in $(APPS); do \
	    $(MAKE) -f apps/$$i.mk $@ || exit 1; \
	done	

.PHONY: rootfs all apps modules kernel prepare config
