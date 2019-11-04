# ZooKeeper 管理维护补充脚本
# FileVersion: 20191104


# ####################################
# Dashboard AREA
# ####################################
status:
	for x in `seq 3`; do \
		echo zoo$${x}; \
		docker exec -it dev-zoo$${x} zkServer.sh status; \
		echo; \
	done
