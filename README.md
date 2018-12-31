# Docker-Swarm-AWS-ASG-ELB


## Implementación de Docker Swarm en Amazon Web Services usando Auto Scaling Groups y Elastic Load Balancing
<br />


<p align="center">
<img src="https://raw.githubusercontent.com/adrianlois/Docker-Swarm-AWS-ASG-ELB/master/screenshots/1-portada-implementacion-dockerswarm-aws-asg-elb.png" />
</p>

## Objetivos

Se trata de un proyecto orientado a la alta disponibilidad y evitando los overhead con un óptimo aprovechamiento de los recursos usando contenedores Docker, auto escalado y balanceador de carga usando los servicios de **Amazon Web Services**. Se trata de crear un servicio para servir una página web *(Wordpress, Apache2, MySQL y Supervisor)* a partir de un fichero construído Dockerfile generar una imagen y subirla a un Docker registry público que serán los repositorios de Docker Hub.

Crear un cluster de nodos con **Docker Swarm** donde habrá un nodo manager y los nodos worker serán gestionados por el servicio de AWS **Auto Scaling Groups**, haciendo scale-out o scale-in elásticamente según unas "Scaling Polices". Las nuevas instancias EC2 estarán levantadas con ASG, se unirarán al Swarm y estarán distribuidas en las tres zonas de disponibilidad a, b y c de la región us-east-2 (Ohio). En el nodo manager se crea un servicio en base a la imagen subida a Docker Hub, se irá actualizando el servicio creando nuevas tareas de réplicas y que estas se repartan con un paralelismo de uno enntre los nodos worker disponibles y gestionados por ASG permitiendo así una mayor disponibilidad y balanceo de los recursos de contenedores con Docker Swarm.

Para unificar todo lo anterior y en una misma dirección pública de acceso a todas las instancias, se crea un **Elastic Load Balancer** que hará balanceo entre las instancias gestionadas por ASG y el nodo manager. ELB crea un DNS Name, se creará un registro CNAME en la gestión del dominio para que el subdominio *"web.itgal.es"* apunte al DNS Name del ELB.

Cuando se haga un scale-in de instancias con ASG los nodos en estado "Down" se eliminarán del Swarm de nodos a través de un bash script añadido como tarea programada que se ejecutará cada diez minutos en el nodo manager *(eliminar-nodos-down.sh)* consiguiendo que se eliminen los nodos *Down* que ya no forman parte del Swarm.


## Documentación

▶ **Documentación completa del proyecto**: https://goo.gl/xqZW2g

▶ **Presentación de Slides**: https://goo.gl/dT1sTi

▶ **Guía Referencia - Comandos Docker**: https://goo.gl/cP1UQZ

▶ **Video demo (PoC)**: https://www.youtube.com/watch?v=HzsBiJjgrOo
<p align="center">
<a href="https://www.youtube.com/watch?v=HzsBiJjgrOo" target="_blank"><img src="https://raw.githubusercontent.com/adrianlois/Docker-Swarm-AWS-ASG-ELB/master/screenshots/9-portada-videodemo-youtube-dockerswarm-aws-asg-elb.png" 
alt="portada-video-demo-youtube-dockerswarm-aws-asg-elb-adrianlois" width="700" target="_blank"/></a>
</p>

## Resumen

### Diagrama: Dockerfile > Imagen > Docker Hub
<p align="center"><img src="https://raw.githubusercontent.com/adrianlois/Docker-Swarm-AWS-ASG-ELB/master/screenshots/2-diagrama-dockerfile-dockerhub.png"  width="680" />
</p>


### Diagrama de la Infraestructura de AWS, Docker Swarm, Auto Scaling Groups y Elastic Load Balancing
<p align="center"><img src="https://raw.githubusercontent.com/adrianlois/Docker-Swarm-AWS-ASG-ELB/master/screenshots/3-diagrama-infraestructura-dockerswarm-aws-asg-elb.png" />
</p>


### Crear servicio con tareas de réplicas
<p align="center"><img src="https://raw.githubusercontent.com/adrianlois/Docker-Swarm-AWS-ASG-ELB/master/screenshots/4-dockerswarm-asg-elb-servicio-itgal-replicas.png" />
</p>


### ELB: Balanceo de carga entre instancias y DNS Name
<p align="center"><img src="https://raw.githubusercontent.com/adrianlois/Docker-Swarm-AWS-ASG-ELB/master/screenshots/5-elb-balanceo-instancias-asg-manager-dns-cname.png" />
</p>


### Balanceo de carga entre instancias y contenedores
<p align="center"><img src="https://raw.githubusercontent.com/adrianlois/Docker-Swarm-AWS-ASG-ELB/master/screenshots/6-webitgal-balanceo-swarm-elb.png" />
</p>


### ASG: Scale-in a cero de forma manual
<p align="center"><img src="https://raw.githubusercontent.com/adrianlois/Docker-Swarm-AWS-ASG-ELB/master/screenshots/7-scalein0-asg.png" />
</p>


### Eliminación de nodos "Down" del Swarm mediante bash scripting
<p align="center"><img src="https://raw.githubusercontent.com/adrianlois/Docker-Swarm-AWS-ASG-ELB/master/screenshots/8-eliminar-nodos-down-script.png" />
</p>
