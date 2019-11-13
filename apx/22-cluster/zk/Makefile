# ZooKeeper 集群环境


# ####################################
# Config AREA
# ####################################
SVC_HOST := $(shell hostname -a)


# ####################################
# Dashboard AREA
# ####################################
start: ginit start-sz
stop: stop-sz


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
#　深圳机房 AREA
# ####################################
start-sz:
	docker-compose -f sz-zk.yml up -d
stop-sz:
	docker-compose -f sz-zk.yml down


# ####################################
# Test AREA
# ####################################
test-core:



# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
