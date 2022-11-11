### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 27: Datums- und Uhrzeitobjekte
### -------------------------------------------------------------------------


gebtag <- c(Daniel = "07.07.1986", Andreas = "12.09.1973",
  Neujahr98 = "01.01.1998")
gebtag



### -------------------------------------------------------------------------
### 27.1  Erste Einblicke
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 27.1.1  Datum und Uhrzeit abfragen -- Sys.Date(), Sys.time()


# Aktuelles Datum
date <- Sys.Date()
date

class(date)


# Aktuelle Datums- und Uhrzeitinfo
time <- Sys.time()
time

class(time)


# Interne Verwaltung von Date
unclass(date)

# Interne Verwaltung von POSIXct
unclass(time)


### -------------------------------------------------------------------------
### 27.1.3  Konvertierung -- as.Date(), as.POSIXct(), as.POSIXlt()


time

# Konvertierung in Klasse Date
time.Date <- as.Date(time)
time.Date

# Rückkonvertierung in Klasse POSIXct - Uhrzeit geht verloren!
as.POSIXct(time.Date)



### -------------------------------------------------------------------------
### 27.2  Datum und Uhrzeit formatieren
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 27.2.1  Formatierungsfunktionen und Platzhalter -- format.Date(),
###         format.POSIXct()


# Aktuelle Uhrzeit erfragen
# time <- Sys.time()
time

# 1.)
format(time, format = "Es ist %H:%M Uhr.")

# 2.)
format(time, format = "%d.%m.%Y %H:%M:%S")

# 3.)
format(time, format = "%A, der %d. %B %Y")


# Umwandlung in ein Date-Objekt
time.Date <- as.Date(time)
time.Date

# 3.)
format(time.Date, "%A, der %d. %B %Y")


### -------------------------------------------------------------------------
### 27.2.2  Datumsfunktionen -- weekdays(), months(), quarters()


# Heutiges Datum abfragen
# date <- Sys.Date()
date

# 1.) Wochentag bestimmen
weekdays(date)

# Abgekürzte Version
weekdays(date, abbreviate = TRUE)
# 1.) Wochentag bestimmen
format(date, "%A")

# Abgekürzte Version
format(date, "%a")

# 2.) Monat bestimmen
months(date)

# 2.) Monat bestimmen
format(date, "%B")

# Quartale bestimmen
quarters(date)



### -------------------------------------------------------------------------
### 27.3  Datums- und Uhrzeitobjekte erzeugen -- as.Date(), as.POSIXct()
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 27.3.1  Erzeugung aus Zeichenketten


# Der String mit den Geburtstagen
gebtag

# Umwandlung in ein Objekt der Klasse Date
gebtag.Date <- as.Date(gebtag)

# Erzeuge Objekt der Klasse Date
gebtag.Date <- as.Date(gebtag, format = "%d.%m.%Y")
gebtag.Date

# Erzeuge Objekt der Klasse POSIXct
as.POSIXct(gebtag, format = "%d.%m.%Y")

# Beschriftungen übernehmen
names(gebtag.Date) <- names(gebtag)
gebtag.Date

format(gebtag.Date, format = "%A")


### -------------------------------------------------------------------------
### 27.3.2  Erzeugung aus Referenzdatum bzw. Referenzuhrzeit


# Heutiges Datum abfragen
# date <- Sys.Date()
date

as.Date(c(-2, 0, 14), origin = date)


# Aktuelle Uhrzeit abfragen
# time <- Sys.time()
time

as.POSIXct(c(-2, 0, 14) * 24 * 60 * 60, origin = time)



### -------------------------------------------------------------------------
### 27.4  Datums- und Uhrzeitvektoren sortieren -- sort(), order()
### -------------------------------------------------------------------------


# Sortiere unsere Geburtstage aufsteigend (von erfahren bis jung)
sort(gebtag.Date)

# Sortiere unsere Geburtstage absteigend (von jung bis erfahren)
sort(gebtag.Date, decreasing = TRUE)

# Namen aufsteigend nach dem Geburtsdatum sortieren
names(gebtag.Date)[order(gebtag.Date)]

# Ist Daniel nach Andreas geboren?
gebtag.Date["Daniel"] > gebtag.Date["Andreas"]



### -------------------------------------------------------------------------
### 27.5  Rechnen mit Datumswerten
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 27.5.1  Tage und Sekunden addieren bzw. subtrahieren


# Heutiges Datum abfragen
# date <- Sys.Date()
date

