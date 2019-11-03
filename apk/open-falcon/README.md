## 使用说明

## 中心化管理
```bash
# 状态 (info 包含 status)
make -C apk/open-falcon/ status
make -C apk/open-falcon/ info

# 启/停
make -C apk/open-falcon/ start-all
make -C apk/open-falcon/ stop-all 

# 备注，只输出净信息, 请添加 2>&1 | sed '/====/,/====/d' | grep -v -E '^make'
# e.g. 启动
make -C apk/open-falcon/ start-all 2>&1 | sed '/====/,/====/d' | grep -v -E '^make'

```

---

## 正常情况，不必往下看了，以下仅供运行预期对比
> 注: 已 去除 白噪音

---
## 运行效果

#### 状态(空)
```bash
kubectl -n open-falcon get svc && echo
No resources found in open-falcon namespace.
kubectl -n open-falcon get pods && echo
No resources found in open-falcon namespace.
```

#### 状态(运行状态)
```bash
# make -C apk/open-falcon/ info
Client Version: version.Info{Major:"1", Minor:"16", GitVersion:"v1.16.2", GitCommit:"c97fe5036ef3df2967d086711e6c0c405941e14b", GitTreeState:"clean", BuildDate:"2019-10-15T19:18:23Z", GoVersion:"go1.12.10", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"16", GitVersion:"v1.16.2", GitCommit:"c97fe5036ef3df2967d086711e6c0c405941e14b", GitTreeState:"clean", BuildDate:"2019-10-15T19:09:08Z", GoVersion:"go1.12.10", Compiler:"gc", Platform:"linux/amd64"}

cat ./open-falcon/yml/*.yml | grep "image:"
        image: mysql:5.7
        image: openfalcon/falcon-dashboard:v0.2.1
        image: openfalcon/falcon-plus:v0.3
      - image: redis:alpine


kubectl -n open-falcon get svc && echo
NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
mysql                   NodePort    10.110.34.131   <none>        3306:32394/TCP                  105s
open-falcon             NodePort    10.105.88.103   <none>        8433:30196/TCP,8080:30011/TCP   104s
open-falcon-dashboard   NodePort    10.96.252.48    <none>        8081:31038/TCP                  104s
redis                   ClusterIP   10.109.120.52   <none>        6379/TCP                        105s

kubectl -n open-falcon get pods && echo
NAME                                     READY   STATUS    RESTARTS   AGE
mysql-5f77fb777c-mghw7                   1/1     Running   0          105s
open-falcon-849785f5f-ghbf9              1/1     Running   0          104s
open-falcon-dashboard-5ddcdc76f9-nrg9f   1/1     Running   0          104s
redis-78574f5748-gmldz                   1/1     Running   0          105s
```

#### 启动
```bash
for x in mysql redis open-falcon-plus open-falcon-dashboard; do make -C .. -f k8s-yml-ctl.mk  GROUP=open-falcon UNIT=${x} start; done;

kubectl -n open-falcon apply -f ./open-falcon/yml/mysql.yml
service/mysql created
deployment.apps/mysql created

kubectl -n open-falcon apply -f ./open-falcon/yml/redis.yml
service/redis created
deployment.apps/redis created

kubectl -n open-falcon apply -f ./open-falcon/yml/open-falcon-plus.yml
configmap/openfalcon-configmap created
service/open-falcon created
deployment.apps/open-falcon created

kubectl -n open-falcon apply -f ./open-falcon/yml/open-falcon-dashboard.yml
service/open-falcon-dashboard created
deployment.apps/open-falcon-dashboard created
```

#### 停止
```bash
for x in mysql redis open-falcon-plus open-falcon-dashboard; do make -C .. -f k8s-yml-ctl.mk  GROUP=open-falcon UNIT=${x} stop; done;

kubectl -n open-falcon delete -f ./open-falcon/yml/mysql.yml
service "mysql" deleted
deployment.apps "mysql" deleted

kubectl -n open-falcon delete -f ./open-falcon/yml/redis.yml
service "redis" deleted
deployment.apps "redis" deleted

kubectl -n open-falcon delete -f ./open-falcon/yml/open-falcon-plus.yml
configmap "openfalcon-configmap" deleted
service "open-falcon" deleted
deployment.apps "open-falcon" deleted

kubectl -n open-falcon delete -f ./open-falcon/yml/open-falcon-dashboard.yml
service "open-falcon-dashboard" deleted
deployment.apps "open-falcon-dashboard" deleted
```
