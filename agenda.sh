#!/bin/bash
if [[ -f ./.task ]]; then
	echo "Agenda trouvé !"
	echo "Mise à jour des données.."
	touch ./.temp
	sort -n -t"/" -k3 -k2 -k1 ./.task >./.temp
	cat ./.temp >./.task
	>./.temp
	sleep 1
	echo "Mise à jour réussi."
	sleep 1
else
	echo "Génération de l'agenda en cours..."
	touch .task
	sleep 1
	echo "Agenda créé avec succès !"
	sleep 1
fi
clear
echo -e "Bonjour et bienvenue dans l'agenda ! \n \n"

echo "[1] Créer une nouvelle tâche"
echo "[2] Créer un nouveau groupe"
echo "[3] Supprimer une tâche"
echo "[4] Supprimer un groupe"
echo "[5] Lister mes tâches"
echo -e "[6] Quitter l'agenda \n \n"

read -p "Que voulez-vous faire ? " choix

if [ $choix == 1 ]; then # |||||| CREER NOUVELLE TACHE ||||||
	#vider le fichier .temp
	>./.temp
	clear
	echo -e " --- CREATION DE TACHE --- \n"
	echo -e "Nous sommes le \c"
	echo -e "$(date +%d/%m/%Y), soit le $(date) \n"
	ncal 2018
	echo -e "\n"
	read -p "Entrez une date (jj/mm/yyyy) : " dateTache
	read -p "Entrez la description de la tâche : " descriptionTache
	echo -e "\nListe des groupes actuellement existants :"
	#séparer les différents champs
	while IFS=: read date description groupe etat; do
		echo $groupe >>./.temp
	done <./.task
	cat ./.temp | sort | uniq
	read -p "Rentrez le nom du groupe (si inexistant, créera un nouveau groupe) : " groupe
	echo -e "\nAjouter une tâche pour le "$dateTache", dont la description est \"$descriptionTache\", et qui appartient au groupe \"$groupe\" ? (y/n)"
	read confirmation
	if [ $confirmation == "y" ]; then
		echo "$dateTache:$descriptionTache:$groupe:EN COURS" >>./.task
		echo "Tâche ajoutée avec succès !"
		>./.temp
		sort -n -t"/" -k3 -k2 -k1 ./.task >./.temp
		cat ./.temp >./.task
		>./.temp
		echo "Mise à jour réussi !"
	else
		exit
	fi
	# Quand tâche rentrée, trier les listes d'un groupe par date
elif [ $choix == 2 ]; then # |||||| CREER NOUVEAU GROUPE ||||||
	read -p "Entrez un nom de groupe : " nomGroupe
	# Condition si le groupe existe déjà (vérifier dans le tableau groupe)
	# ---- Tableau Groupe se créer en lisant le fichier texte (partie groupe) ----
elif [ $choix == 3 ]; then # ||||||| SUPPRIMER UNE TACHE ||||||
	read -p "Selectionner par groupe[1] ou par date[2] ou sans filtre[3] ? " choix
	if [ $choix == 1 ]; then
		# Lister les groupes
		echo -e "\nListe des groupes actuellement existants :"
		while IFS=: read date description groupe etat; do #séparer les différents champs
			echo $groupe >>./.temp
		done <./.task
		cat ./.temp | sort | uniq
		read -p "Rentrez un groupe : " groupeALister
		# Lister les tâches du groupe
		echo -e "\nListe des tâches du groupe \"$groupeALister\" :"
		>./.temp #vider le cache
		ligne=1
		while IFS=: read date description groupe etat; do #séparer les différents champs
			if [ "$groupe" == "$groupeALister" ]; then
				echo -e "[$ligne] date : \"$date\", description : \"$description\", état : \"$etat\"" >>./.temp
				((ligne++))
			fi
		done <./.task
		cat ./.temp
		read -p "Quelle tâche voulez-vous supprimer ? " tache
		echo "Supprimer la tâche n°$tache ? (y/n)"
		read confirmation
		if [ $confirmation == "y" ]; then
			sed "\{$tache\}d" .task
			>./.temp
			sort -n -t"/" -k3 -k2 -k1 ./.task >./.temp
			cat ./.temp >./.task
			>./.temp
			echo "Mise à jour réussi !"
			sleep 4
			cat ./.task
		else
			exit
		fi
	elif [ $choix == 2 ]; then
		read -p "Entrez une date (jj/mm/yyyy) : " dateTache
		# Lister les tâches de la date rentrée en indexant !
		read -p "Quelle tâche voulez-vous supprimer ? " tache
		# Message de vérification
	# A compléter !!
	fi
