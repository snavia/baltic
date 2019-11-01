# 基础设施容器管理
# Version: 20191101

# 启动参数
START_OPT := 

# 是否前台运行
ifndef FG
	START_OPT := $(START_OPT) -d
endif


# ####################################
# Dashboard AREA
# ####################################
ginit: init-data-dir


# ####################################
# Init AREA
# ####################################
init-data-dir:
	for x in $(shell sed -n "/# DATA-DIR-BEGIN/,/# DATA-DIR-END/p" .gitignore | grep -v "#"); do \
		echo "verify dir $$x"; \
		[ -d "$$x" ] || mkdir -p "$$x"; \
	done;


# ####################################
# #x. Mongo AREA
# ####################################
start-mongo:
	$(call doExecByCompose,mongo,up,$(START_OPT))
stop-mongo:
	$(call doExecByCompose,mongo,down)
log-mongo:
	$(call doExecByCompose,mongo,logs)
status-mongo:
	$(call doExecByCompose,mongo,port,mongo 27017)
	$(call doExecByCompose,mongo,top)


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
	docker-compose -f $(1).yml $(2) $(3)
endef
