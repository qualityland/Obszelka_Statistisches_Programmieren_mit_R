### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 4
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


rep(1:2, each = 4)
rep(rep(1:2, each = 2), times = 2)
rep(1:2, times = 4)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Erste Folge
(1:8) + c(1, -1)


# Zweite Folge
(1:16)[c(rep(TRUE, 3), FALSE)]
(1:16)[-seq(4, 16, by = 4)]



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


# Hilfe zu seq()
# ?seq


# Nur length.out: from = 1, by = 1, to = length.out
seq(length.out = 5)
seq(length.out = 10)

# Nur to: from = 1, by = +/- 1 (abhaengig von to)
seq(to = 10)
seq(to = -5)

# length.out und to: by = 1, from = to - length.out + 1
seq(length.out = 10, to = 5)
seq(length.out = 10, to = 3)
seq(length.out = 5, to = -3)



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


### Allgemeines

# In der R-Hilfe zu sample() (?sample) erfahren, dass wir Stichproben
# ziehen koennen und erfahren viel ueber die Parameter:
# x ......... Die Grundmenge, aus der gezogen wird
# size ...... Groesse der Stichprobe
# replace ... TRUE: mit Zuruecklegen, FALSE: ohne Zuruecklegen
#             FALSE ist der Standardwert
# prob ...... Wahrscheinlichkeitsgewichte fuer die Elemente von x


### a)

sample(x = 1:6)


### b)

# Hier muessen wir 6 Zahlen ohne Zuruecklegen aus 1:45 ziehen
tipp <- sample(x = 1:45, size = 6)
tipp

# Optional können wir auch sortieren:
sort(tipp)


### c)

# Hier ziehen wir mit Zuruecklegen
sample(x = 1:6, size = 30, replace = TRUE)


### d)

# Mit Zuruecklegen und die Wahrscheinlichkeitsgewichte muessen gesetzt
# werden (da standardmaessig eine Gleichverteilung angenommen wird)
sample(x = 0:2, size = 20, replace = TRUE, prob = c(1/4, 1/2, 1/4))

# Die Verteilung modelliert die Wahrscheinlichkeit, bei einem Werfen
# zweier Muenzen k Mal Kopf zu werfen.



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


x <- c(1:4, NA)
x


### a)

# R kennt sich nicht aus :-)
x[NA]


### b)

# Werden beim Subsetting mit Indizes NAs hineingemischt, antwortet R an
# den entsprechenden Stellen mit NA.
x[c(1, NA)]


### c)

# NA < 3 liefert NA
x < 3


### d)

# Aehnliche Situation wie in b)
x[x < 3]


### e)

# Da das NA nach der Selektion bestehen bleibt, liefert sum() NA.
sum(x[x < 3])


### f)

# Zumindest so lange, wie na.rm nicht auf TRUE gesetzt wird.
sum(x < 3, na.rm = TRUE)


### g)

# Aehnliches Verhalten wie in f)
sum(x[x < 3], na.rm = TRUE)


### h)

# Liefert vermeintlich die Anzahl der Elemente, die kleiner 3 sind, aber
# NA wird mitgezaehlt. Somit sind sum(x < 3) und length(x[x < 3]) nicht
# aequivalent.
length(x[x < 3])



### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


# Beispielvektor
x <- c(0, 2, 3)
x


### a)

# Passt, all() gibt TRUE zurueck, wenn *alle* Wahrheitswerte TRUE sind.
all(x > 0)


### b)

# Passt, any() gibt TRUE zurueck, wenn mindestens ein Wahrheitswert TRUE
# ist. Und gibt es ein Element <= 0, so koennen nicht alle Elemente > 0
# sein.
any(x <= 0)


### c)

# Passt, prod() bildet das Produkt aller Zahlen. Wahrheitswerte werden in
# 0 (FALSE) oder 1 (TRUE) umcodiert. Nur wenn alle Zahlen groesser als 0
# sind, so wird prod(x > 0) zu 1 ausgewertet.
prod(x > 0) == 1


