
CODIS_DIR := codis

start-admin:
	$(CODIS_DIR)/admin/codis-dashboard-admin.sh start
	tail -100 $(CODIS_DIR)/log/codis-dashboard.log*

start-proxy:
	$(CODIS_DIR)/admin/codis-proxy-admin.sh start
	tail -100 $(CODIS_DIR)/log/codis-proxy.log*

start-server:
	$(CODIS_DIR)/admin/codis-server-admin.sh start
	sleep 2
	tail -100 /tmp/redis_6379.log

start-fe:
	$(CODIS_DIR)/admin/codis-fe-admin.sh start
	sleep 2
	tail -100 $(CODIS_DIR)/log/codis-fe.log*

stop-all:
	$(CODIS_DIR)/admin/codis-fe-admin.sh stop
	$(CODIS_DIR)/admin/codis-dashboard-admin.sh stop
	$(CODIS_DIR)/admin/codis-proxy-admin.sh stop
	$(CODIS_DIR)/admin/codis-server-admin.sh stop
