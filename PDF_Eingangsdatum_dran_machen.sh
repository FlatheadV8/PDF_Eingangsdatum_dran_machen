#!/bin/bash

#==============================================================================#
#
# zusätzliche Seite mit Eingangsdatum an die PDF-Datei anhängen
#
#------------------------------------------------------------------------------#
#
# ACHTUNG !!!
# Es sollten sich in diesem Verzeichnis keine EPS-Dateien befinden!
# Am Ende dieses Skriptes werden EPS-Dateien gelöscht.
#
#==============================================================================#
### Voreinstellungen

VERSION="v2016022300"

###
### Datumsformate
###
#DATUMFORMAT="%0e.%m.%Y" 	# altes Format
#DATUMFORMAT="%m/%0e/%Y" 	# US-Format
DATUMFORMAT="%Y-%m-%0e" 	# DIN-Format / EURO-Format

###
### zu verwendende Dokumentenbetrachter, Leerzeichen getrennt angeben
### Suchreihenfolge: Links -> Rechts
### das 1. gefundene Programm wird verwendet
###
### hiermit soll die letzte generierte EPS-Datei angezeigt werden,
### weil pdf2ps oft noch eine leer Seite "erfindet"
###
# atril  - Dokumentenbetrachter in MATE (Gnome 2.3 - Fork)
# evince - Dokumentenbetrachter in Cinnamon
LISTE_DOKUMENTEN_BETRACHTER="evince atril"

###
### Schriftzug quer über die (neue) letzte Seite
###
POSITION="+120-250"		# Startposition: "links-oben"

###
### 
###
LETZTE_SEITE="
Soll die gerade gezeigte Seite entfernt werden?

Aus technischen Gründen wird oft eine zusätzliche leere Seite
generiert, die man meistens nicht braucht.

Wenn diese Seite leer ist, kann sie bedenkenlos entfernt werden.

Das wird sonst die letzte Seite (vor dem Eingangsdatum) sein.
"

###
### Zeichensatz für die (neue) letzte Seite
### mit Eingangsdatum
###
#
# 88591, latin1, 88592, latin2, 88593, latin3, 88594, latin4, 88595, cyrillic,
# 88597, greek, 88599, latin5, 885910, latin6, ascii, asciifise, asciifi,
# asciise, asciidkno, asciidk, asciino, ibmpc, pc, dos, mac, vms, hp8, koi8,
# ps, PS, pslatin1, ISOLatin1Encoding
#
PSENCODING="pc"			# Encoding

#------------------------------------------------------------------------------#
### Parameterabfrage per zenity

if [ -z "${1}" ] ; then
	PDFDATEI="$(zenity --file-selection)"
else
	PDFDATEI="${1}"
fi

#------------------------------------------------------------------------------#
### Arbeitsverzeichnis
cd $(dirname ${PDFDATEI}) || exit 1

#------------------------------------------------------------------------------#
### Eingangsdatum fest legen + Texteingaben

DATUM_TEXT="$(zenity --forms --text="  Eingang  " --add-calendar="Wähle das Eingangsdatum:" --forms-date-format="${DATUMFORMAT}" --add-entry="Texteingabe-Feld 01:" --add-entry="Texteingabe-Feld 02:" --add-entry="Erledigt" --add-list="ausgewählte PDF-Datei:" --list-values="${PDFDATEI}")"
EINGANGSDATUM="$(echo "${DATUM_TEXT}" | awk -F'|' '{print $1}')"
EINGABETEXT01="$(echo "${DATUM_TEXT}" | awk -F'|' '{print $2}')"
EINGABETEXT02="$(echo "${DATUM_TEXT}" | awk -F'|' '{print $3}')"
ERLEDIGT="$(echo "${DATUM_TEXT}" | awk -F'|' '{print $4}')"

#------------------------------------------------------------------------------#
### Name generieren

NAME="$(echo "${PDFDATEI}" | rev | awk '{sub("[.]"," ");print $2}' | rev)"

#------------------------------------------------------------------------------#
### PDF -> EPS

pdf2ps ${PDFDATEI} ${NAME}_%04d.eps		2>/dev/null

#------------------------------------------------------------------------------#
# Dokumentenbetrachter suchen, mit dem die letzte Seite angezeigt werden kann

DOKUMENTENBETRACHTER="$(for i in ${LISTE_DOKUMENTEN_BETRACHTER}
do
	which ${i}
done | grep -Ev '^$' | head -n1)"

if [ -e "${DOKUMENTENBETRACHTER}" ] ; then
	#----------------------------------------------------------------------#
	### letzte generierte Seite suchen

	LETZTE_EPS="$(ls -1 ${NAME}_*.eps | tail -n1)"

	#----------------------------------------------------------------------#
	### letzte generierte Seite anzeigen und evtl. entfernen

	if [ -e "${LETZTE_EPS}" ] ; then
		${DOKUMENTENBETRACHTER} ${LETZTE_EPS}
		zenity --question --text="${LETZTE_SEITE}" && rm -f ${LETZTE_EPS}
	fi
fi

#------------------------------------------------------------------------------#
### eine TEXT-Datei mit Zeitstempel erzeugen

echo "
+------------------------------------------------------------------------------+
| Eingang:  ${EINGANGSDATUM}                                                         |
+------------------------------------------------------------------------------+
|                                                                              |
|  ${EINGABETEXT01}
|                                                                              |
+------------------------------------------------------------------------------+
|                                                                              |
|  ${EINGABETEXT02}
|                                                                              |
+------------------------------------------------------------------------------+
|                       |                                                      |
|       Erledigt        |  ${ERLEDIGT}
|                       |                                                      |
+------------------------------------------------------------------------------+
" > ${NAME}_9999.txt

#------------------------------------------------------------------------------#
### TXT -> EPS

enscript -B -h --ul-style=outline --ul-position="${POSITION}" --ul-gray=.1 --ul-font=Courier48 -f Courier10 -u"Eingang: ${EINGANGSDATUM}" -w PostScript -X ${PSENCODING} ${NAME}_9999.txt -o ${NAME}_9999.eps		2>/dev/null

#------------------------------------------------------------------------------#
### EPS -> PDF

gs -dSAFER -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=${NAME}+Zeitstempel.pdf -f ${NAME}_*.eps

#------------------------------------------------------------------------------#
### aufräumen

#cat ${NAME}_9999.txt
#rm -vf ${NAME}_9999.txt ${NAME}_*.eps
rm -f ${NAME}_9999.txt ${NAME}_*.eps

#------------------------------------------------------------------------------#
### Ergebnisse anzeigen

ls -l ${NAME}+Zeitstempel.pdf ${PDFDATEI}
${DOKUMENTENBETRACHTER} ${NAME}+Zeitstempel.pdf
