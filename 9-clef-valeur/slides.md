title: Consul
author: xavki


# Consul : clef valeur KV

C'est de la magie et pourtant c'est si simple !!!

<br>


* Consul met à disposition sa base pour stocker en clef/valeur

<br>


* faire beaucoup de choses (mise à jour conf, variables, larges diffusions)

<br>


* très dynamique moins de la seconde

<br>


* utilisable par consul-template

<br>


* consul-template : template (ex : conf) + commande (ex : reload)

<br>


* même principe pour vault (hashicorp) pour les secrets

<br>


* mise à jour / consultation par API ou CLI

<br>


ATTENTION : la moindre erreur se paie cash (confs notamment = checks avant)

<br>


* exemple Nginx:
		* changement dynamique de index.html
		* changement de conf (ports) et reload

-----------------------------------------------------------------------


# Key/Value : installation de consul-template


* download et installation du binaire

```
wget https://releases.hashicorp.com/consul-template/0.22.0/consul-template_0.22.0_linux_amd64.zip
unzip consul-template_0.22.0_linux_amd64.zip
mv consul-template /usr/local/bin
chmod 755 /usr/local/bin/consul-template
```

* création user et groupe

```
groupadd --system consul
useradd -s /sbin/nologin --system -g consul consul
chown consul:consul /usr/local/bin/consul-template
```

* répertoire pour les configurations et templates

```
mkdir /etc/consul-template
chown consul:consul /etc/consul-template
chmod 775 /etc/consul-template
```

------------------------------------------------------------

# Key/Value : installation de consul-template


* création du service systemd

```
cat /etc/systemd/system/consul-template.service
[Unit]
Description=Consul Template adon to consul
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
Group=consul
ExecStart=/usr/local/bin/consul-template \
    -config /etc/consul-template/config.hcl
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
Restart=on-failure
SyslogIdentifier=consul

[Install]
WantedBy=multi-user.target
```

-----------------------------------------------------------


# Key/Value : configuration de consul-template

* fichier adapté pour la gestion multi-configurations

```
consul {
    address = "<serveur_consul>:8500"
    retry {
        enabled = true
        attempts = 12
        backoff = "250ms"
    }
}
template {
    source      = "/etc/consul-template/homepage.ctmpl"
    destination = "/var/www/html/index.html"
}
template {
    source      = "/etc/consul-template/default.ctmpl"
    destination = "/etc/nginx/sites-available/default"
    command     = "service nginx reload"
}
```

----------------------------------------------------------

# Key/Value : Installation Nginx et templates


* installation nginx

```
apt-get install nginx
```

* template /etc/consul-template/homepage.ctmpl

```
cat /etc/consul-template/homepage.ctmpl
{{ key "nginx/var/www/html/index.html@mydc" }}
```

* template /etc/consul-template/default.ctmpl

```
cat /etc/consul-template/default.ctmpl
{{ key "nginx/etc/nginx/sites-available/default@mydc" }}
```

--------------------------------------------------------

# Key/Value : c'est partie

```
service nginx start
systemctl enable consul-template
service consul-template start
```
