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


# 3.2.1 Subsetting

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









# Uebungen
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

