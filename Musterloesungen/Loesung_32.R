### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 32
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


### a)

# 1.) Wir lesen die Daten via scan ein.
# Arbeitsverzeichnis wechseln in jenen Ordner, in dem sich die Datei
# Personen.xml befindet.
# setwd("...")
rohdaten <- scan("Personen.xml", what = "", encoding = "UTF-8")
rohdaten

# 2.) Die Daten stehen zwischen den Tags <...> und </...>
# Genau da setzen wir an, um die Informationen zu extrahieren.
# Ein Name etwa wird von <name> und </name> umschlossen. Dazwischen stehen
# beliebige Buchstaben und ggf. Leerzeichen. Um Umlaute zu umschiffen,
# matchen wir jedes Zeichen ausser "<". Wir bestimmen jene Stellen, an
# denen die relevanten Informationen stehen.
ind.name <- grep("<name>[^<]+</name>", rohdaten)
ind.alter <- grep("<alter>[^<]+</alter>", rohdaten)
ind.ort <- grep("<wohnort>[^<]+</wohnort>", rohdaten)

ind.name
ind.alter
ind.ort

# 3.) Die Tags werden entfernt. Etwaige Leerzeichen um die Tags
# herum loeschen wir ebenso.
name <- gsub(" *<name> *| *</name> *", "", rohdaten[ind.name])
alter <- gsub(" *<alter> *| *</alter> *", "", rohdaten[ind.alter])
ort <- gsub(" *<wohnort> *| *</wohnort> *", "", rohdaten[ind.ort])

# 4.) data.frame erstellen
daten <- data.frame(name = name, alter = alter, wohnort = ort,
  stringsAsFactors = FALSE)
daten

# 5.) Modes bzw. Klassen festlegen:
#     .) name: character (passt bereits)
#     .) alter: numeric
#     .) wohnort: factor
str(daten)

daten$wohnort <- as.factor(daten$wohnort)
daten$alter <- as.numeric(daten$alter)

daten
str(daten)

# Beachte, dass der Wert "NA" beim Alter (da keine Zahl) tatsaechlich in
# NA umgewandelt wird.

# Hinweis: Haetten wir stringsAsFactors = TRUE gesetzt, dann muessen wir
# bei der Umwandlung des Alters aufpassen! In dem Fall muessen wir vor
# der Umwandlung mittels as.numeric() noch mit as.character() arbeiten.


### b)

# Wir verwenden write.table(), alternativ kann man auch write.csv() oder
# write.csv2() verwenden. Zweitere Funktion verwendet als Trennzeichen ein
# Semikolon ";".
# quote = FALSE unterdrueckt die Anfuehrungszeichen bei Strings.
# Achtung: Wenn wir Leerzeich als Trennzeichen verwenden, so funktioniert
# es mit quote = FALSE nicht, wenn es Eintraege mit Leerzeichen gibt!
# Daher ist ";" ein gutes und bewaehrtes Trennzeichen.
write.table(daten, file = "Personen.csv", row.names = FALSE, 
  sep = ";", quote = FALSE, fileEncoding = "UTF-8")


### c)

# Wir lesen die Daten mit read.table() ein.
# Wenn wir na.string setzen, so werden die entsprechenden Strings direkt
# in NA uebersetzt. Beim Alter wird dadurch automatisch erkannt, dass es
# sich um eine numerische Variable handelt.
daten.csv <- read.table(file = "Personen.csv", header = TRUE, sep = ";",
  na.string = "NA", fileEncoding = "UTF-8", stringsAsFactors = FALSE)
daten.csv
str(daten.csv)

# Wohnort in einen Faktor umwandeln
daten.csv$wohnort <- as.factor(daten.csv$wohnort)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


### a)

# Wir lesen die Daten via read.table() ein.
# Arbeitsverzeichnis wechseln in jenen Ordner, in dem sich die Datei
# Vertreter2.txt befindet. Wir gehen den Einleseprozess schrittweise durch.
# Wenn wir uns die Datei anschauen, stellen wir fest, dass die ersten 9
# Zeilen uebersprungen werden sollten (skip = 9), und dass die Datei
# 24 Datenzeilen enthaelt (nrows = 24). Die erste relevante Zeile enthaelt
# die Ueberschriften (header = TRUE), das Trennzeichen ist ein Tabulator
# (sep = "\t") und NAs sind mit "NA", "na" oder einem Leerstring ""
# markiert (na.sring = c("NA", "na", ""). Schliesslich ist die Datei in
# UTF-8 codiert (fileEncoding = "UTF-8").
# setwd("...")
daten <- read.table("Vertreter2.txt", header = TRUE, skip = 9,
  nrows = 24, sep = "\t", na.string = c("NA", "na", ""),
  fileEncoding = "UTF-8", stringsAsFactors = TRUE)

