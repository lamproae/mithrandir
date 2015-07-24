SOURCE=$(KERNEL_DIR)/linux-$(VERSION)
VERSION=3.15.8

all: config-kernel build-kernel

config-kernel: $(BUILD_DIR)/.config


build-kernel:
	@cd $(SOURCE) && $(MAKE) O=$(BUILD_DIR)	


$(BUILD_DIR)/.config:
	@if [ !-f "$(BUILD_DIR)/.config" ]; then \
	    cd $(SOURCE) && $(MAKE) O=$(BUILD_DIR) defconfig \
	fi

clean:
	@cd $(SOURCE) && $(MAKE) O=$(BUILD_DIR)	clean

.PHONY: rootfs all apps modules kernel
