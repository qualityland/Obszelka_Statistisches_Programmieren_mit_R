### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 2
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


### a)

# Variablen erstellen
kg <- 65
m <- 1.76


### b)

# BMI berechnen
bmi <- kg / m^2
bmi


### c)

# Abspeichern des Skripts zum Beispiel unter
# bmi.R



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# n definieren
n <- 8:10

# Vorgriff auf Kapitel 3: Mit 8:10 erstellen wir eine Sequenz von 8 bis 10
# und koennen alle Zahlen gleichzeitig auswerten.
# Alternativ n <- 8 schreiben und Code ausfuehren, analog fuer 9 und 10.

# Hilfskonstrukte für die Formel
b1 <- (1 + sqrt(5)) / 2
b2 <- (1 - sqrt(5)) / 2

res <- 1 / sqrt(5) * (b1 ^ n - b2 ^ n)
res