# Morgen und Übermorgen
date + c(1, 2)

# Vorgestern und Gestern
date - c(2, 1)


### -------------------------------------------------------------------------
### 27.5.2  Paarweise Zeitdifferenzen bestimmen -- diff()


gebtag.Date

diff(gebtag.Date)


unclass(gebtag.Date)

diff(unclass(gebtag.Date))


### -------------------------------------------------------------------------
### 27.5.3  Parallele Zeitdifferenzen bestimmen -- "-", difftime()


# Das heutige Datum abfragen
# date <- Sys.Date()
date - gebtag.Date


### Falco-Beispiel

# Geburts- und Todesdatum erzeugen
falco <- as.Date(c("1957-02-19", "1998-02-06"))
falco

# 1.) Wie viele Tage / Wochen hat Falco gelebt?
diff(falco)
difftime(falco[2], falco[1], units = "days")

difftime(falco[2], falco[1], units = "weeks")

floor(difftime(falco[2], falco[1], units = "weeks"))


# Extrahiere das Jahr der Geburt und des Todes und berechne Jahresdifferenz
falco.year <- as.numeric(format(falco, "%Y"))
falco.year
diff(falco.year)

# Geburtstag im Jahr des Todes erstellen
temp <- paste0(format(falco[1], format = "%d.%m."),
               format(falco[2], format = "%Y"))
temp

falco.geb.tod <- as.Date(temp, format = "%d.%m.%Y")
falco.geb.tod

# War der Tod nach dem Geburtstag im Todesjahr?
falco[2] >= falco.geb.tod

# Alter korrigieren
diff(falco.year) - !(falco[2] >= falco.geb.tod)


### Unser jeweiliges Alter berechnen

# Heutiges Datum abfragen
# date <- Sys.Date()
date

gebtag.Date

# Geburtsjahre und heutiges Jahr extrahieren
geb.jahr <- as.numeric(format(gebtag.Date, format = "%Y"))
heute.jahr <- as.numeric(format(date, format = "%Y"))

geb.jahr
heute.jahr

# Die Geburtstage von uns in diesem Jahr generieren
geb.heuer <- paste0(format(gebtag.Date, format = "%d.%m."), heute.jahr)
geb.heuer <- as.Date(geb.heuer, format = "%d.%m.%Y")
geb.heuer

# Das korrekte Alter zum heutigen Zeitpunkt berechnen
alter <- heute.jahr - geb.jahr - !(date >= geb.heuer)
names(alter) <- names(gebtag.Date)
alter


### Unser jeweiliges Alter berechnen: 29.02. korrigieren

datum2902 <- as.Date(c("29.02.1996", "29.02.2021"), format = "%d.%m.%Y")
datum2902

# Füge zu Testzwecken eine neue Person hinzu
gebtag.Date <- c(gebtag.Date, Felix2902 = as.Date("1996-02-29"))
gebtag.Date

# Generiere den 17.03.2021 zu Testzwecken als heutiges Datum
date <- as.Date("2021-03-17") 
# Zur Bestimmung des aktuellen Alters durch Sys.Date() ersetzen
# date <- Sys.Date()
date

# Geburtsjahre und heutiges Jahr extrahieren
geb.jahr <- as.numeric(format(gebtag.Date, format = "%Y"))
heute.jahr <- as.numeric(format(date, format = "%Y"))
geb.jahr
heute.jahr

# Die Geburtstage von uns in diesem Jahr generieren
geb.heuer <- paste0(format(gebtag.Date, format = "%d.%m."), heute.jahr)
geb.heuer <- as.Date(geb.heuer, format = "%d.%m.%Y")
geb.heuer

# Korrektur für Geburtstage in Schaltjahren
bool.na <- is.na(geb.heuer)
bool.na

geb.heuer[bool.na] <- as.Date(paste0("01.03.", heute.jahr),
  format = "%d.%m.%Y")
geb.heuer

# Das korrekte Alter zum heutigen Zeitpunkt berechnen
alter <- heute.jahr - geb.jahr - !(date >= geb.heuer)
names(alter) <- names(gebtag.Date)
alter


### Tage bis zu unserem nächsten Geburtstag berechnen

date              # das heutige Datum
geb.heuer         # Datumsvektor mit den heurigen Geburtstagen

geb.heuer < date  # Heuer schon Geburtstag gehabt?

# Jahr des nächsten Geburtstages bestimmen
jahr <- heute.jahr + (geb.heuer < date)
jahr

