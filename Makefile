.EXPORT_ALL_VARIABLES:

PROJECT_DIR	=	$(PWD)
MAKE_DIR	=	$(PROJECT_DIR)/make
APPS_DIR	=	$(PROJECT_DIR)/apps
MODULES_DIR	=	$(PROJECT_DIR)/modules
KERNEL_DIR	=	$(PROJECT_DIR)/kernel
SCRIPT_DIR	=	$(PROJECT_DIR)/script

BUILD_DIR	=	$(PROJECT_DIR)/build
ROOT_DIR	=	$(PROJECT_DIR)/rootfs

PLATFORM	:=	$(board)

ifeq ($(PLATFORM),)
    $(error Please set the target platform!) 
endif

all: prepare build 

boot:
	$(SCRIPT_DIR)/boot.sh

prepare: 
	@case $(PLATFORM) in  \
		x86_64 | arm)	\
			ln -sf $(PROJECT_DIR)/make/rule/$(PLATFORM).mk $(PROJECT_DIR)/make/.rule;;  \
		*) 	\
			echo "Unsupported archetecture!";;  \
	esac

build:
	$(MAKE) -C $(PROJECT_DIR)/make all

clean:
	$(MAKE) -C $(PROJECT_DIR)/make clean


.PHONY: all build clean prepare make