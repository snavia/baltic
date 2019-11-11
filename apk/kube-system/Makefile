# K8s kube-system 统一管理脚本
# Version: 20191103


# ####################################
# Auto AREA
# ####################################
PWD	:= $(shell pwd)


# ####################################
# 外部参数 AREA
# GROUP: 对应一个 目录 以及 namespace
#   UNITS: 对应一组 *.yml, *.prod.yml
#   UNIT_PORTAL: 观察视角, 查看集群状态
# ####################################
GROUP := $(shell basename $(PWD))
UNITS := k8s-dashboard k8s-admin
UNIT_PORTAL := k8s-dashboard
CTL := kubectl -n $(GROUP)


# ####################################
# 固件配置 AREA
# ####################################
K8S_MK	:= make -C .. -f k8s-yml-ctl.mk 
DK		:= docker


# ####################################
# Dashboard AREA
# ####################################
status: status-all
info:
	$(K8S_MK) GROUP=$(GROUP) UNIT=$(UNIT_PORTAL) $@
start-all:
	$(call doBatExec,start)
stop-all:
	$(call doBatExec,stop)

# 全局初始化、逆初始化、重置
ginit_post: init-master init-cluster-user init-network 
gfini:
greset:


# ####################################
# Status AREA
# ####################################
status-all:
	kubectl get nodes --all-namespaces
	kubectl get pods --all-namespaces
	kubectl get svc --all-namespaces
	kubectl get deployments --all-namespaces


# ####################################
# Info/Query AREA
# ####################################
token:
	$(CTL) describe secret "$(shell $(CTL) get secret | grep -o '^dashboard-admin-token-[a-z|0-9|-]*')"


# ####################################
# Install AREA
# ####################################
install-master:
	./yh-k8s.sh install
	./yh-k8s.sh config master

install-node:
	./yh-k8s.sh install
	./yh-k8s.sh config node


# ####################################
# Init AREA
# ####################################
init-master:
	# 初始化
	kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU

init-cluster-user:
	mkdir -p ${HOME}/.kube
	sudo cp -i /etc/kubernetes/admin.conf ${HOME}/.kube/config
	sudo chown $(shell id -u):$(shell id -g) ${HOME}/.kube/config

init-network:
	kubectl apply -f yml/kube-flannel.yml


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
