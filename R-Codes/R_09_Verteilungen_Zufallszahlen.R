### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 09: Verteilungen und Zufallszahlen
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 9.2  Normalverteilung -- dnorm(), pnorm(), qnorm(), rnorm()
### -------------------------------------------------------------------------


# Parameter festlegen
mu <- 7
sigma <- sqrt(4)  # Achtung: sigma statt sigma^2 nehmen!

# 1.) Dichten bestimmen - aus Symmetriegründen kommt dasselbe heraus.
dnorm(c(5, 9), mean = mu, sd = sigma)

# 2.) Verteilungsfunktion an der Stelle 5 auswerten
pnorm(5, mean = mu, sd = sigma)

# 3.) P(X > 5) = 1 - P(X <= 5)
1 - pnorm(5, mean = mu, sd = sigma)
pnorm(5, mean = mu, sd = sigma, lower.tail = FALSE)  # Alternative

# 4.) Quantile bestimmen
alpha <- 0.05
quantil <- qnorm(c(alpha / 2, 1 - alpha / 2), mean = mu, sd = sigma)
quantil

# Probe - Es muss alpha/2 und 1 - alpha/2 herauskommen.
pnorm(quantil, mean = mu, sd = sigma)


# Ziehe n = 6 normalverteilte Zufallszahlen mit
# Erwartungswert 100 und Varianz 100.

# Parameter einstellen
n <- 6
mu <- 100
sigma <- sqrt(100)

rnorm(n = n, mean = mu, sd = sigma)



### -------------------------------------------------------------------------
### 9.4  Gleichverteilte Zufallszahlen -- runif()
### -------------------------------------------------------------------------


# 6 Zufallszahlen aus einer Gleichverteilung auf [0, 1)
runif(6)

# 6 Zufallszahlen aus einer Gleichverteilung auf [-10, 10)
runif(6, min = -10, max = 10)



### -------------------------------------------------------------------------
### 9.5  Zufall reproduzieren: Seeding -- set.seed(), RNGversion()
### -------------------------------------------------------------------------


runif(3)       # 3 Zufallszahlen
runif(3)       # Und nocheinmal


set.seed(123)  # Seed festlegen
runif(3)       # 3 Zufallszahlen

set.seed(123)  # Seed festlegen
runif(3)       # Und nocheinmal


# Version des Zufallszahlengenerators einstellen
RNGversion(vstr = "4.0.2")



### -------------------------------------------------------------------------
### 9.6  Stichproben ziehen -- sample()
### -------------------------------------------------------------------------


# Permutation der Zahlen 1:5
sample(1:5)  # size ist automatisch 5; replace ist defaultmässig FALSE

# Stichprobe von 1:5 (mit Zurücklegen)
sample(1:5, replace = TRUE)

# Stichprobe von 1:5 der Grösse 10.
sample(1:5, replace = TRUE, size = 10)

sample(1:5, size = 10)

# 10 Würfe eines normalen 6-seitigen Würfels
sample(1:6, size = 10, replace = TRUE)

# 10 Würfe einer unfairen Münze: P(Kopf) = 2/3, P(Zahl) = 1/3
sample(c("Kopf", "Zahl"), size = 10, replace = TRUE, prob = c(2/3, 1/3))



### -------------------------------------------------------------------------
### 9.7  Aus der guten Statistikpraxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 9.7.1  Fallbeispiel: t-Test für das mittlere Gewicht von Äpfeln


# Ggf. Arbeitsverzeichnis wechseln mit setwd()
load("Apfel.RData")                     # Datei Apfel.RData laden
apfel.voll

# Hilfsgrössen definieren
c <- 160                                # Der Testwert
n <- sum(!is.na(apfel.voll))            # Stichprobengrösse
xquer <- mean(apfel.voll, na.rm = TRUE) # Mittelwert der Stichprobe
s <- sd(apfel.voll, na.rm = TRUE)       # Standardabweichung der Stichprobe


# Teststatistik berechnen
T <- (xquer - c) / s * sqrt(n)
T

# Quantil der t-Verteilung
qt(1 - alpha / 2, df = n - 1)

# 1.) Ist |T| grösser als das Quantil?
abs(T) > qt(1 - alpha / 2, df = n - 1)


# Konfidenzintervall berechnen
conf.int <- xquer + c(-1, 1) * qt(1 - alpha / 2, df = n - 1) * s / sqrt(n)
conf.int

# 2.) Liegt der Testwert c nicht in diesem Intervall?
c < conf.int[1] | c > conf.int[2]


# p-Wert berechnen
p.value <- 2 * (1 - pt(abs(T), df = n - 1))
p.value

# 3.) Ist der p-Wert < alpha?
p.value < alpha


# t-Test rechnen zur Kontrolle
t.test(apfel.voll, mu = c, conf.level = 1 - alpha)



### -------------------------------------------------------------------------
### 9.8  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 9.8.3  Übungen


dnorm(6, 10, 4)

			
seed <- round(runif(1, min = -2^31 + 1, max = 2^31 - 1))
set.seed(seed)

# Diverse Berechnungen
