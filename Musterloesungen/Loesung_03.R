### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 3
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


stapel <- c(4, 7, 6, 2, 3, 5)
stapel


### a)

# Ja. Wir bestimmen den Wahrheitsvektor stapel >= 4 und zaehlen mit sum()
# die Anzahl der TRUE-Werte.
sum(stapel >= 4)


### b)

# Nein. stapel >= 4 hat dieselbe Laenge wie stapel; es wird daher die
# Anzahl der Karten insgesamt bestimmt.
length(stapel >= 4)


### c)

# Nein. Hier wird die Summe aller Kartenwerte bestimmt, die einen Wert von
# mindestens 4 haben.
sum(stapel[stapel >= 4])


### d)

# Ja. Wir selektieren zunächst alle Karten mit einem Wert von mindestens 4.
# Dann bestimmen wir die Laenge des resultierenden Vektors.
length(stapel[stapel >= 4])


### e)

# Ja. stapel >= 4 liefert denselben Wahrheitsvektor wie ! (stapel < 4).
# Damit ist der Code aequivalent zu a).
sum(! (stapel < 4))


### f)

# Nein. Selber Grund wie in b).
length(! (stapel < 4))


### g)

# Nein. Wir bestimmen, an welchen Stellen jene Karte stehen, die einen Wert
# von mindestens 4 haben. Dann werden aber diese Indizes aufsummiert, was
# diese Frage nicht beantwortet. Die Laenge dieses Indexvektors muesste
# gemessen werden.
sum(which(stapel >= 4))


### h)

# Ja. Erklaerung: siehe g).
length(which(stapel >= 4))



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Recycling: c(-1, 1) wird auf Laenge 6 (= Laenge von 1:6) aufgeblasen.
# Damit wird 1 mit -1, 2 mit 1, 3 mit -1 etc. multipliziert.
x <- (1:6) * c(-1, 1)
x

# Alle Eintraege von x, die kleiner oder gleich 0 sind, werden durch ihre
# entsprechenden negierten Eintraege ersetzt. Unterm Strich wird bei allen
# negativen Zahlen das Minus geloescht.
x[x <= 0] <- -x[x <= 0]
x

# Hier erfolgt eine Typumwandlung: TRUE wird in 1 und FALSE wird in 0
# umkonvertiert. Also effektiv wird x * c(1, 0) gerechnet. Dann greift
# wieder das Recycling analog zum ersten Code dieses Beispiels.
x <- x * c(TRUE, FALSE)
x

# Aus x werden all jene Werte selektiert, die ungleich 0 und kleiner 5 sind.
x <- x[x != 0 & x < 5]
x

# Wir selektieren aus x die Elemente mit folgenden Indizes:
# 0, 1, 2, 3, 2 (Anzahl der Elemente von x), 2, 1
# Das Element 0 wird ignoriert; da x kein 3. Element hat, wird an dieser
# Stelle ein NA (Not Available) erzeugt.
x <- x[c(0:3, length(x), 2, 1)]
x



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


### a)

# Allgemeine Erklaerung: Der Sequenzoperator hat eine hoehere Prioritaet
# als die Subtraktion. Daher wird in beiden Faellen zuerst die Sequenz
# gebildet und erst dann subtrahiert, umgekehrt soll es aber sein.

# Beispielvektor
x <- 1:5
x

# Ansatz Nr. 1
x[1:length(x) - 2]

# Korrektur von Ansatz Nr. 1
x[1:(length(x) - 2)]

# Ansatz Nr. 2
x[-length(x):length(x) - 1]

# Korrektur von Ansatz Nr. 2
x[-(length(x):(length(x) - 1))]


### b)

k <- 2

# Ansatz Nr. 1: Verallgemeinerung
x[1:(length(x) - k)]

# Ansatz Nr. 2: Verallgemeinerung
x[-(length(x):(length(x) - k + 1))]



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


alter <- c(16, 18, 19, 24, 28, 32, 32, 45)
alter


### a)

length(alter)


### b)

mean(alter >= 18 & alter <= 27) * 100


### c)

sum(alter < 20 | alter > 30)



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


# Der Kartenstapel
stapel <- c(4, 7, 6, 2, 3, 5)

# Karten verteilen
hand1 <- stapel[c(TRUE, FALSE)]
hand2 <- stapel[c(FALSE, TRUE)]

hand1
hand2


# Tausche die erste Karte aus (falscher Ansatz)
hand1[1] <- hand2[1]
hand2[1] <- hand1[1]

hand1
hand2

# Das Problem: hand1[1] wird ueberschrieben und in der zweiten Zuweisung
# ist der alte Eintrag daher nicht mehr vorhanden. Eine Moeglichkeit:
# einen Zwischenpuffer nuetzen.

# Karten erneut verteilen
hand1 <- stapel[c(TRUE, FALSE)]
hand2 <- stapel[c(FALSE, TRUE)]

hand1
hand2

# Tausche die erste Karte aus (funktionierender Ansatz)
temp <- hand1[1]
hand1[1] <- hand2[1]
hand2[1] <- temp

hand1
hand2

