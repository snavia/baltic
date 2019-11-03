#!/bin/bash

mysql_pod=$(kubectl get pods -n baltic | grep mysql | awk '{print $1}')
for x in `ls ./stub/*.sql`; do
	echo init mysql table $x ...;
	kubectl -n baltic exec -it $mysql_pod -- mysql -uroot -p123456 < $x;
done
