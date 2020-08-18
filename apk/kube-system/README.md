# K8s 管理

## K8s安装


### 安装准备

- 请将您的证书文件，放在`ssl`目录下

  - **ssl/dashboard.crt** (公钥)
  - **ssl/dashboard.key** (私钥)

### 快速安装
```bash
# 1. 准备 先在ssl目录中，放置https证书文件
# 2. 安装并配置master
make install-master ginit_post
# 3. 安装node
make install-node
```

----
### 安装master(单步,请优先使用快速安装)
```bash
# step1. 
#   安装所有组件(Docker, kubectl, kubeadm, kubelet)
#   配置为master
./yh-k8s.sh install
./yh-k8s.sh config master

# step2. 初始化 master
make ginit

# x. 查询
# 获得dashboard-admin-token
make token

```

### 安装node(单步,请优先使用快速安装)
```bash
# step1. 
#   安装所有组件(Docker, kubectl, kubeadm, kubelet)
#   配置为node
./yh-k8s.sh install
./yh-k8s.sh config node

# step2. 配置为node
# 根据提示操作，执行
kubeadm join xxx.xxx.xxx.xxx:6443 --token xxx \
  --discovery-token-ca-cert-hash sha256:****************

```


---
## 配置Dashboard

```bash
# 允许外部访问
kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$'
```


### 已知问题
1. masters, nodes 防火墙仍需要全部停止
2. dashboard 还没配好哈，貌似依赖 heapster, prometheus，待续
