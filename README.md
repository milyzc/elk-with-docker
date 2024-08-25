# Configuración de ELK
> Chequear versiones con las actuales antes de hacer un deploy.

Las imágenes subidas la registry son sacadas de la página oficial de ELK:
https://www.docker.elastic.co/
- Elasticsearch: https://www.docker.elastic.co/r/elasticsearch
- Kibana: https://www.docker.elastic.co/r/kibana

## Requistos
- Tener acceso por ssh al nodo de soporte.
- El nodo de soporte debe tener instalado docker y [docker-compose](https://itslinuxfoss.com/install-use-docker-compose-debian/).
> Recordar que para descargar cosas en los nodos de gobierno es necesario  usar el proxy. Ej para descargar el docker-compose: 
> Para instalar docker-compose. Elegir version en https://github.com/docker/compose/releases

```
sudo curl --proxy "http://<PROXY_SI_HACE_FALTA>" -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
```

```
sudo chmod +x /usr/local/bin/docker-compose
```

## DEPLOY
> Los pasos 1 y 2 son si se deploya en un servidor. Sino es local arrancar en el paso 3.

1. Esta imágenes tienen que ser pulleadas y subidas al registry correspondiente previo a levantar el docker-compose.yml. Ver secciones #Elasticsearch, #kibana, #nginx.
	2. Comprimir la carpeta elk y copiarla al nodo donde se va a deployar el ELK. Ejecutar desde una powershell o una terminal linux.
	```
	scp [ruta-absoluta]/[repo]/elk.zip <user>@<hosts>:/home/<user>/
	```
	```
	unzip /home/<user>/elk.zip
	```
3. Verificar en el .env los valores de las variables en el nodo donde se va levantar el docker-compose.yml. En este caso en la ruta `/home/<user>/elk/.env` en el nodo destino
		- IMAGE_ELASTICSEARCH
		- IMAGE_KIBANA
		- KIBANA_PASSWORD
		- ELASTIC_PASSWORD
		
4. Crear la docker network donde se va levantar el docker-compose.yml
	```
	docker network create elk
	```
	```
	docker network list
	```
5. Levantar el docker-compose.yml
	```
	docker-compose up -d .
	``` 

#### Elasticsearch
```
docker login https://[registry]
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.7.0
docker tag docker.elastic.co/elasticsearch/elasticsearch:8.7.0 [registry]/elk/elasticsearch:8.7.0
docker push [registry]/elk/elasticsearch:8.7.0
docker logout https://[registry]
```

#### Kibana
```
docker login https://[registry]
docker pull docker.elastic.co/kibana/kibana:8.7.0
docker tag docker.elastic.co/kibana/kibana:8.7.0 [registry]/elk/kibana:8.7.0
docker push [registry]/elk/kibana:8.7.0
docker logout https://[registry]
```

#### Nginx
```
docker login https://[registry]
docker pull nginx:1.24.0-alpine
docker tag nginx:1.24.0-alpine [registry]/nginx:1.24.0-alpine
docker push [registry]/nginx:1.24.0-alpine
docker logout https://[registry]
```

> Si el tiene un dominio definido ej. [registry]=https://<URL>, cuya IP es <IP>
> Verificar que la entrada `<IP>	<URL>` este en el archivo hosts de la máquina que va a hacer los push al registry.
