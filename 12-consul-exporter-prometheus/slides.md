%title: Consul
%author: xavki


# Consul Exporter : Métriques de services


<br>


* consul exporter : affichage des métriques de consul
	* nombre/noms des services
	* nombre/noms des instances
	* statuts: passing, critical..

* lien: https://github.com/prometheus/consul_exporter

<br>


* lancement via docker 

```
docker run -d -p 9107:9107 prom/consul-exporter --consul.server=192.168.1.31:8500
```

<br>


* ajout dans prometheus

```
scrape_configs:
  - job_name: consul_exporter
    static_configs:
      - targets: ['localhost:9107']
```

-------------------------------------------------------------------------

# Exemple d'utilisation via Grafana


<br>


* bar gauge

* utilisation de la ressources : consul_health_service_status

* somme d'instances par service 

```
sum(consul_health_service_status{status="passing"}) by (service_name)
```

* coché "instant"

* legend "{{ service_name }}"

* adaptation de la légende : couleur, seuil et titre
