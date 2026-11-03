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

## Lab 4.3 Using the Expression Browser
* [http://0.0.0.0:9091/query](http://0.0.0.0:9091/query)
* The `Table` view shows the most recent values of the outputs of an expression
* The `Graph` tab plots values over time
* The `Explain` tab provides insights and explanations for queries

Graphing can initially be expensive so it is useful to start from the table view to prototype an expression, then switch to graph once you've narrowed down the expression. 

Prometheus exposes itself as a scrape target so you can query for it:
* `prometheus_tsdb_head_samples_appended_total` the total number of samples ingested into prometheus's local storage
* `rate(prometheus_tsdb_head_samples_appended_total[1m])` the number of samples ingested per second as _averaged_ over a 1-minute window
* `up{job="prometheus"}` value of the **synthetic** `up` metric for prometheus which is set to 0 when a scrape fails and 1 when successful.
