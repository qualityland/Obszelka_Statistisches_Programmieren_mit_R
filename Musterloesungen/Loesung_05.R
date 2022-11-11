### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 5
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Definiere Zielordner als absoluten Pfad
ordner <- "D:/Studium/Statistisches Programmieren"


### a)

setwd(ordner)


### b)

# Erstelle im Ordner ordner einen neuen Ordner "Neuer Ordner"
# Das funktioniert, weil wir in a) das Arbeitsverzeichnis gewechselt haben.
dir.create("Neuer Ordner")


### c)

# In den darueberliegenden Ordner wechseln
setwd("..")
getwd()

# Mit relativem Pfad einen Ordner "Weiterer Ordner" erstellen
dir.create("Statistisches Programmieren/Weiterer Ordner")


### d)

# Mit file.exists()
file.exists("Statistisches Programmieren/Neuer Ordner")
file.exists("Statistisches Programmieren/Weiterer Ordner")

# Ohne file.exists()
temp <- list.files("Statistisches Programmieren")
temp

all(c("Neuer Ordner", "Weiterer Ordner") %in% temp)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Hilfe zu list.files()
# ?list.files


### a)

# Bei recursive = TRUE wird nicht nur der Inhalt des betrachteten Ordners
# angezeigt, sondern auch rekursiv der Inhalt aller Ordner (insbesondere
# auch alle Unterordner).


### b)

# In der R-Hilfe zu list.files() entdecken wir die Funktion list.dirs(),
# die sich perfekt eignet. Folgende Einstellmoeglichkeiten gibt es:
# .) full.names: Bei TRUE (Standard) wird der gesamte absolute Pfad,
#                bei FALSE nur der Name der Ordner angezeigt.
# .) recursive:  Siehe a)

