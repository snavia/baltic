# 分组管理
# Version: 20191101


FALCON := falcon-mysql falcon-redis falcon-plus falcon-dashboard

DK := docker


# ####################################
# Dashboard AREA
# ####################################
start: start-falcon
stop: stop-falcon
status: status-falcon
log: log-falcon
port: port-falcon

ginit: init-data-dir


# ####################################
# Init AREA
# ####################################
init-data-dir:
	# 注: 此处若包装函数，makefile执行，会报错
	for x in $(shell sed -n "/# DATA-DIR-BEGIN/,/# DATA-DIR-END/p" .gitignore | grep -v "#"); do \
		echo "verify dir $$x"; \
		[ -d "$$x" ] || mkdir -p "$$x"; \
	done;


# ####################################
# #x1. Open-Falcon AREA
# ####################################
start-falcon:
	$(call doBatExec,$(FALCON),start)
stop-falcon:
	$(call doBatExec,$(FALCON),stop)
status-falcon:
	$(call doBatExec,$(FALCON),status)
log-falcon:
	$(call doBatExec,$(FALCON),log)
port-falcon:
	$(call doBatExec,$(FALCON),port)


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm

define doStart
	make -C $(1) start
endef

define doStop
	make -C $(1) stop
endef

define doBatExec
	for x in $(1); do \
		make -C $$x $(2); \
	done
endef
