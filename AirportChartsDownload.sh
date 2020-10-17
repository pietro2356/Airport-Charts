#! /bin/bash

# -----------------------
# Autore: Rocchio Pietro
# -----------------------

# Funzione gestione errori
error_exit(){
	echo "$1" 1>&2
	exit 1
}


# Inizio programma
echo "Inserisci il codice ICAO dell'aereoporto: "
read icao

if ls | grep $icao # Verifichiamo di non avere già le carte dell'aereoporto selezionato.
then
	error_exit "Le carte di questo aereoporto sono già presenti!"
fi

# Scarichiamo il file e salviamo il codice di stato HTTP in OUT1.
OUT1=$(wget --server-response https://charts.avbot.in/$icao.pdf 2>&1 | awk '/^  HTTP/{print $2}')
if echo $OUT1 | grep '200'
then
	echo "Success: $OUT1"
	read -p "Download Terminato. Vuoi rinominare il file? [Y/n] " yn
	case $yn in
		[Yy]* )
			echo "Inserisci il nome del file dopo la sigla: $icao - ";
			read name;
			mv $icao.pdf "$icao - $name.pdf";
			echo "File rinominato con successo: $(ls | grep $icao)";
			exit 0;;
		[Nn]* )	exit 0;;
		* ) echo "Opzione non valida!"; exit -1;;
	esac
else
	error_exit "Error $OUT1 -- Operazione annullata!"
fi
