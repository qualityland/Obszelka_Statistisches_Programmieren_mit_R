### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 15: Matrizen
### -------------------------------------------------------------------------


# Schlagzahlen des 1. Spielers
schlaege1

# Schlagzahlen des 2. Spielers
schlaege2

# Daten laden
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
objekte <- load("Minigolf_Matrizen.RData")
objekte



### -------------------------------------------------------------------------
### 15.1  Matrizen generieren und manipulieren
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 15.1.1  Vektoren zu Matrizen anordnen -- matrix()


# Möglichkeit 1: Elemente spaltenweise einfügen
X <- matrix(data = c(3, 2, 1, 0, -1, 5), nrow = 2, ncol = 3)
X

# Möglichkeit 2: Elemente zeilenweise einfügen
X <- matrix(data = c(3, 1, -1, 2, 0, 5), nrow = 2, ncol = 3, byrow = TRUE)
X


### -------------------------------------------------------------------------
### 15.1.2  Vektoren aneinanderhängen -- rbind(), cbind()


x <- 1:4
x
y <- 5:8
y
z <- 9:12
z

# Entlang der Spalte (column)
cbind(x, y, z)

# Entlang der Zeile (row)
rbind(x, y, z)


# kein vollständiges Recycling möglich
rbind(1:4, 1:3)

# Erzeuge eine Matrix mit den Schlagzahlen
Schlaege <- cbind(schlaege1, schlaege2)
Schlaege


schlaege3 <- c(1, 2, 3, 7, 4, 1)

# Füge einen dritten Spieler hinzu
Schlaege <- cbind(Schlaege, schlaege3)
Schlaege


A <- matrix(1:6, nrow = 3)
A
B <- matrix(1:6, ncol = 3)
B

# Klappt nicht, da die Anzahl der Zeilen nicht übereinstimmt.
cbind(A, B)


### -------------------------------------------------------------------------
### 15.1.3  Dimension von Matrizen -- nrow(), ncol(), dim(), length()


Schlaege

nrow(Schlaege)    # Anzahl der Zeilen
ncol(Schlaege)    # Anzahl der Spalten
dim(Schlaege)     # 1. Eintrag: Anzahl Zeilen, 2. Eintrag: Anzahl Spalten
length(Schlaege)  # Anzahl der Elemente in der Matrix


### -------------------------------------------------------------------------
### 15.1.4  Beschriftungen bei Matrizen -- colnames(), rownames()


# Der Ist-Zustand
Schlaege

# Spalten- und Zeilennamen erstellen
paste0("Spieler", 1:ncol(Schlaege))
paste0("Bahn", 1:nrow(Schlaege))

# Spalten- und Zeilennamen zuweisen
colnames(Schlaege) <- paste0("Spieler", 1:ncol(Schlaege))
rownames(Schlaege) <- paste0("Bahn", 1:nrow(Schlaege))

Schlaege


### -------------------------------------------------------------------------
### 15.1.5  Matrizen transponieren -- t()


# Originale Matrix
X

# Transponierte Matrix
t(X)


### -------------------------------------------------------------------------
### 15.1.6  Matrix oder Vektor? -- is.matrix(), is.vector()


schlaege1

# schlaege1 ist ein Vektor.
is.vector(schlaege1)

# schlaege1 ist keine Matrix.
is.matrix(schlaege1)


Schlaege

# Schlaege ist kein Vektor.
is.vector(Schlaege)

# Schlaege ist eine Matrix.
is.matrix(Schlaege)


# Transponiere einen Vektor
t(schlaege1)

# Ein Zeilenvektor ist eine Matrix
is.matrix(t(schlaege1))



### -------------------------------------------------------------------------
### 15.2  Selektion: Subsetting -- "[ ]", "[ , , drop]"
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 15.2.1  Selektion von Zeilen und Spalten mit Indizes und Names


Schlaege

# Die ersten 3 Zeilen und ersten beiden Spalten selektieren
Schlaege[1:3, 1:2]

# Die ersten 3 Zeilen selektieren - lasse Spaltenindizes leer
Schlaege[1:3, ]

# Die ersten beiden Spalten selektieren - lasse Zeilenindizes leer
Schlaege[, 1:2]

# Die ersten 3 Zeilen und letzten beiden Spalten selektieren
Schlaege[1:3, (ncol(Schlaege) - 1):ncol(Schlaege)]


# Selektiere alle Spalten
# der ersten 3 Zeilen
temp <- Schlaege[1, ]
temp

is.vector(temp)
is.matrix(temp)


# Selektiere die ersten 3 Zeilen
# der Spalte "Spieler2"
temp <- Schlaege[1:3, "Spieler2"]
temp

