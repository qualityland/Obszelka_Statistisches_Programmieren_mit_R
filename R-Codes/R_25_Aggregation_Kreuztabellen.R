### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 25: Aggregation und Kreuztabellen
### -------------------------------------------------------------------------


# Daten laden
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
objekte <- load("Vertreter.RData")
objekte

# Die Variablen des Vertreterdatensatzes
names(daten)

# Die Vertreterdaten
daten



### -------------------------------------------------------------------------
### 25.1  Funktionen auf Gruppen anwenden: Teil 1 -- tapply()
### -------------------------------------------------------------------------


geschlecht <- factor(c("Mann", "Frau", "Frau", "Mann", "Frau", "Mann"))
groesse <- c(180, 165, 175, 170, NA, 190)

geschlecht
groesse


mean(groesse[geschlecht == "Mann"], na.rm = TRUE)
mean(groesse[geschlecht == "Frau"], na.rm = TRUE)

# Berechne mittlere Grösse getrennt nach Geschlecht
tapply(X = groesse, INDEX = geschlecht, FUN = mean, na.rm = TRUE)


# 1.) Durchschnittlicher Gewinn nach Gebiet und Ausbildung
tapply(daten$Gewinn, INDEX = daten$Gebiet, FUN = mean)
tapply(daten$Gewinn, INDEX = daten$Ausbildung, FUN = mean)

# 2.) Kleinster und grösster Gewinn pro Gebiet
tapply(daten$Gewinn, INDEX = daten$Gebiet, FUN = min)
tapply(daten$Gewinn, INDEX = daten$Gebiet, FUN = max)


gebiet.range <- tapply(daten$Gewinn, INDEX = daten$Gebiet, FUN = range)
gebiet.range

# Umwandlung in eine Matrix
sapply(gebiet.range, identity)


# Häufigkeitstabelle für Variable Gebiet erstellen
table(daten$Gebiet)

tapply(daten$Gebiet, daten$Gebiet, length)



### -------------------------------------------------------------------------
### 25.2  Kreuztabellen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 25.2.1  Einfache Kreuztabellen -- table()


# Kreuztabelle erstellen
tab <- table(daten$Gebiet, daten$Ausbildung)
tab


### -------------------------------------------------------------------------
### 25.2.2  Mehrdimensionale Kreuztabellen -- table(), apply(), ftable()


# Erstelle eine Kreuztabelle (ein Array) mit 3 Dimensionen
tab3 <- table(daten$Gewinnstufe, daten$Gebiet, daten$Ausbildung)
tab3

tab3["wenig", , ]
tab3["wenig", , , drop = FALSE]

# apply() über 2. und 3. Dimension
apply(tab3, MARGIN = 2:3, sum)

# apply() über 3. und 2. Dimension
apply(tab3, MARGIN = 3:2, sum)

# apply() über die 2. Dimension
apply(tab3, MARGIN = 2, sum)


### -------------------------------------------------------------------------
### 25.2.3  Randsummen bestimmen und anhängen -- margin.table(), addmargins()


tab

# Zeilenweise Randsumme
margin.table(tab, margin = 1)

# Spaltenweise Randsumme
margin.table(tab, margin = 2)

# Gesamtsumme
margin.table(tab)

# Zeilen- und Spaltensummen anhängen
addmargins(tab)


### -------------------------------------------------------------------------
### 25.2.4  Allgemeine Kreuztabellen -- tapply()


tabsum <- tapply(daten$Gewinn, list(daten$Gebiet, daten$Ausbildung), sum)
tabmargin <- addmargins(tabsum)
tabmargin


### -------------------------------------------------------------------------
### 25.2.5  Zeilen-, Spalten- und Totalprozent -- prop.table()


# Die Gewinnsummen getrennt nach Gebiet und Ausbildung
tabsum


# Totalprozente berechnen
tab.total <- 100 *
  prop.table(tabsum)
tab.total

# Randsummen anhängen
round(addmargins(tab.total),
  digits = 1)

# Alternativen für tab.total:
totalprozent <- 100 * tabmargin / sum(tabsum)
totalprozent <- 100 * tabmargin / margin.table(tabsum)


# Spaltenprozente berechnen
tab.spalte <- 100 * prop.table(tabsum, margin = 2)
round(addmargins(tab.spalte, margin = 1), digits = 1)

# Zeilenprozente berechnen
tab.spalte <- 100 * prop.table(tabsum, margin = 1)
round(addmargins(tab.spalte, margin = 2), digits = 1)



### -------------------------------------------------------------------------
### 25.3  Funktionen auf Gruppen anwenden: Teil 2 -- aggregate()
### -------------------------------------------------------------------------


bonus <- 1 + 0.1 * daten$Gewinn
daten$Bonus <- bonus
head(daten)


### -------------------------------------------------------------------------
### 25.3.1  Eine Gruppenvariable


tapply(daten$Gewinn, daten$Gebiet, mean)

tapply(daten$Bonus, daten$Gebiet, mean)


daten.aggr <- aggregate(x = daten[c("Gewinn", "Bonus")],
  by = daten["Gebiet"], mean)
daten.aggr


### -------------------------------------------------------------------------
### 25.3.2  Mehrere Gruppenvariablen


daten.aggr <- aggregate(x = daten[c("Gewinn", "Bonus")],
  by = daten[c("Gebiet", "Ausbildung")], mean)
daten.aggr

# Durchschnittswerte der Gebiete West, Nord und Ost für Ausbildung Matura
daten.aggr[daten.aggr$Gebiet %in% c("West", "Nord", "Ost") &
  daten.aggr$Ausbildung == "Matura", ]

aggregate(x = daten[c("Gewinn", "Bonus")],
  by = daten[c("Ausbildung", "Gewinnstufe")], mean)



### -------------------------------------------------------------------------
### 25.4  Verfügbarkeit von Variablen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 25.4.1  Lokale Verfügbarkeit -- with()


tapply(daten$Gewinn, daten$Ausbildung, mean)
with(daten, tapply(Gewinn, Ausbildung, mean))


### -------------------------------------------------------------------------
### 25.4.2  Globale Verfügbarkeit -- attach(), detach()


# Spalten von daten global verfügbar machen
attach(daten)

# Jetzt sind Gewinn und Ausbildung verfügbar.
Gewinn
tapply(Gewinn, Ausbildung, mean)

# attach() rückgängig machen und die Variablen von daten wieder einpacken
detach(daten)


# Definiere eine globale Variable Gewinn
Gewinn <- 50000
Gewinn

# Namenskollision beim Objekt Gewinn
attach(daten)

Gewinn
tapply(Gewinn, Ausbildung, mean)

detach(daten)



### -------------------------------------------------------------------------
### 25.5  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 25.5.3  Übungen


# Datensatz laden und Hilfe zum Datensatz abrufen
data(airquality)
# ?airquality

head(airquality)  # Überblick über den Datensatz
