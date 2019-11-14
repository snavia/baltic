## MySQL 集群


#### 端口分布
|组名|主|从|备注|
|:--|--|--|--|
|**g1**|**3316**|3317-3318|mysql-g1.yml|
|**g2**|**3326**|3327-3328|mysql-g2.yml|
|**g3**|**3336**|3337-3338||
|**g4**|**3346**|3347-3348||


---
## 参考
- https://github.com/docker-library/mysql/blob/master/5.7/Dockerfile
- https://github.com/docker-library/mysql/blob/master/5.7/docker-entrypoint.sh
- https://github.com/hellxz/mysql-cluster-docker
