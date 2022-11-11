### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 19
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


Pkt <- matrix(c(43, 45, 17, NA, 13, 32, NA, NA, 49, 15),
  ncol = 2, byrow = TRUE)
rownames(Pkt) <- paste0("Stud", 1:nrow(Pkt))
colnames(Pkt) <- paste0("T", 1:ncol(Pkt))
Pkt

n <- nrow(Pkt)
k <- ncol(Pkt)


### a)

# Wende apply() spaltenweise (MARGIN = 2) an. na.rm = TRUE wird als
# weiteres Argument an max() uebergeben.
apply(Pkt, 2, max, na.rm = TRUE)


### b)

# Hier brauchen wir apply() gar nicht ;-)
Pkt[order(rowSums(Pkt, na.rm = TRUE)), ]


### c)

# i)

# 1. Code: list, da NAs standardmaessig entfernt werden.
apply(Pkt, 1, sort, decreasing = TRUE)

# 2. Code: matrix, da NAs hinten angehaengt werden. Beachte, dass die
# Ergebnisvektoren spaltenweise angehaengt werden und dass die Test-
# beschriftungen wegfallen (was auch Sinn macht).
apply(Pkt, 1, sort, decreasing = TRUE, na.last = TRUE)

# ii)

# In den Spalten, da Ergebnisvektoren immer spaltenweise angeordnet werden.


### d)

# Schritt 1: Wir sortieren fuer jeden Studierenden die erzielten Punkte
# aufsteigend. NAs haengen wir vorne an. Damit die Studierenden weiterhin
# in den Zeilen stehen, transponieren wir die Matrix.
Pkt.sort <- t(apply(Pkt, 1, sort, na.last = FALSE))
Pkt.sort

# Schritt 2: Wir entfernen die erste Spalte, die das Streichresultat
# enthaelt. drop = FALSE bewahrt die Matrixstruktur.
Pkt.neu <- Pkt.sort[, -1, drop = FALSE]
Pkt.neu

# Schritt 3: Zeilensummen bestimmen und auf Bestehen abfragen
rowSums(Pkt.neu, na.rm = TRUE)
rowSums(Pkt.neu, na.rm = TRUE) >= (k - 1) * 50 / 2

# Schritt 4: Anzahl bestimmen
sum(rowSums(Pkt.neu, na.rm = TRUE) >= (k - 1) * 50 / 2)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Die Daten dieses Kapitels
# Ggf. Arbeitsverzeichnis wechseln oder Pfad angeben
objekte <- load("Minigolf_Matrizen.RData")
objekte

# Die Schlagzahlen der 3 Spieler
Schlaege


### a)

# Spaltenmediane bestimmen ...
Schlaege.median <- apply(Schlaege, 2, median)
Schlaege.median

# ... und von jeder Spalte abziehen
sweep(Schlaege, 2, STATS = Schlaege.median, FUN = "-")


# Hinweis: Mit eigenen Funktionen (lernen wir spaeter) ginge es auch so:
apply(Schlaege, 2, function(x) x - median(x))


### b)

# Ergebnisse von Spieler1 und jene des besten Gegners bestimmen
spieler1 <- Schlaege[, 1]
spielerX <- apply(Schlaege[, -1, drop = FALSE], 1, min)

spieler1
spielerX

# Auf welchen Bahnen war Spieler 1 weniger Schlaege benoetigt?
which(spieler1 < spielerX)