### d)

# Passt, denn nur wenn alle Elemente > 0 sind, wird x <= 0 zu einem Vektor
# bestehend aus lauter FALSE ausgewertet.
sum(x <= 0) == 0



### -----------------------------------------------------------------------
### Beispiel 7
### -----------------------------------------------------------------------


stapel <- c(4, 7, 6, 2, 3, 5)
stapel


# Flexiblere Variante mit seq()
stapel[seq(from = 1, to = length(stapel), by = 2)]



### -----------------------------------------------------------------------
### Beispiel 8
### -----------------------------------------------------------------------


### a)

# Verwende Recycling
x <- 2^(1:31)
x


### b)

# Mit which() erfragen wir alle Indizes jener Zahlen, die groesser als
# 10000 sind. Davon brauchen wir den ersten Eintrag.
which(x > 10000)[1]


### c)

sum(x %% 3 == 0) > 0
any(x %% 3 == 0)


### d)

log2(x)
all(log2(x) == 1:31)

# Allgemein koennen ggf. Rundungsfehler auftreten. Das ist zwar hier nicht
# der Fall, dennoch praesentieren wir als Vorgriff auf spaeter schon jetzt
# eine sicherere Abfrage.
all(abs(log2(x) - 1:31) < 10^-6)


### -----------------------------------------------------------------------
### Beispiel 9
### -----------------------------------------------------------------------

x <- 1:100

# Mehrere Moeglichkeiten
x[x %% 7 == 0]
seq(7, 100, by = 7)
x[c(rep(FALSE, 6), TRUE)]



### -----------------------------------------------------------------------
### Beispiel 10
### -----------------------------------------------------------------------


x <- c(-3, 0, 0.5, 2)
(x > 0) - (x < 0)


### a)

# Wenn eine Zahl positiv ist, kommt +1 heraus (wegen (x > 0) == TRUE und
# (x < 0) == FALSE). Wenn eine Zahl negativ ist, kommt aus aehnlichen
# Gruenden -1 heraus. Falls eine Zahl gleich Null ist, so sind beide
# Ausdruecke FALSE, wodurch Null herauskommt.


### b)

sign(x)



### -----------------------------------------------------------------------
### Beispiel 11
### -----------------------------------------------------------------------


x <- c(6.49, 6.5, 6.51)
x


# Eine Variante: Wir berechnen das Ergebnis der ganzzahligen Division sowie
# den Rest der ganzzahligen Division durch 1. Ist der Rest groesser oder
# gleich 0.5, so zaehle zum Ergebnis der ganzzahligen Division eine 1 dazu.

ganz <- x %/% 1
rest <- x %% 1

ganz + (rest >= 0.5)


# Alternativ koennen wir statt x %/% 1 auch floor(x) schreiben.


### -----------------------------------------------------------------------
### Beispiel 12
### -----------------------------------------------------------------------


x <- c(3, 4, 9, 2)
x

# Bedingung zusammenbauen
bool <- (x %% 2) != 0 & x > -5 & x < 5
x[bool]

# Anzahl bestimmen
sum(bool)



### -----------------------------------------------------------------------
### Beispiel 13
### -----------------------------------------------------------------------


# Im ersten Code wird die Summe aus 2, TRUE und 3:4 gebildet. TRUE wird
# in 1 konvertiert, sodass 10 herauskommt. Beachte, dass wir rm.na und
# nicht na.rm geschrieben haben!
sum(2, rm.na = TRUE, 3:4)

# Im zweiten Code wird die Summe aus 2, TRUE, NA, 3:4 gebildet, wobei
# wegen na.rm = TRUE der fehlende Wert exkludiert wird. Somit kommt 10
# heraus.
sum(2, TRUE, NA, na.rm = TRUE, 3:4)

