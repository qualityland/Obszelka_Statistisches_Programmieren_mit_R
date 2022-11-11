### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 13: Computerarithmetik und Rundungsfehler
### -------------------------------------------------------------------------


# Ggf. Arbeitsverzeichnis wechseln in jenen Ordner,
# in dem sich Apfel.RData befindet.
# setwd(...)
load("Apfel.RData")

# Vektor standardisieren
apfel.teil.scale <- (apfel.teil - mean(apfel.teil)) / sd(apfel.teil)


mean(apfel.teil.scale)
mean(apfel.teil.scale) == 0

sd(apfel.teil.scale)
sd(apfel.teil.scale) == 1



### -------------------------------------------------------------------------
### 13.1  Dezimalzahlen und Rundungsfehler -- options(digits)
### -------------------------------------------------------------------------


2.05 - 0.05
2.05 - 0.05 == 2

# Anzahl der angezeigten Nachkommastellen umstellen.
opt <- options(digits = 20) 
2.05 - 0.05   # Jetzt sehen wir den Rundungsfehler.

options(opt)  # Optionen wieder zurücksetzen 

2^-5
2^-5 + 2^-6
2^-5 + 2^-6 + 2^-9
2^-5 + 2^-6 + 2^-9 + 2^-10 + 2^-13 + 2^-14 + 2^-17 + 2^-18 + 2^-21



### -------------------------------------------------------------------------
### 13.2  Prüfung auf annähernde Gleichheit
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 13.2.1  Absolute Abweichung messen


istwert <- 2.05 - 0.05
sollwert <- 2

# Prüfung auf exakte Gleichheit
istwert == sollwert             # Rundungsfehler, daher FALSE

# Prüfung auf annähernde Gleichheit
eps <- 10^-8                    # Kleine Fehlerschranke
abs(istwert - sollwert) < eps   # Lassen kleine Abweichung zu: TRUE


### -------------------------------------------------------------------------
### 13.2.2  Funktionsbasierte Prüfung -- all.equal()


all.equal(2, 2.05 - 0.05)

# Vorgabe einer Toleranzschranke
eps <- 10^-8
all.equal(2, 2.05 - 0.05, tolerance = eps)


# Apfeldaten laden
# ggf. Arbeitsverzeichnis wechseln mit setwd(...)
load("Apfel.RData")
apfel.teil

# Standardisierten Vektor berechnen
apfel.teil.scale <- (apfel.teil - mean(apfel.teil)) / sd(apfel.teil)
apfel.teil.scale

# Baue die zu vergleichenden Objekte zusammen
ist <- c(mean(apfel.teil.scale), sd(apfel.teil.scale))
soll <- c(0, 1)
all.equal(target = soll, current = ist)

names(ist) <- c("mean", "sd")   # ist beschriften
ist

all.equal(soll, ist)
names(soll) <- c("Mean", "Sd")  # soll anders beschriften als ist
soll

all.equal(soll, ist)
all.equal(soll, ist, check.attributes = FALSE)
