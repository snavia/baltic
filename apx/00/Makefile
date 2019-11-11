# 基础设施容器管理
# Version: 20191101


# ####################################
# Platform AREA
#		环境配置: env-dev.mk, env-prod.mk
# ####################################
# 加载环境变量
ifdef prod
	-include ../env-prod.mk
else
	-include ../env-dev.mk
endif


# ####################################
# 外部参数 AREA
# 	APP: APP_NAME
# 	CMD: docker exec 命令
# 	START_OPT: 启动参数
# 	FG: 是否前台执行
# ####################################
APP	:= 
CMD	:= /bin/bash

START_OPT := 

ifndef FG
	START_OPT := $(START_OPT) -d
endif


# ####################################
# 固件配置 AREA
# ####################################
DK	:= docker


# ####################################
# Dashboard AREA
# ####################################
start: verify-app
	$(call doExecByCompose,$(APP),up,$(START_OPT))
	$(DK) ps -a
stop: verify-app
	$(call doExecByCompose,$(APP),down)
	$(DK) ps -a
log: verify-app
	$(call doExecByCompose,$(APP),logs)
status: verify-app
	$(call doExecByCompose,$(APP),top)
sh: verify-app
	$(DK) exec -it $(CONTAINER_PREFIX)$(APP) $(CMD)
bash: sh

ginit: init-data-dir


# ####################################
# Init AREA
# ####################################
init-data-dir:
	# 注: 此处若包装函数，makefile执行，会报错
	for x in $(shell sed -n "/# DATA-DIR-BEGIN/,/# DATA-DIR-END/p" .gitignore | grep -v "#"); do \
		echo "verify dir $$x"; \
		[ -d "$$x" ] || mkdir -p "$$x"; \
	done;
	for x in $(shell sed -n "/# LOG-DIR-BEGIN/,/# LOG-DIR-END/p" deps.gitignore | grep -v "#"); do \
		echo "verify dir $$x"; \
		[ -d "$$x" ] || mkdir -p "$$x"; \
	done;

verify-app:
	@echo "Current env is: $(ENV_TYPE) $(DATE_DOT)"
	@test -n "$(APP)" || echo "usage: make {start|stop|status|log} APP=xx"
	@test -n "$(APP)" || false >/dev/null


# ####################################
# Spec AREA
# ####################################


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm

define doExecByMake
	make -C $(1) $(2)
endef

define doExecByCompose
	docker-compose -f $(1)$(YAML_EXT) $(2) $(3)
endef


# ####################################
# Recy AREA
# ####################################
# DATA_DIR_LIST := ${ shell sed -n "/# DATA-DIR-BEGIN/,/# DATA-DIR-END/p" .gitignore }
# LOG_DIR_LIST  := $( shell sed -n "/# LOG-DIR-BEGIN/,/# LOG-DIR-END/p" deps.gitignore | grep -v "#" )
# define doMkdir
# 	for x in $(1); do \
# 		echo "verify dir $$x"; \
# 		[ -d "$$x" ] || mkdir -p "$$x"; \
# 	done;
# endef
