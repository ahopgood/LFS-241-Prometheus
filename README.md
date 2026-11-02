# README - LFS-241 - Monitoring Systems and Services with Prometheus
This project is to support the lab work for the course `LFS-241 - Monitoring Systems and Services with Prometheus` from the Linux Foundation

## Lab 4.1 - Configuring Prometheus
* Grab the prometheus image and run as a container
```
docker create --name config docker.io/prom/prometheus:v3.2.1
```
* Create a configuration directory to mount to the container
```
mkdir ~/prometheus && cd ~/prometheus
```
* We copy the config file out of the container
```
docker cp config:/etc/prometheus/prometheus.yml .
```
* Remove the container
```
docker rm config
```
* We can view the command line flags available with:
```
docker run --rm docker.io/prom/prometheus:v3.2.1 -h
```

## Lab 4.2 Starting Prometheus
Create a docker network for prometheus
```
docker network create --driver bridge lab
```
* Run the prometheus container in the network 
```
docker run -d -p 9090:9090 --name prometheus -h prometheus --net lab docker.io/prom/prometheus:v3.2.1
```
* [http://0.0.0.0:9091/status](http://0.0.0.0:9091/status)
* [http://0.0.0.0:9091/metrics](http://0.0.0.0:9091/metrics)
* [http://0.0.0.0:9091/query](http://0.0.0.0:9091/query)
* [http://0.0.0.0:9091/alerts](http://0.0.0.0:9091/alerts)
* [http://0.0.0.0:9091/targets](http://0.0.0.0:9091/targets)