is.vector(temp)
is.matrix(temp)


# Selektiere letzte Zeile - Bewahrung der Matrixstruktur mit drop = FALSE
Schlaege[nrow(Schlaege), , drop = FALSE]

# Selektiere die ersten beiden Zeilen der Spalte "Spieler2"
Schlaege[1:2, "Spieler2", drop = FALSE]


### -------------------------------------------------------------------------
### 15.2.2  Selektion von Zeilen und Spalten mit logischen Abfragen


# Hat Spieler 3 mehr Schläge als Spieler 2 gebraucht?
bool <- Schlaege[, "Spieler3"] > Schlaege[, "Spieler2"]
bool

Schlaege[bool, , drop = FALSE]  # Matrixstruktur bewahren zur Sicherheit

# 1.) Auf welchen Bahnen? (Name)
rownames(Schlaege)[bool]
# 1.) Auf welchen Bahnen? (Index)
which(bool)

# 2.) Auf wie vielen Bahnen?
sum(bool)


# Alle Zeilen, in denen Spieler 1 mehr als 7 Schläge benötigt hat
bool <- Schlaege[, "Spieler1"] > 7
bool

# Zeilen selektieren - drop = FALSE zur Sicherheit
temp <- Schlaege[bool, , drop = FALSE]
temp

dim(temp)

# Möglichkeit 1
nrow(temp)
# Möglichkeit 2
sum(bool)


### -------------------------------------------------------------------------
### 15.2.3  Elemente selektieren -- "[ ]"


Schlaege
Schlaege >= 5
Schlaege[Schlaege >= 5]


### -------------------------------------------------------------------------
### 15.2.4  Subsetting mit Matrizen


# Definiere Zeilen- und Spaltenindizes
zeilen <- c(2, 5, 1)
spalten <- c(1, 2, 3)

Schlaege[zeilen, spalten]


# Baue Indexmatrix zusammen
Indizes <- cbind(zeilen, spalten)
Indizes

# Selektion mittels n x 2 - Matrix
Schlaege[Indizes]

# Unhandliche Alternative
c(Schlaege[2, 1], Schlaege[5, 2], Schlaege[1, 3])



### -------------------------------------------------------------------------
### 15.3  Summen/Mittelwerte für Zeilen/Spalten -- rowSums(), colSums(),
###       rowMeans(), colMeans()
### -------------------------------------------------------------------------


Schlaege

# Wende Vektorfunktionen auf Matrizen an
mean(Schlaege)  # Bildet den Mittelwert über alle Elemente der Matrix
sum(Schlaege)   # Die Summe aller Elemente der Matrix


# Bestimme die Schlagsummen für jeden Spieler
schlagsummen <- colSums(Schlaege)
schlagsummen

# Bestimme die Platzierungsreihenfolge
names(schlagsummen)[order(schlagsummen)]

# Sortiere die Schlagsummen aufsteigend
sort(schlagsummen)
names(sort(schlagsummen))

# Bestimme die Platzierung für jeden Spieler
rank(schlagsummen, ties.method = "min")

# Alle Informationen vereinen
Res <- rbind(Platzierung = rank(schlagsummen, ties.method = "min"),
             Schlagsumme = schlagsummen)
Res

# Sortiere die Spalten aufsteigend nach schlagsumme
Res[, order(schlagsummen)]


Temp <- rbind(Schlaege, Summe = schlagsummen)
Temp

# Auf welchen Bahnen hat Spieler 3 weniger Schläge als Spieler 1 gebraucht?
which(Temp[, "Spieler3"] < Temp[, "Spieler1"])

# Jetzt ohne die Schlagsummen
which(Temp[-nrow(Temp), 3] < Temp[-nrow(Temp), 1])

# Schont die Nerven
which(Schlaege[, 3] < Schlaege[, 1])



### -------------------------------------------------------------------------
### 15.4  Rechnen mit Wahrheitswerten
### -------------------------------------------------------------------------


Schlaege
Schlaege > 2

# Wie oft mehr als zwei Schläge bei jeder Bahn?
rowSums(Schlaege > 2)



### -------------------------------------------------------------------------
### 15.5  Matrix vs. Vektor
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 15.5.1  Matrix in Vektor umwandeln -- as.vector()


X
t(X)

# Elemente von X
# spaltenweise entnehmen
as.vector(X)

# Elemente von X
# zeilenweise entnehmen
as.vector(t(X))


### -------------------------------------------------------------------------
### 15.5.2  Bedeutung von drop = FALSE beim Subsetting


