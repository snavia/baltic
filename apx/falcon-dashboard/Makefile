# Dashboard for Open-Falcon
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
        --link=falcon-plus:api.falcon \
        -e API_ADDR=http://api.falcon:8080/api/v1 \
        -e PORTAL_DB_HOST=db.falcon \
        -e PORTAL_DB_PORT=3306 \
        -e PORTAL_DB_USER=root \
        -e PORTAL_DB_PASS=test123456 \
        -e PORTAL_DB_NAME=falcon_portal \
        -e ALARM_DB_HOST=db.falcon \
        -e ALARM_DB_PORT=3306 \
        -e ALARM_DB_USER=root \
        -e ALARM_DB_PASS=test123456 \
        -e ALARM_DB_NAME=alarms \
        -w /open-falcon/dashboard \
				-p 18081:8081 \

# 镜像
DK_IMG	:= openfalcon/falcon-dashboard:v0.2.1

# 入口
DK_ENTRY := -itd $(DK_IMG) './control startfg'
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
	$(DK) port $(NAME) 2>/dev/null || true

start: deps do-start status
stop: do-stop status

bash:
	$(DK) exec -it $(NAME) $(DK_CTL_ENTRY)

log:
	$(DK) logs $(NAME)
mon:
	$(DK) stats $(NAME)
port: # 错误不忽略
	$(DK) port $(NAME)

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


# ####################################
# Utils AREA
# ####################################
clean:
	# 清理临时文件、无效的容器
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
