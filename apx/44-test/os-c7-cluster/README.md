## 用途
- 体验k8s安装


## k8s安装
```bash
# 启动
make APP=os-c7-cluster start

# 连接到master节点
docker exec -it test-m1 bash

# 执行下面命令开始安装
/project/bin/make -C /project/apk/kube-system/ install-master
```
