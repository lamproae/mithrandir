SOURCE=$(APPS_DIR)/openssh/openssh-$(VERSION)
ZLIB_SOURCE=$(APPS_DIR)/openssh/zlib-$(ZLIB_VERSION)
OPENSSL_SOURCE=$(APPS_DIR)/openssh/openssl-$(OPENSSL_VERSION)
VERSION=4.5p1
ZLIB_VERSION=1.2.8
OPENSSL_VERSION=1.0.0p

all: build install 

build: config 
	@cd $(SOURCE) && make 
config: zlib openssl
	@if [ ! -f $(SOURCE)/Makefile ]; then \
	    cd $(SOURCE) && ./configure --host=$(ARCH) --with-zlib=$(ZLIB_SOURCE) --with-ssl-dir=$(OPENSSL_SOURCE) --with-openssl=$(OPENSSL_SOURCE) CFLAGS=$(CFLAGS)  LDFLAGS=$(LDFLAGS); \
	fi

# Do not run configure for openssl. It's disgusting.
openssl: 
	@cd $(OPENSSL_SOURCE) && make

zlib: zlib_config
	@cd $(ZLIB_SOURCE) && make

zlib_config:
	cd $(ZLIB_SOURCE) && ./configure 

install:
	$(INSTALL) $(SOURCE)/sshd $(ROOT_DIR)/sbin/
	$(INSTALL) $(SOURCE)/ssh $(ROOT_DIR)/sbin/
	$(INSTALL) $(SOURCE)/scp $(ROOT_DIR)/sbin/
	$(INSTALL) $(SOURCE)/sftp $(ROOT_DIR)/sbin/
	$(INSTALL) $(SOURCE)/ssh-agent $(ROOT_DIR)/sbin/
	$(INSTALL) $(SOURCE)/ssh-add $(ROOT_DIR)/sbin/
	$(INSTALL) $(SOURCE)/ssh-keygen $(ROOT_DIR)/sbin/
	$(INSTALL) $(SOURCE)/ssh-keysign $(ROOT_DIR)/sbin/
	$(INSTALL) $(SOURCE)/ssh-keyscan $(ROOT_DIR)/sbin/

clean:
	@cd $(SOURCE) && make clean

distclean:
	@cd $(SOURCE) && make distclean

.PHONY: config build clean install zlib

#	@find $(SOURCE)/ -perm 775 | xargs -i sudo $(INSTALL) {} $(ROOT_DIR)/sbin
