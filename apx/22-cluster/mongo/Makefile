# ####################################
# Name: MongoDB 集群环境
# FileVersion: 20191114
# ####################################


DK	:= docker
DC	:= docker-compose


# ####################################
# 环境变量 AREA
# ####################################


# ####################################
# Config AREA
# ####################################
SVC_HOST := $(shell hostname -a)
SERVER_RSS := rs1 rs2 conf shard


# ####################################
# Dashboard AREA
# ####################################
status: status-port
start: ginit start-servers
stop: stop-servers
test: test-core
ginit: init-dir

bash:
	docker exec -it mongo-r1-s1 bash


# ####################################
# Status/Info AREA
# ####################################
status-port:
	sudo netstat -lntop | grep docker | sort -n -k4
	docker ps -a | grep mongo


# ####################################
# Init AREA
# 	init-dir: 
# ####################################
init-dir:
	# 创建数据目录
	for x in $(shell sed -n "/# DATA-DIR-BEGIN/,/# DATA-DIR-END/p" .gitignore | grep -v "#"); do \
		echo "verify dir $$x"; \
		[ -d "$$x" ] || mkdir -p "$$x"; \
	done;
	# 给集群脚本文件加上读、执行权限
	find scripts -name "*" -exec chmod +r {} \;
	find scripts -name "*.sh" -exec chmod +x {} \;
	# log目录可写
	chmod o+w ../../../log/mongo


# ####################################
#　Server Group AREA
# ####################################
start-servers:
	for x in $(SERVER_RSS); do docker-compose -f mongo-$$x.yml up -d; done;
stop-servers:
	for x in $(SERVER_RSS); do docker-compose -f mongo-$$x.yml down; done;


# ####################################
# Debug AREA
# ####################################


# ####################################
# Test AREA
# ####################################
test-core:


# ####################################
# Cluster AREA
# ####################################


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
