# MySQL for Open-Falcon
# Version: 20191031

PWD := $(shell pwd)
NAME := $(shell basename "$(PWD)")
DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")


# ####################################
# Congfigure AREA 配置参数区域
# ####################################
DATA_DIR := $(PWD)/data
LOG_DIR := $(PWD)/../../log/$(NAME)


# 启动参数
DK_RUN_OPT := \
				-v $(DATA_DIR):/var/lib/mysql \
				-v $(LOG_DIR):/var/log/mysql \
        -e MYSQL_ROOT_PASSWORD=test123456 \
        -p 13306:3306 \

# 镜像
DK_IMG	:= mysql:5.7

# 入口
DK_ENTRY := -d $(DK_IMG)
DK_CTL_ENTRY := /bin/bash

# 固定参数部分(根据需要可改为sudo docker)
# DK_RUN  := $(DK) run --rm --privileged -v/etc/localtime:/etc/localtime
DK := docker
DK_RUN  := $(DK) run --rm --privileged


# ####################################
# Dashboard AREA 核心区域
# ####################################
status:
	$(DK) images
	$(DK) ps -a
	$(DK) stats --no-stream
	-$(DK) port $(NAME)

start: deps do-start status
stop: do-stop status

bash:
	$(DK) exec -it $(NAME) $(DK_CTL_ENTRY)

log:
	$(DK) logs $(NAME)

mon:
	$(DK) stats $(NAME)

ginit: init-db


# ####################################
# Deps AREA 依赖区域
# ####################################
deps:
	[ -d "$(DATA_DIR)" ] || mkdir -p "$(DATA_DIR)"
	[ -d "$(LOG_DIR)" ] || mkdir -p "$(LOG_DIR)"

init-db:
	for x in `ls ./stub/*.sql`; do \
		echo init mysql table $$x ...; \
		$(DK) exec -i $(NAME) mysql -uroot -ptest123456 < "$$x"; \
	done


# ####################################
# Implement AREA 固定写法
# ####################################
do-start:
	$(DK_RUN) --name $(NAME) -h $(NAME) $(DK_RUN_OPT) $(DK_ENTRY)
do-stop:
	-$(DK) stop $(NAME)


# ####################################
# Utils AREA
# ####################################
clean:
	# 清理临时文件、无效的容器
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