# Nächsten Geburtstag ermitteln (basierend auf gebtag.Date!)
geb.next <- paste0(format(gebtag.Date, format = "%d.%m."), jahr)
geb.next <- as.Date(geb.next, format = "%d.%m.%Y")
names(geb.next) <- names(gebtag.Date)
geb.next

# Reparatur für Schaltjahre
date0103 <- as.Date(paste0(heute.jahr, "-03-01"))
date >= date0103  # Hat heuer der 01.03. schon stattgefunden?

kandidatenjahre <- heute.jahr + (date >= date0103) + 0:7
kandidatenjahre

# Kandidatendatumswerte generieren
date2902 <- as.Date(paste0("29.02.", kandidatenjahre), format = "%d.%m.%Y")
date2902

# Nächsten 29.02. extrahieren ...
date2902.next <- date2902[!is.na(date2902)][1]
date2902.next

# ... und NA-Werte damit ersetzen
geb.next[is.na(geb.next)] <- date2902.next
geb.next

# In wie vielen Tagen / Wochen sind unsere nächsten Geburtstage?
difftime(geb.next, date, units = "days")

difftime(geb.next, date, units = "weeks")



### -------------------------------------------------------------------------
### 27.6  Spezielle Datumswerte erzeugen und Locales
### -------------------------------------------------------------------------


### War der 01.01.2019 wirklich ein Dienstag?

# 1.) Über Wochentagsnamen
datum <- as.Date("2019-01-01")
weekdays(datum)

weekdays(datum) == "Dienstag"

# 2.) Über Zahlen
datum <- as.Date("2019-01-01")
format(datum, format = "%u")

format(datum, format = "%u") == "2"


### Alle ersten Samstage der Jahre 2021, 2022 und 2023 erzeugen

# Strategie 1: Selektionsstrategie

# 1.) Datumsvektor für die ersten 7 Tage aller Jahre erzeugen.
jahre <- rep(c(2021, 2022, 2023), each = 7)
datum.string <- paste(1:7, 1, jahre, sep = ".")
datum.string

# In Datumsobjekt umwandeln
datum <- as.Date(datum.string, format = "%d.%m.%Y")

# 2.) Alle Samstage selektieren
res <- datum[format(datum, "%u") == "6"]
res

# Kontrolle
weekdays(res)


# Strategie 2: Berechnungsstrategie

# 1.) Die 01.01. aller Jahre generieren
datum.string <- paste(1, 1, 2021:2023, sep = ".")
datum <- as.Date(datum.string, format = "%d.%m.%Y")
datum

# 2.) Anzahl der Tage bis zum nächsten Samstag berechnen
tag <- as.numeric(format(datum, "%u"))
tag

# Anzahl der Tage bis zum nächsten Samstag bestimmen
(6 + 7 - tag) %% 7

# 3.) Diese Anzahlen zu den 01.01. addieren
res <- datum + (6 + 7 - tag) %% 7
res

# Kontrolle
weekdays(res)



### -------------------------------------------------------------------------
### 27.7  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 27.7.2  Fallbeispiel: Berechnung von Adventsonntagen


# Jahre, für die wir uns interessieren.
jahre <- 2022:2024

# Datum für Heiligabend aller gesuchten Jahre generieren
heiligabend <- as.Date(paste(jahre, 12, 24, sep = "-"))
heiligabend

# Wochentag aller Heiligabende bestimmen
tag <- as.numeric(format(heiligabend, "%u"))
tag        # Wochentag von Heiligabend

tag %% 7   # Tage vom 4. Adventsonntag bis Heiligabend

# Datum des 1. Adventsonntages berechnen
advent1 <- heiligabend - (tag %% 7) - 21
advent1

# Kontrolle, ob alle diese Tage an einem Sonntag sind
all(format(advent1, "%u") == "7")

# Liste aller vier Adventsonntage aller Jahre erstellen ...
advent <- lapply(advent1, "+", seq(from = 0, by = 7, length = 4))
names(advent) <- paste("Adventsonntage", jahre, sep = "_")

# ... und ausgeben
advent



### -------------------------------------------------------------------------
### 27.8  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 27.8.3  Übungen


geb.posix <- as.POSIXct("1986-07-07 07:22:00 CET")


str1 <- "13 Uhr am 7. Jänner 2019"
str2 <- "32. Tag des Jahres 2019 um 15:30 Uhr"
