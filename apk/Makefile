# K8s 统一管理脚本
# Version: 20191102


# ####################################
# Platform AREA
#		环境配置: env-dev.mk, env-prod.mk
# ####################################


# ####################################
# 外部参数 AREA
#		GROUP: 对应一个 目录 以及 namespace
#		UNIT: 对应一个 *.yml, *.prod.yml
# ####################################


# ####################################
# 固件配置 AREA
# ####################################
K8S_MK	:= make -f k8s-yml-ctl.mk
DK			:= docker

# ####################################
# Dashboard AREA
# ####################################
status: 
	$(K8S_MK) $@
start: 
	$(K8S_MK) $@
stop:
	$(K8S_MK) $@

ginit:
	$(K8S_MK) $@
gfini:
	$(K8S_MK) $@


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
