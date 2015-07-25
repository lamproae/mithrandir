SOURCE=$(APPS_DIR)/openssh/openssh-$(VERSION)
VERSION=6.9p1

all: build install 

build: config 
	@cd $(SOURCE) && make

config:
	@if [ ! -f $(SOURCE)/Makefile ]; then \
	    cd $(SOURCE) && ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS); \
	fi


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

.PHONY: config build clean install

#	@find $(SOURCE)/ -perm 775 | xargs -i sudo $(INSTALL) {} $(ROOT_DIR)/sbin
