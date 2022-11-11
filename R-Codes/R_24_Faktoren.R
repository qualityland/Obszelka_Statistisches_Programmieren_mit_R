### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 24: Kategorielle Variablen: Faktoren
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 24.0  Die Daten des Kapitels einlesen -- read.table()
### -------------------------------------------------------------------------


# Einlesen der Datei "Vertreter.txt"
# Arbeitsverzeichnis in jenen Ordner wechseln, in dem Vertreter.txt ist.
# setwd(...)
daten <- read.table(file = "Vertreter.txt", header = TRUE, dec = ",")

# Überblick über die Daten
str(daten)          # Struktur des Dataframes

# Bereinige Beschriftung der 1. Variable
names(daten)[1] <- substring(names(daten)[1], 4)

# Die ersten Zeilen betrachten
head(daten)

# Die letzten Zeilen betrachten
tail(daten)



### -------------------------------------------------------------------------
### 24.1  Faktoren: Sinn, Generierung und Verwaltung
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 24.1.2  Faktoren generieren -- factor()


# Faktoren bilden und auf die Variablen zuweisen
daten$Ausbildung <- factor(daten$Ausbildung, labels = c("Matura", "Lehre"))
daten$Gebiet <- factor(daten$Gebiet,
  labels = c("West", "Nord", "Ost", "Süd"))

head(daten, n = 8)

sort(unique(daten$Gebiet))
sort(unique(daten$Ausbildung))


### -------------------------------------------------------------------------
### 24.1.3  Interne Verwaltung -- unclass(), mode(), is.factor()


daten$Gebiet

# Offenlegung der internen Verwaltung
unclass(daten$Gebiet)

mode(daten$Gebiet)        # numerischer Mode...
is.numeric(daten$Gebiet)  # aber nicht numerisch,

# Abfrage auf Faktor
is.factor(daten$Gebiet)


### -------------------------------------------------------------------------
### 24.1.4  Zugriff auf die Ausprägungen -- levels(), nlevels()


# Die Ausprägungen abfragen
levels(daten$Gebiet)

# Anzahl der Ausprägungen abfragen
nlevels(daten$Gebiet)


### -------------------------------------------------------------------------
### 24.1.5  Faktoren und Strings -- as.character()


# Umwandlung in einen Stringvektor - Möglichkeit 1
as.character(daten$Gebiet)

unclass(daten$Gebiet)

# Umwandlung in einen Stringvektor - Möglichkeit 2
levels(daten$Gebiet)[daten$Gebiet]

# Zeichenkette generieren und auf x zuweisen
gebiet.string <- levels(daten$Gebiet)[daten$Gebiet]
gebiet.string

factor(gebiet.string)


### -------------------------------------------------------------------------
### 24.1.6  Codierungsreihenfolge bestimmen mit levels


daten$Gebiet
factor(gebiet.string)

sort(unique(gebiet.string))

# Faktor erzeugen und Codierungsreihenfolge steuern
factor(gebiet.string, levels = c("West", "Nord", "Ost", "Süd"))

# Decke nicht alle levels ab => NAs entstehen
factor(gebiet.string, levels = "Nord")



### -------------------------------------------------------------------------
### 24.2  Kategorisierung von numerischen Variablen
### -------------------------------------------------------------------------


daten$Gewinn


### -------------------------------------------------------------------------
### 24.2.1  Bedingungen aufsummieren


# Welche Einträge der Variable Gewinn erfüllen die Bedingungen?
gr5 <- daten$Gewinn > 5
gr10 <- daten$Gewinn > 10
gr15 <- daten$Gewinn > 15

# Je mehr Bedingungen erfüllt werden, desto höher die Kategorie
gewinn.indikator <- 1 + gr5 + gr10 + gr15

# Zur Kontrolle:
head(cbind(Gewinn = daten$Gewinn, Kategorie = gewinn.indikator), n = 6)

# gewinn.indikator in Faktor verwandeln und Ausprägungen benennen
stufen <- c("wenig", "moderat", "viel", "Goldgrube")
daten$Gewinnstufe <- factor(gewinn.indikator, labels = stufen)

head(daten, n = 6)


### -------------------------------------------------------------------------
### 24.2.2  Kategorisierung mit cut()


punkte <- c(-Inf, 5, 10, 15, Inf)
gewinn.cut <- cut(daten$Gewinn, breaks = punkte)
gewinn.cut

# Gewinn kategorisieren und Variable Gewinnstufe erstellen
gewinn.cut <- cut(daten$Gewinn, breaks = punkte, labels = stufen)
daten$Gewinnstufe <- gewinn.cut
head(daten, n = 6)

# Der erstellte Faktor Gewinnstufe
daten$Gewinnstufe



### -------------------------------------------------------------------------
### 24.3  Ausprägungen manipulieren
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 24.3.1  Verschmelzen von Faktorausprägungen


# Der Ist-Zustand der Gewinnstufe
levels(daten$Gewinnstufe)   # Die derzeitigen Kategorien
nlevels(daten$Gewinnstufe)  # Zähle Anzahl der Levels

# Kopiere die Variable Gewinnstufe
gewinn.cut1 <- daten$Gewinnstufe
gewinn.cut1

# Ersetzung vornehmen
gewinn.cut1[gewinn.cut1 == "Goldgrube"] <- "viel"
gewinn.cut1

factor(gewinn.cut1)

# Füge Goldgrube mit viel zusammen
levels(daten$Gewinnstufe)[levels(daten$Gewinnstufe) == "Goldgrube"] <-
  "viel"
daten$Gewinnstufe

