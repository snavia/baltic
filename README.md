# baltic
Baltic 容器脚本整合、开源代码编译整合 管理器
为分布式高可用系统助力

---
## 目录介绍
```bash
├── 3rd # 第三方源代码，统一管理
│   ├── gitee.lst   # 码云加速下载repo列表
│   ├── github.lst  # ...
│   └── Makefile    # 批量下载、更新
├── apk # apps for k8s(对应生产环境)
│   ├── k8s-yml-ctl.mk
│   ├── kube-system # k8s 本身 安装、中控 脚本
│   ├── Makefile
│   └── open-falcon # open-falcon k8s 部署脚本
├── apx # apps for x(any，学习、开发、测试，基于docker/docker-compose)
│   ├── 00  # 基础环境，Quick Started
│   ├── 22-cluster  # 集群环境
│   ├── 44-test     # 试一试，学习、测试、调研
│   ├── 66-ref      # 第三方优秀脚本范例
│   ├── 99-raw      # 第三方代码实战时，若冲突，此处存根
│   ├── env-dev.mk  # 开发环境make配置(文件位置可能会变)
│   ├── falcon-dashboard    # [TMP] open-falcon 修改官文例子，作为Demo
│   ├── falcon-mysql        # [TMP] 随业务复杂，目录可能会合并，重组
│   ├── falcon-plus         # [TMP] ... docker快速入门参考
│   ├── falcon-redis        # [TMP] ... docker快速入门参考
│   └── Makefile
├── bin
│   ├── make                # linux下make可执行文件，方便祼机操作
│   └── Makefile            # reserved
├── hack                    # 目录结构和3rd一致，存放编译脚本 + 待修改覆盖文件
│   ├── ...
│   ├── mirrors             # gitee中极速下载 目录 
│   ├── ...                 # 
│   └── Makefile            # 源码编译入口
│
├── Makefile
│
├── scripts                 # 存放部署脚本，dockerfile, ansible分发中心等
│   └── docker-ctl.mk       # docker 实用工具集
│
└── src                     # 自研代码入口
    └── Makefile
```

#### Docker使用几种聚合方式
- Quick Started 最小依赖，单目录绿色结构
> - 请参考 **apx/falcon-x**, 零依赖，可以copy到任何目录下
> - **make {status|start|stop|log|mon|port|bash}**　执行
> - **make ginit** 启动容器前执行，预创建目录，导入数据库等
> - **make ginit_post**(可能没有)，容器启动好后，用于初始化
> - **make bash** `docker exec -it 容器名 bash`封装，便于快速测试

- 数据目录共享，基于docker-compose灵活编排
> - 请参考 **apx/00/** 目录结构
> - 以**apx/00/*.yml**为中心，灵活组合当前同级目录
> - 用法 **make -C apx/00 APP={zk|nginx|redis|...} {ginit|start|stop|status|log|bash}**
> - 功能同上...
> - 其中APP=zk,则对应**zk.yml** 或 **zk.prod.yml**
> - **.env** 文件，用于给docker-compose的yaml文件传递参数
> - 本目录，适合全局统一管理基础组件，**.env**可以存放公共的密码啥的
> - **.env** 参考：https://docs.docker.com/compose/environment-variables/

- 大型项目、集群结构、stack全家桶、不同部署策略的
> - 请参考 **apx/22-cluster** 以集群为核心
> - 用法: 上面两种情况的*双剑合壁，这里就不啰嗦啦*


#### 特殊文件
- `deps.gitignore` Docker使用中，用到的本地log等"运行时"临时文件目录列表
- `.gitignore` Docker中挂载的本地目录列表(持久化数据)，

**注**
> - 如果待挂载的本地目录不存在，Docker会自动生成，但那样目录owner为**root**；
> - 若程序使用**普遍用户**(比如elastisc stack)执行、同时便于本地查看，建议先执行**`make ginit`**自动创建
> - **make ginit** 会读取 **.gitignore**和**deps.gitignore** 自动生成依赖的本地目录(当前用户权限)

---
## 约定

#### 生产环境命名
```bash
prod.mk     # Makefile 配置读取
*prod.env   # docker-compose 生产环境变量
*.prod.yml  # docker-compose 生产环境
```

#### Linux中心化控制
- `chmod +x x.sh` 让脚本自身可执行
- 除非**删除目录文件**等极其危险操作，尽量不要在当前目录下执行
- **中心化控制**: **/tmp**或**项目根目录** 下执行 


#### 统一接口
```bash
# 同systemctl等，顾名思义
make start
make stop
make status
# 中心化控制, 启动容器
make -C apx/22-cluster/elastic start
make -C apx/00 APP=mongo start
```

**注**
> - 为简化书写，突出重点，文中调用make时，部分会忽略 **-C,-f** 参数，
> - 但请务必，养成中心化操作的习惯，让脚本更加鲁棒，拒绝 **./x.sh** 执行方式，具体使用时 **make -C xx [-f xx]** 执行
> - 此外，实质**make -C dir**本身切换了工作目录，吞吃 **cd dir && ./x.sh** 情况
> - 这样可以达到 **ssh 主机名 make -C dir {start|stop|status}** 执行方式，方便与**ansible, crontab**等整合，在最上层一键操作、计划任务等，把Linux主机当作**黑盒**使用，减少不必要的登陆、交互


---
## 功欲善其事

### Docker 镜像加速
- https://www.daocloud.io/mirror#accelerator-doc


---
## Get-Started快速开始

#### docker、docker-compose、k8s开箱体验
- 真机安装k8s体验;
```bash
# 1. 准备 先在ssl目录中，放置https证书文件
# 2. 安装并配置master
make -C apk/kube-system/ install-master ginit_post
# 3. 安装node
make -C apk/kube-system/ init-node
# 3.1 join集群及每一步详情
# 请参见 apk/kube-system/README.md
```
- docker/k8s in docker
```bash
# 启动CentOS7集群, 会虚拟出3台机器(test-m1, test-n1, test-n2)
make -C apx/44-test APP=os-c7-cluster ginit start
# 选取test-m1，进入测试环境
docker exec -it test-m1 bash
# 当前项目挂载到了/project目录下，因镜像是最小环境，此时我们使用自己的make来构建
/project/bin/make -C /project/apk/kube-system/ install-master ginit_post
# 登陆test-n1, test-n2,...
# 这块还没有深挖，大家一起探索哈^_^
```

- 其它
```bash
# 项目根目录下执行为例

# 基于k8s, 启动open-falcon
make -C apk/open-falcon start-all

# 基于docker-compose, docker 请参考目录介绍章节，这里不再啰嗦哈...
# 请注意不同的"内聚"方式哈
make -C apx/22-cluster/elastic start
make -C apx/00 APP=nginx start
make -C apx/falcon-mysql start

```

#### 源码爱好者
```bash

# 项目根目录下执行为例

# 状态管理
make status

# 下载依赖包
make deps

# 同步更新依赖代码
make update

# 编译依赖包
make build
```

---
## 后续规划
**生产环境配置，基于ansible模板生成**


---
## 已知问题
- 目前k8s是半环境，dashboard没有完全配置好，缺少数据支撑，后续完善哈，**kubectl create/delete** 这些命令行执行都是没有问题的，集群状态是OK的
  


---
### FAQ
- 参考文档哪里寻？哪里放？
> 以绿色部署为主，高内聚模式，相关的参考文档，请参考对应的**Makefile** 或 **.yml** 的 **注释** 部分