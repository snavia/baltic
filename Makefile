# 整体管理脚本

DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")
GUP_MSG = "Auto Commited at $(DATA_SUF)"

ifdef MSG
	GUP_MSG = "$(MSG)"
endif


# ####################################
# Dashboard AREA
# ####################################
# 状态管理
status: status-docker status-k8s

# 下载依赖包
deps: deps-3rd

# 同步更新依赖代码
update: update-3rd

# 编译依赖包
build: build-3rd


# ####################################
# Status AREA
# ####################################
status-docker:
	docker images
	docker ps -a

status-k8s:
	kubectl get pods --all-namespaces
	kubectl get svc --all-namespaces


# ####################################
# Build AREA
# ####################################
build-3rd: update-3rd
	# make -C hack/AliyunContainerService -f log-pilot.mk install
	# make -C hack/open-falcon -f falcon-plus.mk install
	make -C hack/mirrors -f ctrip-apollo.mk install


# ####################################
# Update AREA
# ####################################
update-3rd: deps-3rd
	make -C 3rd sync


# ####################################
# Deps AREA
# ####################################
deps-3rd:
	make -C 3rd


# ####################################
# git
# ####################################
gpom:
	git add .
	git commit -am $(GUP_MSG)
	git push origin master
	git status
gfom:
	git pull origin master
gs:
	git status
ga:
	git add .


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
