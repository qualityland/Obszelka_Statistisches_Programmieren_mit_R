### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 12: Beschriftungen, Names und Häufigkeitstabellen
### -------------------------------------------------------------------------


# Die Anzahl der Geschwister
ngeschwister <- c(0, 1, 0, 1, 6, 5, 2, 0)



### -------------------------------------------------------------------------
### 12.1  Beschriftungen bei Vektoren
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 12.1.1  Zugriff auf Beschriftungen -- names()


# Quantile berechnen
ngeschwister.quant <- quantile(ngeschwister)
ngeschwister.quant

# Die Beschriftungen des Vektors erfragen
names(ngeschwister.quant)


### -------------------------------------------------------------------------
### 12.1.2  Subsetting mit Names


# Bestimme das 1. und das 3. Quartil

# Variante 1: Indizes abzählen
ngeschwister.quant[c(2, 4)]

# Variante 2: Sicherer!
ngeschwister.quant[c("25%", "75%")]


# Berechne andere Quantile
ngeschwister.quant <- quantile(ngeschwister, probs = c(0.25, 0.5, 0.75))
ngeschwister.quant

# Diverse Berechnungen
# ...

# Variante 1: Indizes abzählen
ngeschwister.quant[c(2, 4)]

# Variante 2: Funktioniert!
ngeschwister.quant[c("25%", "75%")]


# Berechne erneut andere Quantile
ngeschwister.quant <- quantile(ngeschwister, probs = seq(0, 1, by = 0.1))
ngeschwister.quant

# Variante 1: Indizes abzählen
ngeschwister.quant[c(2, 4)]

# Variante 2: Abgesichert!
ngeschwister.quant[c("25%", "75%")]


### -------------------------------------------------------------------------
### 12.1.3  Übergabe von Beschriftungen in c()


ngeschwister.range <- range(ngeschwister)
ngeschwister.range

c(Min = ngeschwister.range[1], Max = ngeschwister.range[2])

c(x = 1:3, y = 1:5)

# Vergebe nicht eindeutige Beschriftungen
x <- c(a = 2, a = 3)
x

# Selektion bei nicht eindeutiger Beschriftung
x[c("a", "a")]


### -------------------------------------------------------------------------
### 12.1.4  Beschriftungen hinzufügen, ersetzen und löschen -- names()<-,
###         NULL


ngeschwister.range

# Füge Beschriftungen hinzu
names(ngeschwister.range) <- c("Min", "Max")
ngeschwister.range

# Beschriftung des ersten Eintrags ändern
names(ngeschwister.range)[1] <- "Minimum"
ngeschwister.range


# Lösche Beschriftungen
names(ngeschwister.range) <- NULL
ngeschwister.range



### -------------------------------------------------------------------------
### 12.2  Häufigkeitstabellen und Tücken von Names
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 12.2.1  Häufigkeitstabellen erstellen -- table()


ngeschwister

# Häufigkeitstabelle erstellen
tab.geschwister <- table(ngeschwister)
tab.geschwister


### -------------------------------------------------------------------------
### 12.2.2  Gewichtete Mittelwerte berechnen aus Häufigkeitstabellen


# Gewichtetes Mittel berechnen - So geht es nicht!
sum(names(tab.geschwister) * tab.geschwister / sum(tab.geschwister))

names(tab.geschwister)
mode(names(tab.geschwister))


# Versuche den Mode der Names zu ändern
as.numeric(names(tab.geschwister))
mode(as.numeric(names(tab.geschwister)))

names(tab.geschwister) <- as.numeric(names(tab.geschwister))
mode(names(tab.geschwister))


# Gewichtetes Mittel berechnen - So funktioniert es!
sum(as.numeric(names(tab.geschwister)) * tab.geschwister) /
  sum(tab.geschwister)

# Kontrolle
mean(ngeschwister)


# Gewichtetes Mittel berechnen - Alternative
weighted.mean(as.numeric(names(tab.geschwister)), w = tab.geschwister)


### -------------------------------------------------------------------------
### 12.2.3  Häufigkeiten selektieren aus Häufigkeitstabellen


tab.geschwister

# Häufigkeit von einem Geschwisterchen selektieren - so nicht!
tab.geschwister[1]

# Häufigkeit von einem Geschwisterchen selektieren - besser!
tab.geschwister["1"]


# Selektiere Häufigkeiten mit Beschriftung 3 oder grösser
temp <- tab.geschwister[as.character(3:max(ngeschwister))]
temp

# Anzahl aus Häufigkeitstabelle
sum(temp, na.rm = TRUE)

# Kontrolle
sum(ngeschwister >= 3)


### -------------------------------------------------------------------------
### 12.2.4  Lückenlose Häufigkeitstabellen erstellen


tab.geschwister

# 1.) Initialisiere Nullvektor mit gewünschter Länge
tab.geschwister.voll <- rep(0, max(ngeschwister) + 1)
tab.geschwister.voll

# 2.) Füge die gewünschten Beschriftungen zu
names(tab.geschwister.voll) <- 0:max(ngeschwister)
tab.geschwister.voll

# Selektiere jenen Teilbereich von tab.geschwister.voll ...
names(tab.geschwister)
tab.geschwister.voll[names(tab.geschwister)]

# ... der mit den Werten von tab.geschwister befüllt werden soll.
tab.geschwister

# 3.) Werte ersetzen
tab.geschwister.voll[names(tab.geschwister)] <- tab.geschwister
tab.geschwister.voll



### -------------------------------------------------------------------------
### 12.3  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 12.3.3  Übungen


tab.geschwister


tab.geschwister[sort(names(tab.geschwister), decreasing = TRUE)]


alter <- c(Max = 31, Alex = 37, Christian = 26)
alter


noten <- c(3, 2, 4, 4, 2, 4, 5, 3)  # Die einzelnen Noten
tab.note <- table(noten)            # Häufigkeitstabelle der Noten
tab.note
