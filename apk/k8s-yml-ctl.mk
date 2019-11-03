# K8s Yaml 管理
# Version: 20191103


# ####################################
# Platform AREA
#		环境配置: env-dev.mk, env-prod.mk
# ####################################
# 加载环境变量
ifdef prod
	ENV_TYPE := prod
	YAML_EXT := .prod.yml
	-include ../env-prod.mk
else
	ENV_TYPE := dev
	YAML_EXT := .yml
	-include ../env-dev.mk
endif


# ####################################
# 外部参数 AREA
#		GROUP: 对应一个 目录 以及 namespace
#		UNIT: 对应一个 *.yml, *.prod.yml
# ####################################
GROUP := 
UNIT	:= 

# 衍生配置
NS		:= $(GROUP)
KUBECTL := kubectl -n $(NS)
YAML_DIR := ./$(GROUP)/yml


# ####################################
# 固件配置 AREA
# ####################################
DK	:= docker


# ####################################
# Dashboard AREA
# ####################################
status: verify-app
	$(KUBECTL) get svc && echo
	$(KUBECTL) get pods && echo
start: verify-app
	$(call doK8SByYml,$(UNIT),apply)
stop: verify-app
	$(call doK8SByYml,$(UNIT),delete)

ginit: verify-app
	kubectl get namespaces | grep $(NS) || kubectl create namespace $(NS)
gfini: verify-app
	kubectl get namespace $(NS) &>/dev/null && kubectl delete namespace $(NS) || true


# ####################################
# Init AREA
# ####################################
verify-app:
	@test -n "$(GROUP)" -a -n "$(UNIT)" || echo "usage: make GROUP=xx UNIT=yy {start|stop|status|log}"
	@test -n "$(GROUP)" -a -n "$(UNIT)" || false
	@echo "================== $(shell date +'%Y-%m-%d %H:%M:%S') ==================="
	@echo "Current env is: $(ENV_TYPE) $(DATE_DOT)"
	@echo "GROUP/UNIT: $(GROUP)/$(UNIT)"
	@echo "NS: $(GROUP)"
	@echo "================== $(shell date +'%Y-%m-%d %H:%M:%S') ==================="
	@echo


# ####################################
# Misc AREA
# ####################################
info: version image status
version:
	kubectl version && echo
image:
	cat $(YAML_DIR)/*.yml | grep "image:"
	@echo

# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm

define doK8SByYml
	$(KUBECTL) $(2) -f ./$(GROUP)/yml/$(1)$(YAML_EXT)
endef
