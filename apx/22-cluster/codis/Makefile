# ZooKeeper 集群环境


# ####################################
# Config AREA
# ####################################
SVC_HOST := $(shell hostname -a)


# ####################################
# Dashboard AREA
# ####################################
start: ginit start-g1 start-proxy start-web
stop: stop-web stop-proxy stop-g1


test: test-core

ginit: init-dir


# ####################################
# Init AREA
# 	init-dir: 
# ####################################
init-dir:
	for x in $(shell sed -n "/# DATA-DIR-BEGIN/,/# DATA-DIR-END/p" .gitignore | grep -v "#"); do \
		echo "verify dir $$x"; \
		[ -d "$$x" ] || mkdir -p "$$x"; \
	done;


# ####################################
# Web AREA
# ####################################
start-web:
	docker-compose -f codis-web.yml up -d
stop-web:
	docker-compose -f codis-web.yml down


# ####################################
# Proxys AREA
# ####################################
start-proxy:
	docker-compose -f codis-proxy.yml up -d
stop-proxy:
	docker-compose -f codis-proxy.yml down


# ####################################
#　Server Group AREA
# ####################################
start-g1:
	docker-compose -f codis-g1.yml up -d
stop-g1:
	docker-compose -f codis-g1.yml down


# ####################################
# Test AREA
# ####################################
test-core:

bash:
	docker exec -it codis-g1-s1 bash


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
