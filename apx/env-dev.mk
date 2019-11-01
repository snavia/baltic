# 开发环境 环境变量定义

DATE			:= $(shell date +"%Y-%m-%d %H:%M:%S")
DATE_DOT	:= $(shell date +"%Y.%m.%d.%H.%M.%S")
DATE_DASH	:= $(shell date +"%Y-%m-%d-%H-%M-%S")

ENV_TYPE	:= dev
CONTAINER_PREFIX	:= dev-

# yaml文件扩展名
# e.g. nginx.yml nginx.prod.yml
YAML_EXT	:= .yml 
