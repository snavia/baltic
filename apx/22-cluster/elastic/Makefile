
# ####################################
# Config AREA
# ####################################
SVC_HOST := 127.0.0.1

ES_URL_BASE := http://$(SVC_HOST):9200


# ####################################
# Dashboard AREA
# ####################################
start: start-mini start-beats start-other
stop: stop-other stop-beats stop-mini


test: test-core

ginit: init-dir


# ####################################
# Init AREA
# 	init-dir: ES使用普通用户启动，uid=1000
# ####################################
init-dir:
	[ -d "data/es01" ] || mkdir -p "data/es01"
	[ -d "data/es02" ] || mkdir -p "data/es02"
	[ -d "data/es03" ] || mkdir -p "data/es03"
	sudo chown -Rv 1000:1000 data


# ####################################
# Mini AREA
# ####################################
start-mini:
	docker-compose -f elastic-mini.yml up -d
stop-mini:
	docker-compose -f elastic-mini.yml down


# ####################################
# Beats AREA
# ####################################
start-beats:
	docker-compose -f elastic-beats.yml up -d
stop-beats:
	-docker-compose -f elastic-beats.yml down


# ####################################
# Other AREA
# ####################################
start-other:
	docker-compose -f elastic-other.yml up -d
stop-other:
	-docker-compose -f elastic-other.yml down


# ####################################
# Test AREA
# ####################################
test-core:
	curl $(ES_URL_BASE)
	curl $(ES_URL_BASE)/_cat/health
	curl $(ES_URL_BASE)/_nodes?pretty=true


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
