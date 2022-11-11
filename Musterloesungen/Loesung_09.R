### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 9
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


### lambda waehlen.
# Beachte, dass die Exponentialverteilung nur fuer positive lambda
# definiert ist (siehe Kommentar nach b)).
lambda <- c(-1, 0, 1, 2, 3)
lambda


### a)

# Der name exp steht fuer die Exponentialverteilung, als prefix waehlen wir
# p, da wir ander Verteilungsfunktion interessiert sind.
x <- log(2) / lambda
pexp(x, rate = lambda)


### b)

x <- log(2) / lambda
1 - exp(-lambda * x)

# Wer es ganz genau haben will: lambda muss > 0 sein. Wir koennen mit
# ifelse() diese Bedingung pruefen und ggf. NaN erzeugen.
ifelse(lambda > 0, 1 - exp(-lambda * x), NaN)


# ln(2) / lambda markiert exakt den Median der Exponentialverteilung.
# Daher kommt fuer jedes lambda > 0 der Wert 0.5 heraus.



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Die Normalverteilung ist in R ueber die Standardabweichung definiert und
# nicht ueber die Varianz. Ausserdem brauchen wir das Praefix "r", da wir
# Zufallszahlen ziehen wollen; mit "d" berechnen wir Dichten.
rnorm(n = 6, mean = 10, sd = sqrt(4))



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


# Wir zeigen zunaechst, dass die Methode wirklich nicht funktioniert.

# Erster Versuch
seed <- round(runif(1, min = -2^31 + 1, max = 2^31 - 1))
set.seed(seed)

runif(5)

# Zweiter Versuch: Es kommen andere Zahlen heraus.
seed <- round(runif(1, min = -2^31 + 1, max = 2^31 - 1))
set.seed(seed)

runif(5)


# Das Problem ist, dass der seed aus einer Zufallszahl abgeleitet wird
# (runif()). Dort wird der seed aber nicht gesetzt, das heisst, dass
# runif() immer eine andere Zahl erzeugt.

# Damit es funktioniert, muss der seed unabhaengig von jeglichen
# Zufallszahlen gesetzt werden.



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Zufallszahlengenerator einstellen
RNGversion("4.0.2")
set.seed(123)


### a)

n <- 10000

# Beide Wurfvektoren erstellen ...
wurf1 <- sample(1:6, size = n, replace = TRUE)
wurf2 <- sample(1:6, size = n, replace = TRUE)

# ... und addieren
wurf <- wurf1 + wurf2


### b)

sum(wurf == 7)

# Laut Theorie muesste ungefaehr jede 6. Augensumme gleich 7 sein. Je mehr
# Zahlen wir wuerfeln, desto genauer ist das simulierte Ergebnis
mean(wurf == 7)  # Simuliertes Ergebnis
1/6              # Theoretisches Ergebnis


### c)

# Zwei moegliche Varianten
sum(wurf == 2 | wurf == 12)
sum(wurf %in% c(2, 12))

# Die zweite Variante mit dem "%in%"-Operator ist in diesem Fall besser.
# Wenn wir etwa wissen wollten, wie viele Augensummen 2, 3, 4 oder 12
# gleichen, so wuerde die erste Variante unsere Finger stark beanspruchen.



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


# Vorueberlegung: runif(n, min, max) erzeugt n gleichverteilte Zahlen aus
# dem Intervall [min, max). Wenn wir min = 1 und max = 7 setzen, dann
# gilt fuer alle Zufallszahlen z: z >= 1 und z < 7. Wenn wir diese Zahlen
# generell abrunden, dann haben wir, was wir wollen.

set.seed(1)
n <- 100
floor(runif(n, min = 1, max = 7))


# Eine vom Code her laengere Alternative: Wir ziehen mit runif() Zufalls-
# zahlen aus [1, 7). Anschliessend zaehlen wir 
set.seed(1)
z <- runif(n, min = 1, max = 7)
(z >= 1) + (z >= 2) + (z >= 3) + (z >= 4) + (z >= 5) + (z >= 6)

# Mit Schleifen (lernen wir noch), koennten wir diese Variante kuerzer
# so schreiben:
zahlen <- rep(0, n)
for (k in 1:6) {
  zahlen <- zahlen + (z >= k)
}

zahlen


### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


# Beispielvektor
x <- 0:5


### a)

xtilde <- (x - min(x)) / (max(x) - min(x))
xtilde

# Statt max(x) - min(x) koennen wir auch diff(range(x)) schreiben.


### b)

# Beispielwerte fuer a und b
a <- 2
b <- 6

# Mit pmax() und pmin() koennen wir die Werte ganz leicht stutzen.
# Alternativ koennten wir auch mit ifelse() arbeiten.
xtilde <- pmax(pmin((x - a) / (b - a), 1), 0)
xtilde


# Bei der Transformation handelt es sich um die Verteilungsfunktion der
# Gleichverteilung im Intervall [a, b]. Daher eignet sich punif().
punif(x, min = a, max = b)

