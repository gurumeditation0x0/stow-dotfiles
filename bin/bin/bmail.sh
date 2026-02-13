#!/bin/bash

free="$HOME/.Mail/free"
gmail="$HOME/.Mail/gmail"
laposte="$HOME/.Mail/laposte"

cree_repertoire_mail() {
	for rep_mail in "$@"; do
		chemin="$HOME/.Mail/$rep_mail"
		if [ -d "$chemin" ]; then
			echo "Le dossier $chemin existe!";
		else
			mkdir -p "$chemin"
			echo "Le dossier $chemin à été créé."
		fi
	done
}

# Vérifie si des arguments ont été passés en ligne de commande
if [ "$#" -eq 0 ]; then
	cree_repertoire_mail "free" "gmail" "laposte"
else
	cree_repertoire_mail "$@"
fi