# Das modifizierte Dataframe
head(daten, n = 6)


### -------------------------------------------------------------------------
### 24.3.2  Umbenennung von Ausprägungen


levels(daten$Gewinnstufe)[levels(daten$Gewinnstufe) == "moderat"] <-
  "mittel"
daten$Gewinnstufe


### -------------------------------------------------------------------------
### 24.3.3  Neue Ausprägungen hinzufügen


daten$Gebiet


# Weise den Beobachtungen die neue Kategorie Zentrum zu.
daten$Gebiet[c(1, 2, 5, 6)] <- "Zentrum"

daten$Gebiet


# Wir machen Gebiet mit dem "Zentrum" vertraut
levels(daten$Gebiet) <- c(levels(daten$Gebiet), "Zentrum")

# Alternative: Neuerliche Faktorbildung
# daten$Gebiet <- factor(daten$Gebiet,
#  levels = c(levels(daten$Gebiet), "Zentrum"))

levels(daten$Gebiet)

daten$Gebiet[c(1, 2, 5, 6)] <- "Zentrum"
daten$Gebiet



### -------------------------------------------------------------------------
### 24.4  Ordinalskalierung -- factor(ordered), as.ordered(), is.ordered()
### -------------------------------------------------------------------------


# Ausgangssituation
daten$Gewinnstufe

# Ordinalskalierten Faktor erstellen
daten$Gewinnstufe <- factor(daten$Gewinnstufe, ordered = TRUE)
daten$Gewinnstufe

# Varianten, die auch vor diesem Abschnitt funktionieren
sum(daten$Gewinnstufe == "mittel" | daten$Gewinnstufe == "viel")
sum(daten$Gewinnstufe %in% c("mittel", "viel"))

# Variante, die erst dann funktioniert ...
daten$Gewinnstufe >= "mittel"

# ... wenn der Faktor als ordered markiert ist.
sum(daten$Gewinnstufe >= "mittel")

# Abfrage auf Ordinalskalierung
is.ordered(daten$Gewinnstufe)



### -------------------------------------------------------------------------
### 24.5  Tücken im Zusammenhang mit Faktoren
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 24.5.1  Umordnen von Faktorausprägungen


noten <- c("Sehr gut", "Gut", "Befriedigend", "Genügend", "Nicht genügend")
noten

noten.faktor <- factor(noten)
noten.faktor
as.numeric(noten.faktor)   # Keine korrekte Zuordnung


# Umwandlung in Faktor - verwende eigene Codierungsreihenfolge
noten.faktor1 <- factor(noten.faktor, levels = c("Sehr gut", "Gut",
  "Befriedigend", "Genügend", "Nicht genügend"), ordered = TRUE)
noten.faktor1
as.numeric(noten.faktor1)  # Korrekte Zuordnung


### -------------------------------------------------------------------------
### 24.5.2  Das as.numeric-Problem


# Der zugrundeliegende Faktor
mahl <- factor(c(3, 3, 2, 3, 5, 5, 2))
mahl

falsch <- as.numeric(mahl)
falsch


# 1.) Faktor in einen String umwandeln
levels(mahl)[mahl]

# 2.) String in einen numerischen Vektor umwandeln
mahl.numeric <- as.numeric(levels(mahl)[mahl])
mahl.numeric

# 2.) Alternative: etwas ineffizienter aber möglicherweise intuitiver
as.numeric(as.character(mahl))


### -------------------------------------------------------------------------
### 24.5.3  Lückenlose Häufigkeitstabellen revisited -- table()


# table() mit numerischem Vektor
mahl.numeric

table(mahl.numeric)


# table() mit Faktor
mahl
table(mahl)
mahl.numeric

# Faktor mit selbstbestimmten Kategorien von 0 bis zum Maximum
mahl.faktor <- factor(mahl.numeric, levels = 0:max(mahl.numeric))
mahl.faktor

table(mahl.faktor)



### -------------------------------------------------------------------------
### 24.6  Fehlende Werte als Kategorie -- factor(exclude), is.na()
### -------------------------------------------------------------------------


# Die Antworten auf die Ja/Nein-Frage
antwort <- c("Ja", "Nein", "Ja", "Ja", NA)
antwort

antwort.fak1 <- factor(antwort)  # entspricht factor(antwort, exclude = NA)
antwort.fak1

is.na(antwort.fak1)

# NAs als eigene Kategorie definieren
antwort.fak2 <- factor(antwort, exclude = NULL)

antwort.fak2

is.na(antwort.fak2)

# Betrachte die Levels
levels(antwort.fak2)
is.na(levels(antwort.fak2))

# Zahlencode von NA herausfinden
which(is.na(levels(antwort.fak2)))

as.numeric(antwort.fak2) == which(is.na(levels(antwort.fak2)))

# Beschrifte NA mit "Keine Angabe"
levels(antwort.fak2)[is.na(levels(antwort.fak2))] <- "Keine Angabe"
antwort.fak2

antwort.fak2 == "Keine Angabe"



### -------------------------------------------------------------------------
### 24.7  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 24.7.1  Objekte sichern


# Daten sichern
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
save(daten, file = "Vertreter.RData")


### -------------------------------------------------------------------------
### 24.7.4  Übungen


x <- c("A", "B", "C")
faktor <- factor(x, levels = c("B", "C", "A"), labels = c(4, 2, 6))
			
faktor1 <- factor(faktor, ordered = TRUE)
faktor1


noten <- c(4, 5, NA, 3, 1, 3, NA, 3)

noten.faktor <- factor(noten, ordered = TRUE)
noten.faktor
