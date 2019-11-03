# K8s 管理

## K8s安装


### 安装准备

- 请将您的证书文件，放在`ssl`目录下

  - **ssl/dashboard.crt** (公钥)
  - **ssl/dashboard.key** (私钥)


### 安装master
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

### 安装node
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

### 已知问题
1. masters, nodes 防火墙仍需要全部停止
2. dashboard 还没配好哈，貌似依赖 heapster, prometheus，待续
