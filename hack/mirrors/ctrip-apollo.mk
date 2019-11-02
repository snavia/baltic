# Apollo 部署脚本
# 	Apollo（阿波罗）是携程框架部门研发的分布式配置中心，能够集中化管理应用不同环境、不同集群的配置，
# 	配置修改后能够实时推送到应用端，并且具备规范的权限、流程治理等特性，适用于微服务配置管理场景。
# https://github.com/ctripcorp/apollo
# https://gitee.com/nobodyiam/apollo


SRC_DIR := ../../3rd/mirrors/ctrip-apollo
DEST_DIR := ../../docker/ctrip-apollo


# ####################################
# Dashboard AREA
# ####################################
install: build

build:
	$(SRC_DIR)/scripts/build.sh


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
