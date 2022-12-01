library(readr)


# 3.1.1 Kartenstapel mit Vektor verwalten

stapel <- c(4, 7, 6, 2, 3, 5)
stapel


# 3.1.2 Anzahl der Karten zaehlen
length(stapel)


# 3.1.3 Sequenzen mit Schrittweite 1

# Integers
1:6

# Floats
0.25:6

# absteigend
3:-3


# 3.2.1 Subsetting mit Indices

# einzelnes Element
stapel[3]

# mehrere Elemente
stapel[c(3, 5)]

# Sequenz mehrerer Elemente
stapel[3:5]

# Verschachtelter Zugriff
# erstes Element des Subsets 3:5
stapel[3:5][1]

# Zugriff auf nicht existierende Elemente liefert NA
stapel[c(2, 9, 3)]

# Elemente ausschliessen
stapel
# alle ausser Positionen 3 bis 5
stapel[-(3:5)]

# 3.2.2 Subsetting mit Wahrheitswerten
# vom der Sequenz mit Laenge stapel werden nur die Elemente mit TRUE ausgegeben
(1:length(stapel))[stapel == 7]



# 3.6 Ersetzen und Tauschen von Werten

# erstes und letztes Element vertauschen
stapel.neu <- stapel[c(length(stapel), 2:(length(stapel) - 1), 1)]
stapel.neu

# variante
stapel.neu[c(1, length(stapel.neu))] <- stapel.neu[c(length(stapel.neu), 1)]
stapel.neu


# Stapel verlaengern
stapel <- c(stapel, 9, 8)
stapel

# Stapel zuruecksetzen
stapel <- stapel[-c(length(stapel) - 1, length(stapel))]
stapel



# 3.8.3 Uebungen

# Beispiel 2
x <- (1:6) * c(-1, 1)
x

x[x <= 0] <- -x[x <= 0]
x

x <- x * c(TRUE, FALSE)
x

x <- x[x != 0 & x < 5]
x

x <- x[c(0:3, length(x), 2, 1)]
x


# Beispiel 3
# a)
# Beispielvektor
x <- 1:5
x

# Ansatz Nr. 1
x[1:(length(x) - 2)]

# Ansatz Nr. 2
x[-(length(x):(length(x) - 1))]


# b)

vl <- 10
ex <- 3
# Beispielvektor
x <- 1:vl
x

# Ansatz Nr. 1
x[1:(length(x) - ex)]

# Ansatz Nr. 2
x[-(length(x):(length(x) - (ex - 1)))]


# Beispiel 4
alter <- c(16, 18, 19, 24, 28, 32, 32, 45)

# a) Wie viele Einträge hat der Vektor alter?
length(alter)

# b) Wie viel Prozent der Personen sind zwischen 18 und 27 Jahre alt?
mean(alter >= 18 & alter <= 27)

# c) Wie viele Personen sind jünger als 20 oder älter als 30?
sum(alter < 20 | alter > 30)


# Beispiel 5

# Der Kartenstapel
stapel <- c(4, 7, 6, 2, 3, 5)

# Karten verteilen
hand1 <- stapel[c(TRUE, FALSE)]
hand2 <- stapel[c(FALSE, TRUE)]

hand1
hand2

# 1. Karte austauschen
tmp <- hand1[1]
hand1[1] <- hand2[1]
hand2[1] <- tmp

hand1
hand2



# weitere Uebungen
df <- read_csv("Datensaetze/Massen.csv")

# bool Vektor
df$Gewicht >= 90

# which - Indices der Messungen
which(df$Gewicht >= 90)

# sum - Anzahl der Messungen
sum(df$Gewicht >= 90)

# mean - Anteil der Messungen
mean(df$Gewicht >= 90)

# Filtern
weight[which(weight$Gewicht >= 90), ]

