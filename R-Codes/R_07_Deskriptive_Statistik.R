### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 07: Deskriptive Statistik
### -------------------------------------------------------------------------


# Ggf. Arbeitsverzeichnis wechseln
# setwd(...)
objekte <- load("Apfel.RData")
objekte

apfel.teil



### -------------------------------------------------------------------------
### 7.2  Minimum und Maximum -- min(), max(), range()
### -------------------------------------------------------------------------


apfel.teil


# Minimum
min(apfel.teil)

# Maximum
max(apfel.teil)

# Minimum und Maximum
range(apfel.teil)


# Sortiere die Stichprobe aufsteigend
sort(apfel.teil)

# Vektor kopieren und dem unplausiblen Wert einen fehlenden Wert zuweisen
apfel <- apfel.teil
apfel[apfel == min(apfel.teil)] <- NA

apfel.teil
apfel


range(apfel)
range(apfel, na.rm = TRUE)  # Fehlende Werte entfernen

# Spannweite des Vektors apfel
apfel.range <- range(apfel, na.rm = TRUE)
apfel.range[2] - apfel.range[1]



### -------------------------------------------------------------------------
### 7.3  Mittelwert, Varianz und Standardabweichung -- mean(), var(), sd()
### -------------------------------------------------------------------------


# Mittelwert und Varianz
mean(apfel, na.rm = TRUE)
var(apfel, na.rm = TRUE)

# Standardabweichung
sd(apfel, na.rm = TRUE)
sqrt(var(apfel, na.rm = TRUE))


apfel
# Überdurchschnittlich schwere Äpfel selektieren
apfel[apfel > mean(apfel, na.rm = TRUE)]



### -------------------------------------------------------------------------
### 7.4  Median und Quantile -- median(), quantile()
### -------------------------------------------------------------------------


sort(apfel)
median(apfel, na.rm = TRUE)


# Bestimme die defaultmässig eingestellten Quantile
quantile(apfel, na.rm = TRUE)
# Bestimme das 2.5%- und 97.5%-Quantil
quantile(apfel, probs = c(0.025, 0.975), na.rm = TRUE)


temp <- quantile(apfel, probs = c(0.25, 0.75), na.rm = TRUE)
temp

# Interquartilsdistanz IQR berechnen

# Variante 1: Subseting mit Indizes
temp[2] - temp[1]
# Variante 2: Subsetting mit names
temp["75%"] - temp["25%"]



### -------------------------------------------------------------------------
### 7.5  Summarys -- summary()
### -------------------------------------------------------------------------


summary(apfel)



### -------------------------------------------------------------------------
### 7.6  Aus der guten Statistikpraxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 7.6.1  Robustheit und Ausreisser


apfel.teil


# Masszahlen OHNE Ausreisser
min(apfel, na.rm = TRUE)
mean(apfel, na.rm = TRUE)
sd(apfel, na.rm = TRUE)
median(apfel, na.rm = TRUE)

# Masszahlen MIT Ausreisser
min(apfel.teil)
mean(apfel.teil)
sd(apfel.teil)
median(apfel.teil)


### -------------------------------------------------------------------------
### 7.6.2  Standardisierung


# Anzahl der Apfel bestimmen, die um mehr als zwei Standardabweichungen vom
# Mittelwert entfernt sind.

apfel.teil

# Mittelwert und Standardabweichung berechnen und speichern
xquer <- mean(apfel.teil)
s <- sd(apfel.teil)

# Variante 1: Intervall xquer +/- 2 * Standardabweichung
c(xquer - 2 * s, xquer + 2 * s)

# Anzahl der Extremwerte bestimmen
sum(apfel.teil < xquer - 2 * s | apfel.teil > xquer + 2 * s)


# Variante 2: Vektor standardisieren
apfel.teil.scale <- (apfel.teil - xquer) / s
apfel.teil.scale

# Anzahl der Extremwerte bestimmen
sum(abs(apfel.teil.scale) > 2)
mean(apfel.teil.scale)
sd(apfel.teil.scale)



### -------------------------------------------------------------------------
### 7.7  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 7.7.3  Übungen


groesse <- c(176, 181, 181, 183, 163, 157, 164, 166, 176, 184)
gewicht <- c(65, 92, 65, 93, 49, 47, 55, 50, 62, 84)

			
groesse <- c(164, 1.83, 176, 480, 0, 167, 1.62)