# Selektion mit drop = FALSE
temp <- Schlaege[Schlaege[, 1] == 7, , drop = FALSE]

is.matrix(temp)  # ja, ist eine Matrix
dim(temp)        # ist daher definiert


# Selektion ohne drop = FALSE
temp1 <- Schlaege[Schlaege[, 1] == 7, ]
temp1

is.matrix(temp1)  # nein, keine Matrix
dim(temp1)        # dim ist für Vektoren nicht definiert, gibt NULL zurück
is.vector(temp1)  # ja, ist ein Vektor


# Gibt es eine Bahn, auf welcher der 1. Spieler 7 Schläge benötigt hat?
nrow(temp) > 0   # klappt wunderbar!
nrow(temp1) > 0  # leerer logischer Vektor, beantwortet Frage so nicht!



### -------------------------------------------------------------------------
### 15.6  Ersetzen von Werten
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 15.6.1  Ersetzungen in der ganzen Matrix


Schlaege

# Wie oft wurde 7 eingetragen?
sum(Schlaege == 7)


bool7 <- Schlaege == 7

# Zufallszahlen ziehen
RNGversion("4.0.2")  # Version des Zufallszahlengenerators setzen
set.seed(12345)      # Friert den Zufall ein
temp.schlaege <- sample(8:11, size = sum(bool7), replace = TRUE)
temp.schlaege

# Ersetze alle 7er durch Zufallszahlen zwischen 8 und 11
Schlaege[bool7] <- temp.schlaege
Schlaege

# paralleles Minimum
pmin(Schlaege, 7)

# wird nicht überschrieben
Schlaege


### -------------------------------------------------------------------------
### 15.6.2  Ersetzungen von fehlenden Werten -- NA, is.na()


# Werte grösser 7 durch NA ersetzen
Schlaege[Schlaege > 7] <- NA
Schlaege

is.na(Schlaege)


# Ersetze fehlende Werte durch 7
Schlaege[is.na(Schlaege)] <- 7

Schlaege


### -------------------------------------------------------------------------
### 15.6.3  Ersetzungen in Teilbereichen -- row(), col()


X

# Matrix mit Zeilenindizes
row(X)

# Matrix mit Spaltenindizes
col(X)


# Ersetze in den Spalten 2 und 3 alle positiven Werte durch -9
X[X > 0 & col(X) %in% c(2, 3)] <- -9
X



### -------------------------------------------------------------------------
### 15.7  Aus der guten Programmierpraxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 15.7.1  Programmierstil: Lesbarkeit und Spacing


### Leerzeichen zur Verbesserung der Lesbarkeit

# Empfohlenes Spacing

1 + 3 + 5 + 7

zahl <- 5

5 * (2 + 3)

# Nicht empfohlenes Spacing

1+3+5+7

zahl<-5

5*(2+3)


### Keine Leerzeichen beim Sequenzoperator

# Empfohlenes Spacing

1:5

# Nicht empfohlenes Spacing

1 : 5


### Eng anliegende Klammern bei Funktionsaufrufen
### Leerzeichen vor und nach =, Leerzeichen nach Beistrichen

# Empfohlenes Spacing

seq(from = 0, to = 10, by = 2)

# Nicht empfohlenes Spacing

seq(from=0,to=10,by=2)

seq( from = 0, to = 10, by = 2 )


### Leerzeichen nach Beistrichen beim Subsetting

# Empfohlenes Spacing

X[, 1]

X[1, ]

X[, 1, drop = FALSE]

X[1, , drop = FALSE]

# Nicht empfohlenes Spacing

X[,1]

X[1,]

X[,1,drop = FALSE]

X[1,,drop = FALSE]



### -------------------------------------------------------------------------
### 15.8  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 15.8.1  Objekte sichern


# Daten sichern
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
save(schlaege1, schlaege2, schlaege3, Schlaege,
     file = "Minigolf_Matrizen.RData")


### -------------------------------------------------------------------------
### 15.8.3  Ausblick


# Die Schlagzahlen der Spieler
Schlaege

# 1.) cumsum() kumuliert alle Schlagzahlen!
cumsum(Schlaege) 

# 2.) median() berechnet Median aller Schlagzahlen!
median(Schlaege)  

# 3.) sort() sortiert alle Einträge!
sort(Schlaege)


### -------------------------------------------------------------------------
### 15.8.4  Übungen


Pkt <- matrix(c(43, 45, 17, NA, 13, 32, NA, NA, 49, 15),
              ncol = 2, byrow = TRUE)
Pkt


S <- matrix(0, ncol = 8, nrow = 8)
S <- (col(S) + row(S) %% 2 == 0) + 1
S
