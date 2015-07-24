all: etc lib

etc:
	$(CP) -a $(PROJECT_DIR)/samples/rootfs/etc $(ROOT_DIR)
	$(CHMOD) a+x $(ROOT_DIR)/etc/init.d/rcS
#	$(CHOWN) root -R $(ROOT_DIR)/etc
#	$(CHGRP) root -R $(ROOT_DIR)/etc

lib:
	$(CP) -a $(PROJECT_DIR)/samples/rootfs/lib $(ROOT_DIR)
#	$(CHOWN) root -R $(ROOT_DIR)/lib

.PHONY: all etc lib clean dir

