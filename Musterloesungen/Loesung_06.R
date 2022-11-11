### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 6
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


tipp <- c(4, 7, 15, 19, 20, 38)
lotto <- c(3, 19, 24, 23, 7, 34, 16)

tipp
lotto


### a)

# Ungeachtet der Tatsache, dass tipp nicht gleich lange ist wie lotto wird
# mit "==" elementweise verglichen, also ob 4 == 3, 7 == 19 etc. ist. Das
# liefert aber nicht das, was wir wollen.
tipp == lotto


### b)

# Mit dem %in%-Operator kommen wir ans Ziel.
tipp %in% lotto



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


tipp
lotto

lotto[lotto %in% tipp]


# Erster Code:
# Hier werden die Zahlen in jener Reihenfolge selektiert, wie sie in tipp
# vorkommen.
tipp[tipp %in% lotto]

# Zweiter Code:
# Hier werden die Mengen vermischt. Wir fragen ab, ob die Zahlen aus tipp
# in lotto vorkommen, selektieren aber dann vom falschen Vektor lotto.
lotto[tipp %in% lotto]



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


A <- c(2, 3, 4, 5, 7)
B <- c(1, 2, 6, 7)

A
B


### a)

# Differenz A \ B
A[!A %in% B]

# Alternative
setdiff(A, B)


### b)

# Symmetrische Differenz
c(A[!A %in% B], B[!B %in% A])

# Bzw. sortiert
sort(c(A[!A %in% B], B[!B %in% A]))



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


name <- c("Manuela Zinsberger", "Carina Wenninger", "Viktoria Schnaderbeck",
  "Katharina Schiechtl", "Laura Feiersinger", "Sarah Zadrazil")
jahr <- c(1995, 1991, 1991, 1993, 1993, 1993)
monat <- c(10, 2, 1, 2, 4, 2)
tag <- c(19, 6, 4, 27, 5, 19)


### a)

# Vor dem 20.02.1993 geboren worden zu sein bedeutet:
# .) vor dem Jahr 1993 oder
# .) im Jahr 1993 vor dem Februar oder
# .) im Jahr 1993 im Februar vor dem 20.
# Wir uebersetzen diese Bedingung in R-Code.

name[jahr < 1993 | (jahr == 1993 & monat < 2) |
  (jahr == 1993 & monat == 2 & tag < 20)]


### b)

# Eine Moeglichkeit von vielen: Wir bauen aus monat und tag einen Vektor
# zusammen, zum Beispiel so:

temp <- monat * 100 + tag
name[order(temp, decreasing = FALSE)]



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


a <- c(2, 1, 4, 3)  # Seitenlaenge a
b <- c(4, 5, 2, 3)  # Seitenlaenge b
area <- a * b       # Flaeche

a
b
area


### a)

sort(area, decreasing = TRUE)


### b)

# i.  Es wird 5 gedruckt, weil sort(a) in dem Fall c(1, 2, 3, 4) ergibt
#     und damit der 2. Eintrag von area selektiert wird.
area[sort(a)][2]

# ii. order() statt sort() ist die Loesung. Ausserdem muessen wir
#     absteigend sortieren.
area[order(a, decreasing = TRUE)][2]


### c)

# i. ist voelliger Unsinn
a[order(area[order(b)])]

# ii. passt: zunaechst nach area, im Zweifel auch nach b sortieren
a[order(area, b)]

# iii. ist ebenfalls Unsinn
a[order(b[order(area)])]

# iv. liefert nicht das gewuenschte Resultat, da zuerst nach b und dann
# nach area sortiert wird.
a[order(b, area)]



### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


x <- c(2, 4, 1, 3)


### a)

x1 <- x
x1[rank(x)] <- x
x1

# Inhaltlich geschieht folgendes: Wir platzieren jeden Wert von x an genau
# jene Stelle von x1, der dem Rang des entsprechenden Eintrages entspricht.
# Also die kleinste Beobachtung an die Stelle 1, die 2. kleinste an die
# Stelle 2 usw. Konsequenz: ein aufsteigend sortierter Vektor.

# Alternativcode
x1 <- sort(x)
x1


### b)

x <- c(2, 4, 1, 2, 3)

x1 <- x
x1[rank(x)] <- x
x1

# Der Code funktioniert nicht, weil Ties auftreten:
rank(x)

# Damit es funktioniert, müssen wir die ties.method umstellen.
x1 <- x
x1[rank(x, ties.method = "first")] <- x
x1



### -----------------------------------------------------------------------
### Beispiel 7
### -----------------------------------------------------------------------


n <- 30
p <- 0.2


### a)

# Formel auswerten
k <- 0:n
choose(n, k) * p ^ k * (1 - p) ^ (n - k)


### b)

# Mit der Funktion dbinom()
dbinom(k, size = n, prob = p)

