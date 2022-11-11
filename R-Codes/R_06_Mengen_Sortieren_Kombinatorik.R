### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 06: Mengen, Sortieren und Kombinatorik
### -------------------------------------------------------------------------


# Lotto-Ziehungsergebnis und Tipp verwalten
lotto <- c(3, 19, 24, 23, 7, 34, 16)
tipp <- c(4, 7, 15, 19, 20, 38)



### -------------------------------------------------------------------------
### 6.1  Mengenfunktionen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 6.1.1  Matchings bestimmen -- "%in%"


lotto
tipp

tipp == lotto

# Wie viele der getippten Zahlen sind auch in lotto enthalten?
bool.richtig <- tipp[1] == lotto | tipp[2] == lotto | tipp[3] == lotto |
                tipp[4] == lotto | tipp[5] == lotto | tipp[6] == lotto
bool.richtig

sum(bool.richtig)


# Matchings bestimmen
tipp %in% lotto
sum(tipp %in% lotto)

# Vertausche tipp und lotto
lotto %in% tipp
sum(lotto %in% tipp)


# Selektion: Möglichkeit 1
tipp[tipp %in% lotto]

# Selektion: Möglichkeit 2
lotto[lotto %in% tipp]


### -------------------------------------------------------------------------
### 6.1.2  Mehrfacheinträge streichen -- unique()


x <- c(2, 1, 2, 3, 2, 1)
x

# Bilde Vektor mit den unterscheidbaren Elementen von x
unique(x)


### -------------------------------------------------------------------------
### 6.1.3  Schnittmenge und Vereinigung mit dem %in%-Operator


# Mengen als Vektor definieren
A <- c(2, 3, 4, 5, 7)
B <- c(1, 2, 6, 7)
A
B

# Vereinigung von A und B
c(A, B)
unique(c(A, B))    # Wollen nur unterscheidbare Elemente

# Schnittmenge von A und B
A[A %in% B]

# Schnittmenge von B und A
B[B %in% A]


### -------------------------------------------------------------------------
### 6.1.4  Schnittmenge und Vereinigung -- intersect(), union()


A
B

# Vereinigung von A und B
union(A, B)

# Schnittmenge von A und B
intersect(A, B)



### -------------------------------------------------------------------------
### 6.2  Sortieren
### -------------------------------------------------------------------------


# Beispielvektor
x <- c(5, 7, 5, 3, 4)


### -------------------------------------------------------------------------
### 6.2.1  Sortierung der Einträge -- sort()


# Zu sortierender Vektor
x

# Aufsteigend sortieren
sort(x)

# Absteigend sortieren
sort(x, decreasing = TRUE)


lotto

# Sortiere die Lottozahlen
sort(lotto)

# Sortiere die Lottozahlen. Die Zusatzzahl bleibt an letzter Stelle.
c(sort(lotto[-length(lotto)]), lotto[length(lotto)])


### -------------------------------------------------------------------------
### 6.2.2  Generierung der sortierenden Entnahmereihenfolge -- order()


# Indexreihenfolge bestimmen (aufsteigend)
x
order(x)

# Indexreihenfolge bestimmen (absteigend)
x
order(x, decreasing = TRUE)


### -------------------------------------------------------------------------
### 6.2.3  Ränge bestimmen -- rank()


x

# Bestimme die Ränge
rank(x)

x

# Ties nach der Reihenfolge des Auftretens auflösen
rank(x, ties.method = "first")


### -------------------------------------------------------------------------
### 6.2.4  Vektoren umdrehen -- rev()


1:5
rev(1:5)


### -------------------------------------------------------------------------
### 6.2.5  Mehrfachsortierung -- order()


# Die Daten der Fussballspielerinnen eingeben. 
name <- c("Manuela Zinsberger", "Carina Wenninger", "Viktoria Schnaderbeck",
          "Katharina Schiechtl", "Laura Feiersinger", "Sarah Zadrazil")
jahr <- c(1995, 1991, 1991, 1993, 1993, 1993)
monat <- c(10, 2, 1, 2, 4, 2)
tag <- c(19, 6, 4, 27, 5, 19) 


# Sortiere name nach jahr aufsteigend
name[order(jahr)]

# Sortiere name nach jahr absteigend
name[order(jahr, decreasing = TRUE)]

# Sortiere name nach dem Geburtsdatum absteigend
reihenfolge <- order(jahr, monat, tag, decreasing = TRUE)
name[reihenfolge]


### -------------------------------------------------------------------------
### 6.2.6  Mehrfachsortierung und Ränge -- rank()


geburtszahl <- jahr * 10000 + monat * 100 + tag
geburtszahl

# Bestimme den Altersrang
rank(-geburtszahl)



### -------------------------------------------------------------------------
### 6.3  Kombinatorik -- factorial(), choose(), prod()
### -------------------------------------------------------------------------


# 3! und 4!
factorial(c(3, 4))

# 3 über 2 und 4 über 2
choose(c(3, 4), 2)

# Produkt von c(1, 2, 3, 4) = 1 * 2 * 3 * 4
prod(c(1, 2, 3, 4))



### -------------------------------------------------------------------------
### 6.4  Wissenschaftliche Notation -- options(scipen)
### -------------------------------------------------------------------------


# Wahrscheinlichkeit eines Lottosechsers mit einem Tipp in Lotto 6 aus 45.
1 / choose(45, 6)


# Anzahl der Möglichkeiten, 52 Karten auf 2 Spieler zu verteilen
choose(52, 26)


# Optionen setzen: Wissenschaftliche Notation unterdrücken
opt <- options(scipen = 10000)
choose(52, 26)

# Zurücksetzen der Optionen
options(opt)
choose(52, 26)



### -------------------------------------------------------------------------
### 6.5  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 6.5.1  Fallbeispiel: Unterscheidbare Lottoziehungsergebnisse


# Die Lotteriedaten
nzahlen <- c(45, 49)  # Anzahl der Zahlen der Lotterien
nziehung <- c(6, 6)   # Anzahl der gezogenen Zahlen ohne Zusatzzahl

# Bestimme die Anzahl der unterscheidbaren Lottoziehungen
choose(nzahlen, nziehung) * (nzahlen - nziehung)

# Bestimme die Anzahl der möglichen Lottosechser
choose(nzahlen, nziehung)


### -------------------------------------------------------------------------
### 6.5.2  Fallbeispiel: Unterscheidbare Playlists einer Musik-CD


# Bestimme die Anzahl der möglichen Playlists
5 * 3 * 3 * 4 * 1 * 2 * factorial(6)


# Die Anzahl der Lieder pro Tanz
nlieder <- c(5, 3, 3, 4, 1, 2)

# Bestimme die Anzahl der möglichen Playlists
nplaylists <- prod(nlieder) * factorial(length(nlieder))
nplaylists



### -------------------------------------------------------------------------
### 6.6  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 6.6.3  Übungen


tipp
lotto

tipp == lotto


# Selektiere alle Zahlen aus lotto, die auch in tipp vorkommen.
lotto[lotto %in% tipp]

tipp[tipp %in% lotto]    # Zahlen vertauscht

lotto[tipp %in% lotto]   # Falsche Zahlen


a <- c(2, 1, 4, 3)   # Seitenlänge a
b <- c(4, 5, 2, 3)   # Seitenlänge b
area <- a * b        # Fläche

a
b
area


x <- c(2, 4, 1, 3)

x1 <- x
x1[rank(x)] <- x
