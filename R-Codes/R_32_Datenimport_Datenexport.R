### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 32: Datenimport und Datenexport
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 32.1  Einfache Dateiformate
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 32.1.1  Textdateien einlesen -- read.table()


file <- "D:/RBuch/Daten/Vertreter1.txt"
daten <- read.table(file, header = TRUE, dec = ",", fileEncoding = "UTF-8",
  stringsAsFactors = TRUE)
head(daten, n = 7)


setwd("D:/RBuch/Daten")
file <- "Vertreter1.txt"
daten <- read.table(file, header = TRUE, dec = ",", fileEncoding = "UTF-8",
  stringsAsFactors = TRUE)
head(daten, n = 7)


### -------------------------------------------------------------------------
### 32.1.2  Textdateien schreiben -- write.table()


# Gewinnstufe berechnen und an daten anhängen
gewinn.kat <- cut(daten$Gewinn, breaks = c(-Inf, 5, 10, Inf),
  labels = c("wenig", "mittel", "viel"), ordered_result = TRUE)
daten$Gewinnstufe <- gewinn.kat

# Speichern als txt-Datei mit Tabulator als Trennzeichen
write.table(daten, file = "Vertreter_Gewinnstufe.txt", quote = FALSE,
  sep = "\t", dec = ",", row.names = FALSE, fileEncoding = "UTF-8")

# Speichern als csv-Datei mit ; als Trennzeichen
write.table(daten, file = "Vertreter_Gewinnstufe.csv", quote = FALSE,
  sep = ";", dec = ",", row.names = FALSE, fileEncoding = "UTF-8")



### -------------------------------------------------------------------------
### 32.2  Zeichencodierung
### -------------------------------------------------------------------------


# Ggf. Arbeitsverzeichnis wechseln
# setwd("...")
daten.roh <- read.table(file = "Vertreter1.txt", header = TRUE, dec = ",",
  stringsAsFactors = TRUE)
daten.utf8 <- read.table(file = "Vertreter1.txt", header = TRUE, dec = ",",
  fileEncoding = "UTF-8", stringsAsFactors = TRUE)

# Ohne UTF-8-Codierung
head(daten.roh, n = 7)

# Mit UTF-8 Codierung
head(daten.utf8, n = 7)


### -------------------------------------------------------------------------
### 32.2.1  Zeichencodierungsstandards


# Extrahiere die falsch geschriebene Kategorie Süd
temp <- grep("S.+d", levels(daten.roh$Gebiet), value = TRUE)
temp

# Die falsch codierte Version hat 4 Zeichen.
nchar(temp)


### -------------------------------------------------------------------------
### 32.2.2  Zeichencodierung umstellen -- Encoding(), options(encoding)


temp

# Encoding auf UTF-8 umstellen
Encoding(temp) <- "UTF-8"
temp

# Die richtig codierte Version hat 3 Zeichen.
nchar(temp)


# Standardmässigen Zeichencodierungsstandard umstellen
opt <- options(encoding = "UTF-8")

# Ggf. Arbeitsverzeichnis wechseln
# setwd("...")
daten.utf8 <- read.table(file = "Vertreter1.txt", header = TRUE, dec = ",",
  stringsAsFactors = TRUE)
head(daten.utf8, n = 7)

# Optionen wieder zurücksetzen
options(opt)


### -------------------------------------------------------------------------
### 32.2.3  Reparaturen per Hand


# Extrahiere die falsch geschriebene Kategorie Süd
temp <- grep("S.+?d", levels(daten.roh$Gebiet), value = TRUE)
temp

# Extrahiere falsch interpretierte Zeichenkombination per Hand
zeichen <- substring(temp, 2, 3)
zeichen

# Korrigiere alle Vorkommen
gsub(zeichen, "ü", temp)



### -------------------------------------------------------------------------
### 32.3  Datenaufbereitung
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 32.3.1  Herausforderungen beim Einlesen meistern


daten <- read.table("Vertreter2.csv", skip = 9, sep = ";",
  dec = ",", header = TRUE, nrows = 24, na.strings = c("NA", "na", ""),
  strip.white = TRUE, fileEncoding = "UTF-8", stringsAsFactors = TRUE)

daten <- read.table("Vertreter2.txt", skip = 9, sep = "\t",
  dec = ",", header = TRUE, nrows = 24, na.strings = c("NA", "na", ""),
  strip.white = TRUE, fileEncoding = "UTF-8", stringsAsFactors = TRUE)

temp <- read.table("Vertreter2.txt", skip = 9, sep = "\t",
  dec = ",", header = TRUE, nrows = 24, na.strings = c("NA", "na", ""),
  fileEncoding = "UTF-8", stringsAsFactors = TRUE)

head(temp, n = 8)

temp$Ausbildung
levels(temp$Ausbildung)


head(daten, n = 8)

daten$Gebiet

daten$Ausbildung

daten$Gewinn

daten$Datum


daten$Gebiet <- factor(daten$Gebiet,
  levels = c("West", "Nord", "Ost", "Süd", "Zentrum"))
daten$Ausbildung <- factor(daten$Ausbildung,
  levels = c("Matura", "Lehre"))

