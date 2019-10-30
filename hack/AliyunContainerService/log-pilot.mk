# Log-Poilot 部署脚本


install:
	cd ../../vendor/AliyunContainerService/log-pilot && ./build-image.sh

start:
	docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /etc/localtime:/etc/localtime \
    -v /:/host:ro \
    --cap-add SYS_ADMIN \
    registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.5-filebeat
