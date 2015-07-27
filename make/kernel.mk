SOURCE=$(KERNEL_DIR)/linux-$(VERSION)
VERSION=3.15.8

all: show config-kernel build-kernel

show:
	@echo "--------------------------------------------------------------" 
	@echo "" 
	@echo "			Building "linux-$(VERSION)"		"	
	@echo ""  
	@echo "--------------------------------------------------------------" 

config-kernel: $(BUILD_DIR)/.config

build-kernel:
	@cd $(SOURCE) && $(MAKE) O=$(BUILD_DIR)	

$(BUILD_DIR)/.config:
	@if [ ! -f "$(BUILD_DIR)/.config" ]; then \
	    cd $(SOURCE) && $(MAKE) O=$(BUILD_DIR) defconfig; \
	fi
clean:
	@echo "--------------------------------------------------------------" 
	@echo "" 
	@echo "			Cleaning "linux-$(VERSION)"		"	
	@echo ""  
	@echo "--------------------------------------------------------------" 
	@cd $(SOURCE) && $(MAKE) O=$(BUILD_DIR)	clean

.PHONY: rootfs all apps modules kernel
