library(readr)

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

