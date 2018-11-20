# Recorrer el cluster de nodos del Swarm, encontrar los nodos Down y eliminarlos del Swarm.
#!/bin/bash
nodo_down=$(docker node ls | grep Down | sed -n '1p' | awk '{print $1}')
while [ "$nodo_down" != "" ];
do
  nodo_down=$(docker node ls | grep Down | sed -n '1p' | awk '{print $1}')
  docker node rm --force "$nodo_down"
done
