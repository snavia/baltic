# 分组管理
# Version: 20191101


FALCON := falcon-mysql falcon-redis falcon-plus falcon-dashboard

# ####################################
# Dashboard AREA
# ####################################
start: start-falcon
stop: stop-falcon
status: status-falcon
log: log-falcon
port: port-falcon


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