# Daten betrachten
daten
str(daten)

# Wir gehen Variable fuer Variable durch.
# 1.) Nummer: Wird als Integer verwaltet (ganzzahlige numerische Werte):
#     Passt!
# 2.) Gebiet: Ist ein Faktor, passt! Die Levels sind alphabetisch sortiert.
#     Wir wollen aber "West", "Nord", "Süd", "Ost", "Zentrum" haben.
#     Eine neuerliche Faktorbildung reiht die Kategorien um.
daten$Gebiet

# Richtige Reihenfolge finden
order <- c(4, 1, 2, 3, 5)
daten$Gebiet <- factor(daten$Gebiet, levels(daten$Gebiet[order]))

# Daten betrachten
daten
str(daten)

# 3.) Ausbildung: Ist ein Faktor, aber hier haben sich Leerzeichen
#     eingeschlichen. Mit strip.white = TRUE in read.table() koennen wir
#     das beheben. Wir ersetzen aber alternativ Leerzeichen zu Beginn und
#     am Ende durch "" und erstellen einen neuen Faktor.
daten$Ausbildung

daten$Ausbildung <- as.character(daten$Ausbildung)
daten$Ausbildung <- sub("^ +", "", daten$Ausbildung)
daten$Ausbildung <- sub(" +$", "", daten$Ausbildung)
daten$Ausbildung <- factor(daten$Ausbildung)

# Daten betrachten
daten$Ausbildung
daten
str(daten)

# 4.) Gewinn: Hier wird kein einheitliches Dezimalzeichen verwendet.
#     Wir ersetzen alle "," durch "." und wandeln den Vektor in einen
#     numerischen Vektor um.
daten$Gewinn

daten$Gewinn <- gsub(",", ".", daten$Gewinn)
daten$Gewinn <- as.numeric(as.character(daten$Gewinn))
daten$Gewinn

# Daten betrachten
daten
str(daten)

# 5.) Datum: Ist ein Faktor. Wir wandeln ihn in einen Date-Vektor um
daten$Datum <- as.Date(daten$Datum, format = "%d.%m.%Y")

# Daten betrachten
daten
str(daten)


### b)

# 1.) Anzahl der Tage bis Jahresende berechnen
jahresende <- as.Date("2018-12-31")
tage <- jahresende - daten$Datum
tage

# 2.) Effizienz berechnen
#     Der Gewinn ist in 1000 Euro gegeben. Um also einen Gewinn in Euro
#     zu erhalten, multiplizieren wir den Gewinn mit 1000.
effizienz <- daten$Gewinn * 1000 / as.numeric(tage)
effizienz

# 3.) Variable anhaengen
daten$Effizienz <- effizienz
daten


### c)

# 1.) Effizienz absteigend sortieren. Die NAs koennen wir zum Beispiel
#     hinten anhaengen (wird standardmaessig auch so gehandhabt bei order().
order <- order(daten$Effizienz, decreasing = TRUE)
order

daten <- daten[order, ]
daten

# 2.) Als Textdatei abspeichern (zum Beispiel mit Tabulator als Trennzeichen)
write.table(daten, file = "Vertreter_Effizienz.txt", row.names = FALSE,
  sep = ";", quote = FALSE)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


### Vorbereitung: Daten einlesen mit foreign und read.spss()
library(foreign)
# Hilfe zu read.spss()
# ?read.spss

# Arbeitsverzeichnis wechseln in jenen Order, in dem sich die Datei
# Daten_EW.sav befindet.
# setwd(...)
daten.ew <- read.spss("Daten_EW.sav", to.data.frame = TRUE)

head(daten.ew)
str(daten.ew)


### a)

# Die Reihung der Kategorien wird von SPSS uebernommen. Sieht gut aus!
daten.ew$genfood
levels(daten.ew$genfood)


### b)

daten.ew$ttip

# Schritt 1: Keine Meinung als Kategorie anhaengen
levels(daten.ew$ttip) <- c(levels(daten.ew$ttip), "Keine Meinung")
levels(daten.ew$ttip)

# Schritt 2: NAs durch "Keine Meinung" ersetzen
daten.ew$ttip[is.na(daten.ew$ttip)] <- "Keine Meinung"
daten.ew$ttip


### c)

# Hinweis: Offene Antwortmoeglichkeiten sind in der Praxis extrem muehsam
# aufzubereiten! Wir muessen per Hand etwaige Tippfehler beheben, Ein- und
# Mehrzahlen zusammenfassen, seltene Antworten sinnvoll zusammenfassen etc.
# Eine automatisierte Loesung ist dabei kaum moeglich.
# Betrachten wir mal, was die Personen geantwortet haben.
obst <- daten.ew$obst
table(obst)

