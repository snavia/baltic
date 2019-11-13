# ZooKeeper 集群环境


# ####################################
# Config AREA
# ####################################
SVC_HOST := $(shell hostname -a)


# ####################################
# Dashboard AREA
# ####################################
start: ginit start-g1
stop: stop-g1


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
#　group1 AREA
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
