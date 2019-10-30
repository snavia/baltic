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
deps: deps-vendor

# 同步更新依赖代码
update: update-vendor

# 编译依赖包
build: build-vendor


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
build-vendor: update-vendor
	make -C hack/AliyunContainerService -f log-pilot.mk install


# ####################################
# Update AREA
# ####################################
update-vendor: deps-vendor
	make -C vendor sync


# ####################################
# Deps AREA
# ####################################
deps-vendor:
	make -C vendor


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
