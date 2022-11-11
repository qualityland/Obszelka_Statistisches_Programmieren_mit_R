### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 05: Arbeitsverzeichnis, Objekte und Dateiordner
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 5.1  Objekte
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 5.1.1  Objekte auflisten -- ls()


# Zeige alle erstellten Objekte an
ls()

# Zugriff auf ein existierendes Objekt
stapel


### -------------------------------------------------------------------------
### 5.1.2  Objekte löschen -- rm(), rm(list = ls())


ls()
hand1
hand2

# Lösche die Objekte hand1 und hand2
rm(hand1, hand2)

ls()
hand1
hand2


# Lösche alle erstellten Objekte
rm(list = ls())
ls()



### -------------------------------------------------------------------------
### 5.2  Pfade und Arbeitsverzeichnis -- getwd(), setwd(), ".."
### -------------------------------------------------------------------------


# Arbeitsverzeichnis anzeigen
getwd()

# Arbeitsverzeichnis wechseln
setwd(dir = "D:/Studium/Statistisches Programmieren")

# Arbeitsverzeichnis wechseln - nicht existierender Ordner
setwd(dir = "D:/Dieser Ordner existiert nicht")

# Arbeitsverzeichnis wechseln
setwd("D:/Studium")                   # Absoluter Pfad
getwd()

# Wechsle in den Unterordner Statistisches Programmieren
setwd("Statistisches Programmieren")  # Relativer Pfad
getwd()


getwd()

# Wechsle in den darüberliegenden Ordner
setwd("..")
getwd()



### -------------------------------------------------------------------------
### 5.3  Objekte speichern und laden -- save(), load()
### -------------------------------------------------------------------------


# Arbeitsverzeichnis festlegen
setwd("D:/Studium/Statistisches Programmieren")

# Kartenstapel erzeugen
stapel <- c(4, 7, 6, 2, 3, 5)

# Karten an 2 Spieler verteilen
bool1 <- c(TRUE, FALSE)
hand1 <- stapel[bool1]
hand2 <- stapel[!bool1]

# Diverse Berechnungen anstellen

# Daten sichern
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
save(stapel, hand1, hand2, file = "Karten.RData")


# Kartenspieldaten laden
load("Karten.RData")

# Kartenspieldaten laden - mit den Namen der geladenen Objekte
objekte <- load("Karten.RData")
objekte



### -------------------------------------------------------------------------
### 5.4  Namen von Ordnern und Dateien abrufen -- list.files()
### -------------------------------------------------------------------------


# Arbeitsverzeichnis anzeigen
getwd()

# Ordner und Objekte des Verzeichnisses anzeigen
list.files()



### -------------------------------------------------------------------------
### 5.5  Funktionen zur Manipulation von Dateien und Ordnern
### -------------------------------------------------------------------------


# Arbeitsverzeichnis anzeigen
getwd()

# Datei im Arbeitsverzeichnis erzeugen
file.create("AlteDatei.txt")
# Datei im Arbeitsverzeichnis kopieren
file.copy(from = "AlteDatei.txt", to = "KopierteDatei.txt")
# Datei im Arbeitsverzeichnis umbenennen
file.rename(from = "AlteDatei.txt", to = "NeueDatei.txt")


dateien <- c("AlteDatei.txt", "NeueDatei.txt", "KopierteDatei.txt")

file.exists(dateien)   # Existieren die Dateien?

file.remove(dateien)   # Dateien löschen

file.exists(dateien)   # Existieren die Dateien?