daten$Datum <- as.Date(daten$Datum, format = "%d.%m.%Y")

# Gewinn in String umwandeln
daten$Gewinn <- as.character(daten$Gewinn)

# Ersetze alle "," durch "."
daten$Gewinn <- sub(pattern = ",", replacement = ".", daten$Gewinn)

# Wandle Gewinn in numerischen Vektor um
daten$Gewinn <- as.numeric(daten$Gewinn)

head(daten, n = 8)

levels(daten$Gebiet)      # Kategorien nach Wunsch gereiht - passt :-)
levels(daten$Ausbildung)  # Kategorien nach Wunsch gereiht - passt :-)

daten$Gewinn
is.numeric(daten$Gewinn)  # TRUE - passt :-)

class(daten$Datum)        # Date - passt :-)


### -------------------------------------------------------------------------
### 32.3.2  Strings nicht als Faktoren einlesen -- stringsAsFactors


daten <- read.table("Vertreter2.txt", skip = 9, sep = "\t",
  dec = ",", header = TRUE, nrows = 24,
  na.string = c("NA", "na", ""), strip.white = TRUE,
  fileEncoding = "UTF-8", stringsAsFactors = FALSE)

# Variablen aufbereiten
daten$Gebiet <- factor(daten$Gebiet, levels =
  c("West", "Nord", "Ost", "Süd", "Zentrum"))
daten$Datum <- as.Date(daten$Datum, format = "%d.%m.%Y")
daten$Ausbildung <- factor(daten$Ausbildung, levels = c("Matura", "Lehre"))

# daten$Gewinn <- as.character(daten$Gewinn) # entfällt
daten$Gewinn <- sub(",", ".", daten$Gewinn)
daten$Gewinn <- as.numeric(daten$Gewinn)



### -------------------------------------------------------------------------
### 32.4  Textdateien mit beliebigem Format einlesen -- scan()
### -------------------------------------------------------------------------


# Verzeichnis wechseln
# setwd("...")

# 1. Vertreter.txt einlesen
daten <- read.table("Vertreter.txt", sep = "\t", dec = ",", header = TRUE)
names(daten)[1] <- gsub("^.+[.]+", "", names(daten)[1])
head(daten, n = 5)

# 2. Auflistung aller Dateien, die sich im Verzeichnis befinden
files <- list.files()
files 

# Suche nach dem Wort Labels
bool <- grepl("Labels", files, ignore.case = TRUE)
file <- files[bool]
file

# 3. Einlesen mit scan()
# what = "" ist notwendig
rohdaten <- scan(file, what = "", encoding = "UTF-8")
rohdaten

# Index der Variablennamen
indvar <- grep("Variable", rohdaten) + 1
indvar

# Variablennamen extrahieren
variablennamen <- rohdaten[indvar]
variablennamen

# Einträge rechts von "=" sind die gewünschten Labels
indlabel = grep("=", rohdaten) + 1
indlabel

label <- rohdaten[indlabel]
label

# Werte zu den richtigen Variablen zuordnen
nr <- as.numeric(cut(indlabel, breaks = c(indvar, Inf)))
nr

for (i in 1:length(variablennamen)) {
  daten[[variablennamen[i]]] <- factor(daten[[variablennamen[i]]],
    labels = label[nr == i])
}

head(daten, n = 5)



### -------------------------------------------------------------------------
### 32.5  Textdateien mit beliebigem Format schreiben -- cat()
### -------------------------------------------------------------------------


personen <- data.frame(Name = c("Tom", "Anna"), Alter = c(28, NA),
  Wohnort = c("Mödling", "Wien"), stringsAsFactors = FALSE)
personen

# xml-Tags an jede Variable anhängen
namen <- paste0("    <name>",    personen$Name,    "</name>\n")
alter <- paste0("    <alter>",   personen$Alter,   "</alter>\n")
ort   <- paste0("    <wohnort>", personen$Wohnort, "</wohnort>\n")

# <person> und </person> an jedes Datum anhängen
string <- paste0("<person>\n", namen, alter, ort, "</person>\n",
  collapse = "")

opt <- options(encoding = "UTF-8")

# Datei abspeichern
# Ggf. Verzeichnis wechseln
# setwd(...)
cat(string, file = "Personen.xml")

# Optionen zurücksetzen
options(opt)



### -------------------------------------------------------------------------
### 32.6  Einlesen aus anderen Quellen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 32.6.1  Excel-Dateien einlesen -- read.xlsx()


# Paket xlsx einmalig installieren
# install.packages("xlsx")

# Paket xlsx laden
library(xlsx)

daten.xls <- read.xlsx(file = "Vertreter2.xls", sheetName = "Vertreter2",
  encoding = "UTF-8", startRow = 7, endRow = 31)
head(daten.xls, n = 8)


### -------------------------------------------------------------------------
### 32.6.2  SPSS- und SAS-Dateien einlesen -- read.spss(), read.sas()


# Paket einmalig installieren
# install.packages("foreign")

# Paket foreign laden
library(foreign)

# Ggf. Arbeitsverzeichnis wechseln
# setwd(...)

daten <- read.spss("Vertreter1.sav", to.data.frame = TRUE)
head(daten, n = 7)

daten$Gebiet
