# Docker 镜像及容器 文件管理


# ####################################
# 外部参数 AREA
# 	BACKUP_DIR: 备份根目录
# ####################################
BACKUP_DIR := ../backup
BACKUP_IMG_DIR := $(BACKUP_DIR)/docker-images


# ####################################
# 固件配置 AREA
# ####################################
DK	:= docker


# ####################################
# Dashboard AREA
# ####################################
status:

backup: backup-imgs

restore: restore-imgs


# ####################################
# Backup AREA
# ####################################
backup-imgs:
	[ -d "$(BACKUP_IMG_DIR)" ] || mkdir -p "$(BACKUP_IMG_DIR)"
	for x in $(shell $(DK) images | grep -v REPOSITORY | grep -v '^<none>' | awk '{printf("%s:%s\n", $$1,$$2)}'); do \
		fname=`echo $$x | tr / _ | tr : _`; \
		fpath=$(BACKUP_IMG_DIR)/$${fname}.tar; \
		echo docker save $${x} -o $${fpath}; \
		docker save $${x} -o $${fpath}; \
	done;


# ####################################
# Restore AREA
# ####################################
restore-imgs:
	for x in `ls $(BACKUP_IMG_DIR)/*.tar`; do \
		echo docker load -i "$${x}"; \
		docker load -i "$${x}"; \
	done;


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
	