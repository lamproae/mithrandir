.EXPORT_ALL_VARIABLES:

include $(MAKE_DIR)/.rule
include $(SCRIPT_DIR)/function.mk

INSTALL		= sudo  install --owner=root --group=root -D --verbose

CP		= sudo cp
CHOWN		= sudo chown
CHGRP		= sudo chgrp
CHMOD		= sudo chmod

DEPMOD		= /sbin/depmod
KALLSYMS	= scripts/kallsyms
PERL		= perl
CHECK		= sparse
MAKE		= make
MKDIR		= mkdir
AWK		= awk
SED		= sed

AR		=$(CROSS_COMPILE)ar
LD		=$(CROSS_COMPILE)ld
CC		=$(CROSS_COMPILE)gcc
CXX		=$(CROSS_COMPILE)g++
AS		=$(CROSS_COMPILE)as
nm		=$(CROSS_COMPILE)nm
STRIP		=$(CROSS_COMPILE)strip
RANLIB		=$(CROSS_COMPILE)ranlib
OBJCOPY		=$(CROSS_COMPILE)objcopy
OBJDUMP		=$(CROSS_COMPILE)objdump


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
