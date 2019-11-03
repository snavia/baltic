# K8S 证书相关

CTL	:= kubectl -n kube-system

status:
	$(CTL) get secret | grep dashboard
	$(CTL) describe secret kubernetes-dashboard-certs

install:
	$(CTL) create secret generic kubernetes-dashboard-certs --from-file=dashboard.key --from-file=dashboard.crt 
