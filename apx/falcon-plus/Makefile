# Core of Open-Falcon
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
        --link=falcon-mysql:db.falcon \
        --link=falcon-redis:redis.falcon \
				-v $(DATA_DIR):/open-falcon/data \
				-v $(LOG_DIR):/open-falcon/logs \
        -e MYSQL_PORT=root:test123456@tcp\(db.falcon:3306\) \
        -e REDIS_PORT=redis.falcon:6379  \
        -p 18433:8433 \
        -p 18080:8080 \

# 镜像
DK_IMG	:= openfalcon/falcon-plus:v0.3

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
	$(DK) port $(NAME)

start: deps do-start status
stop: do-stop status

bash:
	$(DK) exec -it $(NAME) $(DK_CTL_ENTRY)

log:
	$(DK) logs $(NAME)

mon:
	$(DK) stats $(NAME

ginit:


# ####################################
# Deps AREA 依赖区域
# ####################################
deps:
	[ -d "$(DATA_DIR)" ] || mkdir -p "$(DATA_DIR)"
	[ -d "$(LOG_DIR)" ] || mkdir -p "$(LOG_DIR)"


# ####################################
# Implement AREA 固定写法
# ####################################
do-start:
	$(DK_RUN) --name $(NAME) -h $(NAME) $(DK_RUN_OPT) $(DK_ENTRY)
do-stop:
	-$(DK) stop $(NAME)
do-staus:
	$(DK) ps -a


# ####################################
# Utils AREA
# ####################################
clean:
	# 清理临时文件、无效的容器
	rm -rvf *.bak *.log
	$(DK) ps -a | awk '{print $1}' | grep -v CONTAINER | xargs $(DK) rm
