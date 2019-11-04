#!/bin/bash
# @file: yh-k8s.sh
# @date: 2019-10-28 16:50:44
# @tver: 2019-03-19
# 
# kubernetes
#
# @install: 
#   [Redhat] sudo yum install -y k8s
#   [Mac] brew install k8s
#
# @depends: k8s
# @memo: 
#

# ###############################
# User Var defined(META)
# ###############################
AUTHOR=wx@yvhai.com
VERSION="1.0.0"
YEAR_BEGIN=2013
DEBUG=$DEBUG; # red, green, blue, yellow

# ###############################
# System Error Code
# ###############################
ENOENT=2    # No such file or directory
E2BIG=7     # Argument list too long
EACCES=13   # Permission denied
EEXIST=17   # File exists
EINVAL=22   # Invalid argument

# ###############################
# User Var derived
# ###############################
THIS_NAME=$(basename "$0")
PROJ_ROOT_HOME=$(pushd `dirname "$0"` >/dev/null; pwd; popd >/dev/null);
YEAR=$(date +%Y)
COPY_RIGHT="${THIS_NAME} ${VERSION} Copyright (C) ${YEAR_BEGIN}-${YEAR}, ${AUTHOR}"

# #####################################################
# aux utils
# - log/time-prefix: log-prefix
# - Color echo: red green blue yellow
# - OS TEST: get-os-name, get-os-release-name
# - Debug: debug-print, set-trace-on, set-trace-off
# - Hook: hook-enter-[r|g|b|y], hook-leave
# - FS: verify-symlink
# #####################################################
function log-prefix() {
  unset OPTIND
  while getopts "dhs" opt_; do
    case "$opt_" in
      d) now_="[$(date '+%Y-%m-%dT%H:%M:%S')]" ;;
      h) host_="[$(whoami)@$(hostname -s)]" ;;
      s) os_="[${OS_R_NAME}]" ;;
    esac
  done;
  local prefix=""
  [ -n "$now_" ] && prefix="${prefix} ${now_}"
  [ -n "$host_" ] && prefix="${prefix} ${host_}"
  [ -n "$os_" ] && prefix="${prefix} ${os_}"
  echo $prefix | sed "s:^[ ]*::" # 剔除首部空格
}
NORMAL=; RED=; BLUE=; GREEN=; YELLOW=;
[ -z "$AT_MODE" ] && {
  NORMAL=$(tput sgr0)
  RED=$(tput setaf 1 2>/dev/null; tput bold 2>/dev/null)
  BLUE=$(tput setaf 4 2>/dev/null; tput bold 2>/dev/null)
  GREEN=$(tput setaf 2 2>/dev/null; tput bold 2>/dev/null)
  YELLOW=$(tput setaf 3 2>/dev/null; tput bold 2>/dev/null)
}
function red()    { echo -e "${RED}$(log-prefix -dhs) $*$NORMAL"; }
function blue()   { echo -e "${BLUE}$(log-prefix -dhs) $*$NORMAL"; }
function green()  { echo -e "${GREEN}$(log-prefix -dhs) $*$NORMAL"; }
function yellow() { echo -e "${YELLOW}$(log-prefix -dhs) $*$NORMAL"; }
function get-os-name() { uname -s; }
function get-os-release-name() {
  RETVAL=0
  local os_name=$(get-os-name)
  case "$os_name" in
    "Darwin") echo "MacOS" ;;
    "Linux") echo $(cat /etc/*release 2>/dev/null | grep "^NAME=" | awk -F'=' '{print $2}' | awk '{print $1}' | sed s:\"::g) ;;
    "FreeBSD") echo "FreeBSD" ;;
    *) echo "Unkonwn" && RETVAL=-1 ;;
  esac
  return $RETVAL
}
function debug-print() {
  case "$DEBUG" in
    red|green|blue|yellow) $DEBUG "[DBG] $@" ;;
    *) [ -n "$DEBUG" ] && echo "$(log-prefix -dhs) [DBG] $@" ;;
  esac
}
function hook-enter-r() { red "[$1.enter]" "[ARG=${@:2}]"; }
function hook-enter-g() { green "[$1.enter]" "[ARG=${@:2}]"; }
function hook-enter-b() { blue "[$1.enter]" "[ARG=${@:2}]"; }
function hook-enter-y() { yellow "[$1.enter]" "[ARG=${@:2}]"; }
function hook-leave() {
  RET=$?;
  [ $RET -eq 0 ] && green "[$1.leave]" "[SUCC]" || red "[$1.leave]" "[FAILED=$?]";
}
function set-trace-on() { [ -n "$DEBUG" ] && set -x; }
function set-trace-off() { [ -n "$DEBUG" ] && set +x; }
# verify and re-symbol dir/file link
function verify-symlink() {
  src_file=$1
  dst_link=$2

  verify-then-rm "$dst_link"

  # re-link check exist again incase move failed above
  [ ! -e "$dst_link" ] && ln -s "$src_file" "$dst_link"
}
# verify then: unlink or rename dir/file with date extention
function verify-then-rm() {
  dst_link=$1
  # if dir-link exists unlink
  [ -h "$dst_link" ] && unlink "$dst_link"

  # if dir-real exists rename with date
  if [ -d "$dst_link" -o -f "$dst_link" ]; then
    NOW=$(date +%Y-%m-%d-%H-%M-%S)
    mv "$dst_link" "$dst_link.$NOW"
  fi
}


# #####################################################
# Init(Optional) And Demo Area
# - sys-int: auto detect sys-info for LOG <Required>
# - init: current bash spec [Optional]
# - demo: bar, foobar
# #####################################################
function sys-init() {
  # 系统信息
  OS_NAME=$(get-os-name)
  OS_R_NAME=$(get-os-release-name)
  [ -f ~/.bashrc ] && MY_BASH_ENV_FILE=~/.bashrc || MY_BASH_ENV_FILE=~/.bash_profile
  export MY_BASH_ENV_FILE
  export MY_ENV_DIR_NAME="bin/env.d"
  export MY_ENV_DIR_PATH="$HOME/$MY_ENV_DIR_NAME"
  [ ! -d "$MY_ENV_DIR_PATH" ] && mkdir -p "$MY_ENV_DIR_PATH"
  debug-print "[OS=${OS_NAME}-${OS_R_NAME}] [ENV=${MY_BASH_ENV_FILE}]"
}

function init() {
  # 根据需要，可以切换工作路径
  pushd "$PROJ_ROOT_HOME" >/dev/null
  debug-print "Script dir is: $(pwd 2>/dev/null)"
  # 读取环境变量(独立写法, 直接 MY_ENV_DIR_NAME 亦可)
  [ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc" || {
    [ -r "$HOME/.bash_profile" ] && . "$HOME/.bash_profile"
  }
  [ -n "$DEBUG" ] && env > /tmp/env-now.txt
  spec-init
  popd >/dev/null
}

function bar() {
  blue "$@"
}

function foobar() {
  yellow "$@"
}

# #####################################################
# User Code Area
# #####################################################
function spec-init() {
  green "$@"
}

# ###############################
# Dashboard Area
# ###############################
function install() {
  init_centos_com
  init_centos_k8s
  install_docker
  install_k8s
  install_docker_k8s_deps
  green "$@" "done"
}

function config() {
  type=${1:-'master'}
  # install_deps
  case "$type" in
    master)
      do_config_master
      ;;
    slave|node)
      do_config_node
      ;;
    *)
      red "Invalid $type" && RETVAL=$EINVAL && return $RETVAL
      ;;
  esac
  echo done
}


# ###############################
# Install Area
# ###############################
function init_centos_com() {
  # 重置源
  # rm -rf /var/cache/yum && yum clean all && yum makecache \
  #  && ls -lhrt /etc/yum.repos.d/ \
  #  && rm -rvf /etc/yum.repos.d/* \
  #  && curl http://mirrors.163.com/.help/CentOS7-Base-163.repo -o /etc/yum.repos.d/CentOS7-Base-163.repo \
  #  && yum -y update
  # curl http://mirrors.163.com/.help/CentOS7-Base-163.repo -o /etc/yum.repos.d/CentOS7-Base-163.repo
  # yum -y update

  # deps
  yum install -y sudo firewalld

  # 关闭selinux
  [ -r /etc/selinux/config ] && grep "^SELINUX=enforcing" >/dev/null /etc/selinux/config && sed -i '/^SELINUX=/c\\SELINUX=permissive' /etc/selinux/config
  getenforce | grep Enforcing >/dev/null && setenforce 0

  # 更改时区为China，并开启时间同步
  yum install -y ntp; systemctl enable ntpd; systemctl start ntpd;
  timedatectl set-timezone Asia/Shanghai
  systemctl restart systemd-timedated

  # build group
  yum -y groupinstall 'Development Tools'
  # tools
  yum install -y tree vim sysstat
  # net suits
  yum install -y net-snmp-utils net-tools bind-utils iputils telnet lsof
  # selinux semmanage
  yum install -y policycoreutils-python
}

function init_centos_k8s() {
  # selinux off
  setenforce 0

  # 关闭交换内存
  swapoff -a
}

function install_docker() {
  # docker 数据目录
  [ ! -d /home/docker ] && mkdir -p /home/docker
  [ ! -d /var/lib/docker ] && ln -s /home/docker /var/lib/docker
  # docker 安装包
  yum remove docker  docker-common docker-selinux docker-engine
  yum install -y yum-utils device-mapper-persistent-data lvm2
  yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  yum install -y docker-ce
  # which docker || curl -sSL https://get.daocloud.io/docker | sh
  # docker 启动
  systemctl start docker
  # docker group
  GDOCKER=$(cat /etc/group | grep -io "docker[a-z]*")
  echo "GROUP DOCKER: $GDOCKER"
  # cat /etc/group | grep "$GDOCKER" | grep "$R_SUDO_USER" || gpasswd -a "$R_SUDO_USER" $GDOCKER
  # install docker-compose
  curl -L https://get.daocloud.io/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
}

function install_k8s() {
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 设置阿里云/Daocloud镜像加速, 也可以不用弄这个
# https://{阿里云分配的地址}.mirror.aliyuncs.com
cat <<EOF >/etc/docker/daemon.json
{
    "registry-mirrors": ["http://f1361db2.m.daocloud.io"]
}
EOF

  # 安装核心部件
  yum install -y kubelet kubeadm kubectl
  systemctl enable kubelet && systemctl start kubelet

  # minikube
  curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.5.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
}

function do_pull_img() {
  imageName=${1#k8s.gcr.io/}
  docker pull registry.aliyuncs.com/google_containers/$imageName
  docker tag registry.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
  docker rmi registry.aliyuncs.com/google_containers/$imageName
}

function install_docker_k8s_deps() {
  # 将对应的包, 从国内镜像上拉下来
  do_pull_img "k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1"
  for i in $(kubeadm config images list 2>/dev/null); do
    do_pull_img "$i"
  done;
}

# ###############################
# Config Area
# ###############################
function do_add_port() {
  for x in "$@"; do
    echo "$x" | grep -q "udp" && port="$x" || port="$x/tcp";
    which firewall-cmd 2>/dev/null && {
      firewall-cmd --zone=public --list-port | grep "$port" >/dev/null \
        || firewall-cmd --zone=public --permanent --add-port "$port"
      green "$port added"
    }
  done;
  firewall-cmd --reload
}

function do_config_master() {
  # 开放端口
  # MASTER节点
  # 6443* Kubernetes API server
  # 2379-2380 etcd server client API
  # 10250 Kubelet API
  # 10251 kube-scheduler
  # 10252 kube-controller-manager
  # 10255 Read-only Kubelet API (Heapster)
  do_add_port 6443 2379 2380 10250 10251 10252 10255 10256 8472/udp 8443 30001

  # 网桥
  sysctl net.bridge.bridge-nf-call-iptables=1
}

function do_config_node() {
  # 开放端口
  # Worker节点
  # 10250 Kubelet API
  # 10255 Read-only Kubelet API (Heapster)
  # 30000-32767 Default port range for NodePort Services. Typically, these ports would need to be exposed to external load-balancers, or other external consumers of the application itself.
  do_add_port 10250 10255 30000 32767 8472/udp 8443 30001
}



# ###############################
# Usage Area
# ###############################
function showUsage() {
cat << EOF
${COPY_RIGHT}
sysinfo: ${OS_NAME}|${OS_R_NAME}|$(whoami)@$(hostname -s)
Usage: ${THIS_NAME} <cmd> [OPTION]

Options:

  -v, --version                             output the version number
  -h, --help                                output usage information

Commands:

  install           install kubernets/k8s to current host.
  config            config kubernets/k8s to current host.


EOF
}

# ###############################
# Main Route
# ###############################
RETVAL=0
function main() {
  sys-init
  if [ $# -eq 0 ]; then
    showUsage
    return 1
  fi

  init
  sub="$1"
  shift
  case "$sub" in
    install) install "$@" ;;
    config) config "$@" ;;
    *) showUsage ;;
  esac

  return $RETVAL
}

# ###############################
# Run
# ###############################
main "$@"
