# open-falcon 部署脚本
# https://github.com/open-falcon/falcon-plus

# Enable the go modules feature
export GO111MODULE=on
# Set the GOPROXY environment variable
export GOPROXY=https://goproxy.io

SRC_DIR := ../../3rd/open-falcon/falcon-plus
DEST_DIR := ../../docker/open-falcon
DEST_MYSQL_SCP_DIR	:= ../../apx/falcon-mysql/stub

build:
	cd $(SRC_DIR) && go mod init && cd -
	make -C $(SRC_DIR)

install: build
	[ -d "$(DEST_DIR)" ] || mkdir -p "$(DEST_DIR)"
	rsync -avP $(SRC_DIR)/bin $(DEST_DIR)/
	rsync -avP $(SRC_DIR)/config $(DEST_DIR)/
	rsync -avP $(SRC_DIR)/docker $(DEST_DIR)/
	rsync -avP $(SRC_DIR)/logos $(DEST_DIR)/
	rsync -avP $(SRC_DIR)/scripts $(DEST_DIR)/
	rsync -avP $(SRC_DIR)/open-falcon $(DEST_DIR)/
	rsync -avP $(SRC_DIR)/logo.png $(DEST_DIR)/
	[ -d "$(DEST_MYSQL_SCP_DIR)" ] || mkdir -p "$(DEST_MYSQL_SCP_DIR)"
	rsync -avP $(SRC_DIR)/scripts/mysql/db_schema/ $(DEST_MYSQL_SCP_DIR)/
