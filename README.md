# PDF_Eingangsdatum_dran_machen
Manchen PDF-Dateien möchte man gelegentlich (elektronisch) einen Eingangs-Stempel aufdrücken. Mit diesem Skript geht das.

Dieses Skript wurde in KW07 und KW08 des Jahres 2016 auf "Linux Mint 17.2 Cinnamon" geschrieben und getestet.

Als erstes muss das Skript an seinen Bestimmungsort kopiert werden.
Das ist in diesem Beispiel "/usr/local/bin/".

Wenn das Skript ohne Parameter aufgerufen wird, dann öffnet sich als erstes ein Dateiauswahlfenster:

    /usr/local/bin/PDF_Eingangsdatum_dran_machen.sh

Bekommt es beim Start gleich die zu bearbeitende PDF-Datei als Parameter mit übergeben, dann wird das Dateiauswahlfenster übersprungen:

    /usr/local/bin/PDF_Eingangsdatum_dran_machen.sh test.pdf

Danach öffnen sich folgende Fenster:
* hier kann das Eingangsdatum ausgewählt werden, zwei freie Text-Felder beschrieben werden, ein Erledigt-Feld beschrieben werden und die ausgewählte Datei angezeigt;
* Aus technischen Gründen wird oft eine zusätzliche leere Seite generiert, die man meistens nicht braucht. An dieser Stelle wird die letzte erzeugte Seite, mit einem Dokumentenbetrachter (PDF-Viewer), angezeigt. Wenn diese Seite leer ist, kann sie bedenkenlos entfernt werden.
* Hier wird gefragt, ob die gerade angezeigte Seite gelöscht werden soll. Beantwortet man die Frage mit "Ja", dann wird sie gelöscht, beantwortet man diese Frage mit "Nein", dann bleibt sie erhalten.
* Jetzt wird die neu erzeugte PDF-Datei mit einer zusätzlichen Seite am Ende, auf der das Eingangsdatum steht, mit einem Dokumentenbetrachter (PDF-Viewer), angezeigt. Sie liegt im selben Verzeichnis wie die zu bearbeitende PDF-Datei.

Das Skript benötigt die folgenden Programme:
* pdf2ps
* gs
* zenity
* enscript
* [Dokumentenbetrachter]

Diese Programme sind bei "Linux Mint 17.2" in den folgenden Paketen enthalten (diese müssen installiert sein!):
* ghostscript
* zenity
* enscript

Als Dokumentenbetrachter sind folgende Programme voreingetragen (mind. eines davon muss installiert sein!):
* evince
* atril

Es kann aber auch ein anderes Programm hinzugefühgt werden. Die Liste wird von links nach rechts durchlaufen, das Programm, welches zuerst gefunden wird, das wird als "Dokumentenbetrachter" verwendet.
