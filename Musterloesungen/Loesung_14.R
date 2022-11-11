### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 14
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


geschlecht <- c("w", "w", "m", "m", "w", "w", "m", "m")
groesse <- c(163, 171, 192, 183, 0, 172, 208, 182)
gewicht <- c(NA, 60, Inf, 88, 0, -3, 878, 78)


### a)

bmi <- gewicht / (groesse / 100)^2
bmi


### b)

# Ein BMI-Wert ist laut Annahme plausibel, wenn er merklich groesser als
# 0 ist (zum Beispiel > 5) und merklich kleiner als Unendlich (< 70 etwa).
# Diese Schranken sind sehr grosszuegig gewaehlt, erfuellen aber den
# Zweck. Zusaetzlich muessen wir auf NAs und NaNs achten.
# Wir erstellen einen logischen Vektor mit TRUE, wenn ein Eintrag nicht
# plausibel ist und negieren ihn anschliessend.
bool <- is.na(bmi) | bmi <= 5 | bmi >= 70
bool

sum(!bool)

# Beachte, dass mit is.na() auch NaNs mitgeprueft werden.


### c)

# Wir erweitern den Wahrheitsvektor noch mit der zusaetzlichen Bedingung,
# dass die Person maennlich ist.
sum(!bool & geschlecht == "m")


### d)

# Unplausible Werte von Gewicht sind Werte <= 0 oder etwa >= 500 (wiederum
# sehr grosszuegig gewaehlt).
gewicht
gewicht[gewicht <= 0 | gewicht >= 500] <- NA
gewicht

# Wir fuehren die Berechnungen erneut aus

# a)
bmi <- gewicht / (groesse / 100)^2
bmi

# b)
bool <- is.na(bmi) | bmi <= 5 | bmi >= 70
bool

sum(!bool)

# c)
sum(!bool & geschlecht == "m")


### e)
bmi[!bool & geschlecht == "m"]



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Probieren Werte fuer k von 1 bis 10000 aus.
n <- 8000000
k <- 1:10000

# Berechne die Anzahl der Stichproben und ab wann Inf erreicht wird
res <- choose(n, k)
which(res == Inf)[1]

# Schon ab k = 56