elif [ $choix == 4 ]; then # |||||| SUPPRIMER UN GROUPE (Récursive ou pas ?) ||||||
	# Lister les groupes
	read -p "Quel groupe supprimer ? " groupe
	# Message de vérification
elif [ $choix == 5 ]; then # |||||| LISTER LES TÂCHES AVEC MOIS ET GROUPE EN OPTION ||||||
	clear
	echo "Lister par groupe[1], par date[2], ou sans filtre[3] ?"
	read choix
	if [ $choix == 1 ]; then
		###
		<./.temp
		echo -e "\nListe des groupes actuellement existants :"
		while IFS=: read date description groupe etat; do #séparer les différents champs
			echo $groupe >>./.temp
		done <./.task
		cat ./.temp | sort | uniq
		read -p "Rentrez le nom groupe : " groupe
		reset
		echo -e "Nous sommes le \c"
		echo -e "$(date +%d/%m/%Y), soit le $(date) \n"
		echo -e "Liste des tâches du groupe $groupe : \n"
		while read line; do
			if [ $(echo $line | cut -d: -f3) == $groupe ]; then
				echo -e "Date :  \c"
				echo $line | cut -d: -f1
				echo -e "Description : \c"
				echo $line | cut -d: -f2
				echo -e "Groupe : \c"
				echo $line | cut -d: -f3
				echo -e "Etat : \c"
				echo $line | cut -d: -f4
				echo ""
			fi
		done <./.task
	elif [ $choix == 2 ]; then
		read -p "Entrez une date (jj/mm/yyyy) : " date
		reset
		echo -e "Nous sommes le \c"
		echo -e "$(date +%d/%m/%Y), soit le $(date) \n"
		echo -e "Liste des tâches à faire pour le $date : \n"
		while read line; do
			if [ $(echo $line | cut -d: -f1) == $date ]; then
				echo -e "Date :  \c"
				echo $line | cut -d: -f1
				echo -e "Description : \c"
				echo $line | cut -d: -f2
				echo -e "Groupe : \c"
				echo $line | cut -d: -f3
				echo -e "Etat : \c"
				echo $line | cut -d: -f4
				echo ""
			fi
		done <./.task
	elif [ $choix == 3 ]; then
		reset
		echo -e "Nous sommes le \c"
		echo -e "$(date +%d/%m/%Y), soit le $(date) \n"
		while IFS=: read date description groupe etat; do
			jour=$(echo $date | cut -d/ -f1)
			mois=$(echo $date | cut -d/ -f2 | sed "s/01/janvier/" | sed "s/02/février/" | sed "s/03/mars/" | sed "s/04/avril/" | sed "s/05/mai/" | sed "s/06/juin/" | sed "s/07/juillet/" | sed "s/08/août/" | sed "s/09/septembre/" | sed "s/10/octobre/" | sed "s/11/novembre/" | sed "s/12/décembre/")
			annee=$(echo $date | cut -d/ -f3)
			echo -e "Date : $jour $mois $annee\n\
			Description : $description\n\
			Groupe : $groupe\n\
			Etat : $etat\n"
		done <./.task
	fi
elif [ $choix == 6 ]; then # |||||| QUITTER ||||||
	exit
fi