# In der Praxis kann die Aufbereitung extrem muehsam sein. Dieses Beispiel
# ist noch recht harmlos, insbesondere, da es nicht so viele Datenzeilen
# gibt. In unserem Beispiel sollten wir uns folgende Dinge ueberlegen:
# 1.) Was machen wir mit der Antwort "Beere"?
# 2.) Was machen wir mit der Antwort "Melone"? Es wurde auch Honigmelone und
#     Wassermelone genannt.
# 3.) Wie fassen wir Einzahlen / Mehrzahlen zusammen.
# 4.) Wie gehen wir mit speziellen Antworten um?
# 5.) Was machen wir mit exotischeren Sorten, die sehr selten genannt wurden?
#     Wie etwa Avocado, Papaya etc. Was machen wir allgemein mit Sorten,
#     die sehr selten genannt wurden?

# Es gibt dabei keine pauschal richtige Antwort. Wichtig ist, dass wir die
# Aufbereitung sinnvoll begruenden koennen. Gehen wir es an!

# obst ist sinnvollerweise ein character-Vektor.
# Zunaechst alle unnoetigen Leerzeichen entfernen
obst <- gsub("^ +| +$", "", obst)
obst

table(obst)

# Ad 1.) "Beere" sollten wir nicht einfach einer speziellen Beere (etwa
#        Erdbeere zuordnen. Wir sehen, dass Brombeere und Heidelbeere sehr
#        selten genannt wurden, wir koennten also diese Kategorien
#        zusammenfassen ("Sonstige Beeren" etwa)
obst[obst %in% c("Beere", "Heidelbeere", "Brombeere")] <- "Sonstige Beeren"
table(obst)

# Ad 2.) Da Melonen nicht allzu oft genannt wurden, boete es sich an, alle
#        Melonensorten zu "Melone" zusammenzufassen
obst[obst %in% c("Honigmelone", "Wassermelone")] <- "Melone"
table(obst)

# Ad 3.) Apfel / Äpfel, Erdbeere / Erdbeeren, Himbeere / Himbeeren,
#        Kirsche / Kirschen zusammenfassen
#        Bei folgendem Code wird auch "Apfel Kronprinz Rudolf" zu Apfel
#        umbenannt, was durchaus Sinn macht. Beim Suchmuster ".pfel"
#        umgehen wir das potenzielle Umlauteproblem.
obst[grepl(".pfel", obst)] <- "Apfel"
obst[grepl("Erdbeere", obst)] <- "Erdbeere"
obst[grepl("Himbeere", obst)] <- "Himbeere"
obst[grepl("Kirsche", obst)] <- "Kirsche"
table(obst)

# Ad 4.) Hochgereifte Marillen => Marille, Keine Präferenz => NA,
         Salsa => NA (Welches Salsa? Zu unkonkret)
#        Manderine ist ein Tippfehler => Mandarine
obst[grepl("Marille", obst)] <- "Marille"
obst[grepl("Keine Pr.{1,2}ferenz", obst)] <- NA
obst[obst == "Salsa"] <- NA
obst[grepl("Mand[ae]rine", obst)] <- "Mandarine"
table(obst)

# Ad 5.) Man kann argumentieren, dass Orangen und Mandarinen aehnlich sind.
#        Ebenso bei Nektarinen und Pfirsichen.
obst[obst %in% c("Orange", "Mandarine")] <- "Orange/Manderine"
obst[obst %in% c("Pfirsich", "Nektarine")] <- "Pfirsich/Nektarine"
table(obst)

# Sieht schon uebersichtlicher aus! Jetzt koennen wir zum Beispiel noch
# einen Schwellwert n.min festlegen; alle Kategorien, die hoechstens n.min
# Mal genannt wurden, werden zu "Sonstige" zusammengefasst.
n.min <- 2
tab <- table(obst)
tab

# Selektiere alle selten genannten Obstsorten
selten <- names(tab)[tab <= n.min]
selten

# Seltene Obstsorten zusammenfassen
obst[obst %in% selten] <- "Sonstige"
table(obst)

# Jetzt erstellen wir einen Faktor, wobei "Sonstige Beeren" und "Sonstige"
# hinten gereiht werden.
obstsorten <- sort(unique(obst))
obstsorten

daten.ew$obst <- factor(obst,
  levels = c(obstsorten[!obstsorten %in% c("Sonstige Beeren", "Sonstige")],
  "Sonstige Beeren", "Sonstige"))

# Kontrolle
daten.ew$obst
levels(daten.ew$obst)


### d)

write.table(daten.ew, file = "Daten_EW.csv", row.names = FALSE, sep = ";",
  quote = FALSE, fileEncoding = "UTF-8")

