# K8s open-falcon 统一管理脚本
# Version: 20191103


# ####################################
# Auto AREA
# ####################################
PWD	:= $(shell pwd)


# ####################################
# 外部参数 AREA
#		GROUP: 对应一个 目录 以及 namespace
#		UNITS: 对应一组 *.yml, *.prod.yml
# 	UNIT_PORTAL: 观察视角, 查看集群状态
# ####################################
GROUP := $(shell basename $(PWD))
UNITS := mysql redis open-falcon-plus open-falcon-dashboard
UNIT_PORTAL := open-falcon-dashboard


# ####################################
# 固件配置 AREA
# ####################################
K8S_MK	:= make -C .. -f k8s-yml-ctl.mk 
DK			:= docker


# ####################################
# Dashboard AREA
# ####################################
status:
	$(K8S_MK) GROUP=$(GROUP) UNIT=$(UNIT_PORTAL) $@
info:
	$(K8S_MK) GROUP=$(GROUP) UNIT=$(UNIT_PORTAL) $@
start-all:
	$(call doBatExec,start)
stop-all:
	$(call doBatExec,stop)


ginit:
	$(K8S_MK) GROUP=$(GROUP) UNIT=$(UNIT_PORTAL) $@
ginit-post: import-mysql-baseline


# ####################################
# Init AREA
# ####################################
import-mysql-baseline:
	mysql_pod=$(shell kubectl get pods -n $(GROUP) | grep mysql | awk '{print $$1}') && \
	for x in `ls ./stub/*.sql`; do \
		echo init mysql table $${x} ...; \
		kubectl -n $(GROUP) exec $${mysql_pod} -- mysql -uroot -p123456 < $${x}; \
	done


# ####################################
# Utils AREA
# ####################################
clean:
	$(K8S_MK) $@

define doBatExec
	for x in $(UNITS); do \
		$(K8S_MK) GROUP=$(GROUP) UNIT=$${x} $(1); \
	done;
endef
