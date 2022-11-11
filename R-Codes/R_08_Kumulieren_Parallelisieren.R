### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 08: Kumulieren und Parallelisieren
### -------------------------------------------------------------------------


# Die Schlagzahlen der beiden Spieler nach 6 Bahnen
schlaege1 <- c(2, 3, 2, 4, 7, 3)
schlaege2 <- c(1, 3, 3, 6, 4, 2)



### -------------------------------------------------------------------------
### 8.1  Kumulierende Funktionen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 8.1.1  Kumulierte Summen -- cumsum()


sum(schlaege1)  # Gesamtschlagzahl für Spieler 1
sum(schlaege2)  # Gesamtschlagzahl für Spieler 2

# Liegt Spieler 1 in Führung?
sum(schlaege1) <= sum(schlaege2)

# Differenz der Gesamtschlagzahlen beider Spieler
sum(schlaege1) - sum(schlaege2)


# Bilde die kumulierte Summe für die Schlagzahlen von Spieler 1
# Mühsame und fehleranfällige Variante
c(sum(schlaege1[1:1]), sum(schlaege1[1:2]), sum(schlaege1[1:3]),
  sum(schlaege1[1:4]), sum(schlaege1[1:2]), sum(schlaege1[1:6]))


# Bilde die kumulierte Summe für die Schlagzahlen
# Bessere Variante!

schlaege1
cumsum(schlaege1)

schlaege2
cumsum(schlaege2)


cumsum(schlaege1) - cumsum(schlaege2)

# Nach welchen Bahnen war Spieler 1 in Führung?
which(cumsum(schlaege1) - cumsum(schlaege2) <= 0)

# Wie viele Runden lang war Spieler 1 in Führung?
sum(cumsum(schlaege1) - cumsum(schlaege2) <= 0)


### -------------------------------------------------------------------------
### 8.1.2  Kumulierte Produkte -- cumprod()


n <- 5

# Vektor mit 1!, 2!, ..., n!
cumprod(1:n)

# Alternative (weniger effizient)
factorial(1:n)


### -------------------------------------------------------------------------
### 8.1.3  Kumulierte Minima und Maxima -- cummin(), cummax()


schlaege1
# Kumuliertes Maximum für Spieler 1
cummax(schlaege1)

schlaege2
# Kumuliertes Maximum für Spieler 2
cummax(schlaege2)



### -------------------------------------------------------------------------
### 8.2  Parallele Funktionen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 8.2.1  Parallele Minima und Maxima -- pmin(), pmax()


min(schlaege1, schlaege2)


schlaege1
schlaege2

# Bestimme für jede Bahn die kleinere Schlagzahl
pmin(schlaege1, schlaege2)


# Sortiere die Bahnnummern nach Schwierigkeit
order(schlaege1 + schlaege2, pmax(schlaege1, schlaege2))


### -------------------------------------------------------------------------
### 8.2.2  Vektorwertige binäre Fallunterscheidungen -- ifelse()


schlaege1
schlaege2

# Bestimme das parallele Minimum
ifelse(test = schlaege1 < schlaege2, yes = schlaege1, no = schlaege2)


ifelse(test = schlaege1 == schlaege2, yes = 0, no =
    ifelse(test = schlaege1 < schlaege2, yes = 1, no = 2))



### -------------------------------------------------------------------------
### 8.3  Differenzieren -- diff()
### -------------------------------------------------------------------------


# Differenziere den Vektor der Schlagzahlen
diff(schlaege1)

# Zähle, wie oft die Differenzen <= 0 sind
diff(schlaege1) <= 0
sum(diff(schlaege1) <= 0)


schlaege1

cumsum(schlaege1)
diff(cumsum(schlaege1))



### -------------------------------------------------------------------------
### 8.4  Kovarianz und Korrelation -- cov(), cor()
### -------------------------------------------------------------------------


# Gibt es einen positiven Zusammenhang zwischen den Schlagzahlen?
cov(schlaege1, schlaege2) / (sd(schlaege1) * sd(schlaege2))
cor(schlaege1, schlaege2)



### -------------------------------------------------------------------------
### 8.5  Aus der guten Programmierpraxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 8.5.1  Fallbeispiel: Gewinnrangermittlung beim Joker


# Die Ziehung und der Tipp
jokerziehung <- c(4, 3, 9, 1, 0, 3)
jokertipp <-    c(4, 3, 9, 0, 0, 3)

jokertipp == jokerziehung
rev(jokertipp == jokerziehung)
cummin(rev(jokertipp == jokerziehung))
sum(cummin(rev(jokertipp == jokerziehung)))


### -------------------------------------------------------------------------
### 8.5.2  Fallbeispiel: Das Geburtstagsproblem


n <- 30  # Berechnung für n = 1, 2, ..., 30

# 1-zu-1-Umsetzung der obigen Formel
pk <- (365 - 0:(n - 1)) / 365
res <- 1 - cumprod(pk)

round(res, digits = 3)  # Runden, um es übersichtlicher zu machen

# Ersten Index finden, bei dem die Wahrscheinlichkeit 50% ueberschreitet.
index <- which(res > 0.5)[1]
index

# Entsprechende Wahrscheinlichkeit ausgeben.
res[index]


### -------------------------------------------------------------------------
### 8.5.3  Programmierstil: Wiederholte Berechnungen vermeiden


# Hilfsvariable
fuehrung1 <- cumsum(schlaege1) - cumsum(schlaege2) <= 0
fuehrung1

# Nach welchen Bahnen war Spieler 1 in Führung?
which(fuehrung1)

# Wie viele Runden lang war Spieler 1 in Führung?
sum(fuehrung1)



### -------------------------------------------------------------------------
### 8.6  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 8.6.1  Objekte sichern


# Daten sichern
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
save(schlaege1, schlaege2, file = "Minigolf.RData")


### -------------------------------------------------------------------------
### 8.6.4  Übungen


x <- c(2, 8, 5, 1)


x <- c(-1, 1, 2, 2, -2)
which(diff(x) >= 0)
