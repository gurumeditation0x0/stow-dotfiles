#!/bin/bash

if [ "$1" = "" ] ; then
  echo -n "Nom du processus : "
  read process
else
  process=$1
fi

if ps aux | awk '{print $11}' | grep -q $process ; then
  size=$(ps aux | grep $process | awk '{sum+=$6/1024/1024} END {printf("%.2f", sum)}')
  echo "Taille de RAM utilisée par le processus $process : $size GiB"
else
  echo "Aucun processus nommé $process trouvé."
fi

total=$(ps aux | awk '{sum+=$6/1024/1024} END {printf("%.2f", sum)}')
echo "Taille totale de RAM utilisée par tous les processus : $total GiB"
