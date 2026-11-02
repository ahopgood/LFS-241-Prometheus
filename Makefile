CLUSTER_NAME=k3d-prometheus
start:
	#ctlptl create cluster k3d --name ${CLUSTER_NAME} --registry=ctlptl-prometheus-registry
	ctlptl apply -f cluster.yaml
	tilt up --port 10351
stop:
	ctlptl delete cluster ${CLUSTER_NAME}
	ctlptl delete registry ctlptl-prometheus-registry

refresh:
	tilt down --delete-namespaces && tilt up