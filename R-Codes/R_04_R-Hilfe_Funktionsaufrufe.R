### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 04: Funktionsaufrufe, R-Hilfe und nützliche Funktionen
### -------------------------------------------------------------------------


# Die Zahl, von der wir die Wurzel bestimmen wollen
n <- 9

# Hilfsvariablen
a <- 0
b <- n

# Ergebnis: wird schrittweise verfeinert
res <- (a + b) / 2

while(abs(res^2 - n) >= 10^(-9)) {
  if (res^2 < n) {
    a <- res
  }
  else {
    b <- res
  }
  res <- (a + b) / 2
}

# Ergebnis ausgeben
res

# Berechne die Wurzel einer Zahl und gib das Ergebnis aus
sqrt(9)



### -------------------------------------------------------------------------
### 4.1  R-Hilfe -- "?",  help()
### -------------------------------------------------------------------------


# Hilfe zu der Funktion sum und dem Operator + aufrufen
# ?sum
# ?"+"


# Hilfe zum Paket base aufrufen
# help(package = base)



### -------------------------------------------------------------------------
### 4.2  Sequenzen generieren -- seq()
### -------------------------------------------------------------------------


# Hilfe zur Funktion seq() aufrufen.
# ?seq


# Aufsteigende Sequenz mit Schrittweite 2
seq(from = 0, to = 20, by = 2)           # length.out ist automatisch 11.

# Absteigende Sequenz mit 5 Elementen und Schrittweite -4
seq(from = 10, by = -4, length.out = 5)  # to ist automatisch –6.

# Abgeschnittene Sequenz
seq(from = 0, to = 20, by = 3)           # length.out ist automatisch 7.



### -------------------------------------------------------------------------
### 4.3  Regelwerk für Funktionsaufrufe
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 4.3.1  Objektübergabe und Parameterzuordnung


seq(from = 0, to = 100, length.out = 6)

seq(0, 100, 6)

# length.out exakt ansprechen
seq(0, 100, length.out = 6)

# by (3. Argument) überspringen
seq(0, 100, , 6)

seq(leng = 6, 100, from = 0)


### -------------------------------------------------------------------------
### 4.3.2  Dynamische und statische Defaultwerte


# Spezifiziere 4 formale Argumente - Fehlermeldung
seq(from = 0, to = 10, by = 2, length.out = 6)


seq(from = 1, to = 10)
seq(from = 10, to = 1)


seq(length.out = 10)
seq(length.out = 10, by = 2)


### -------------------------------------------------------------------------
### 4.3.3  Dreipunkteargument und fehlende Werte -- ..., NA, na.rm


x <- c(1:4, NA)        # Beispielvektor mit einem NA
x

sum(x)
sum(x, TRUE)
sum(1:4, TRUE)

sum(x, na = TRUE)      # na.rm ist NICHT exakt benannt: Es klappt nicht!
sum(x, na.rm = TRUE)   # na.rm ist exakt benannt: Es klappt!
sum(na.rm = TRUE, x)   # So klappt es übrigens auch.



### -------------------------------------------------------------------------
### 4.4  Objekte und Elemente replizieren -- rep()
### -------------------------------------------------------------------------


# 0:2 als Ganzes replizieren
rep(0:2, times = 3)

# Jedes Element von 0:2 replizieren
rep(0:2, each = 3)

# Einsatz von length.out
rep(0:2, length.out = 10)

# Alternativer Einsatz von times
rep(x = 0:2, times = 3:1)



### -------------------------------------------------------------------------
### 4.5  Ganzzahlige Division, Rest und Teilbarkeit -- "%/%", "%%"
### -------------------------------------------------------------------------


# Ganzzahlige Division
7 %/% 3

# Rest der ganzzahligen Division
7 %% 3

# Kontrollrechnung
(7 %/% 3) * 3 + (7 %% 3)

# Ist 7 durch 3 teilbar?
(7 %% 3) == 0



### -------------------------------------------------------------------------
### 4.6  Komponentenweises Rechnen
### -------------------------------------------------------------------------


x <- 1:9
x

# Ganzzahlige Division
ganz <- x %/% 3
ganz

# Rest der ganzzahligen Division
rest <- x %% 3
rest


# Rekonstruktion des Vektors x:
ganz * 3 + rest    # Die 3 wird vor der Multiplikation recycelt.
x[rest == 0]       # Durch 3 teilbar <=> Rest == 0



### -------------------------------------------------------------------------
### 4.7  Nützliche Funktionen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 4.7.1  Exponentialfunktion und Logarithmus -- exp(), log()


exp(1)          # Eulersche Zahl e^1
exp(1:3)        # vektorwertige Anwendung: e^1, e^2, e^3
log(exp(1:3))   # der natürliche Logarithmus


# 10er-Logarithmus von 1000
log(1000, base = 10)

# Kontrolle: Es passt!
10 ^ (log(1000, base = 10))


### -------------------------------------------------------------------------
### 4.7.2  Runden -- round(), floor(), ceiling(), trunc(), digits


x <- -4.5:4.5
x

round(x)    # rundet mathematisch
floor(x)    # rundet generell ab
ceiling(x)  # rundet generell auf
trunc(x)    # rundet Richtung 0


x <- c(4.9, 5.49, 5.5, 5.51)
x

# Auf Ganze runden
round(x, digits = 0)

# Auf Zehntel runden
round(x, digits = 1)

# Auf Zehner runden
round(x, digits = -1)


zahlen <- c(114, 221, 428, 545, 555)
zahlen

k <- 10

# Runde auf ganze k
k * round(zahlen / k)


### -------------------------------------------------------------------------
### 4.7.3  Absolutbetrag und Vorzeichenfunktion -- abs(), sign()


x <- -3:3
x

# Absolutbetrag
abs(x)

# Vorzeichen bestimmen
sign(x)


### -------------------------------------------------------------------------
### 4.7.4  Trigonometrie -- sin(), cos(), tan(), pi


pi


# Sequenz von 0 bis 2*pi
x <- seq(0, 2 * pi, by = pi / 2)
round(x, digits = 3)

round(sin(x), digits = 3)
round(cos(x), digits = 3)


### -------------------------------------------------------------------------
### 4.7.5  Aggregierende Logikfunktionen -- all(), any(), xor()


x <- c(3, 4, 9, 2)
x

# 1.) alle Einträge positiv?
sum(x > 0) == length(x)
#     Kürzere Alternative
all(x > 0)
x

# 2.) mind. 1 Zahl durch 5 teilbar?
sum(x %% 5 == 0) > 0
#     Kürzere Alternative
any(x %% 5 == 0)
x


# Durch 3 teilbar?
bool.tb3 <- x %% 3 == 0
bool.tb3
x

# Grösser oder gleich 4?
bool.ge4 <- x >= 4
bool.ge4
x

# 3.) durch 3 teilbar oder >= 4?
bool.tb3
bool.ge4
bool.tb3 | bool.ge4
sum(bool.tb3 | bool.ge4)
x

# 4.) entweder tb3 oder ge4?
bool.tb3 + bool.ge4
bool.tb3 + bool.ge4 == 1
xor(bool.tb3, bool.ge4) # mit xor()
sum(xor(bool.tb3, bool.ge4))
x



### -------------------------------------------------------------------------
### 4.8  Aus der guten Programmierpraxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 4.8.1  Programmierstil: Funktionssammlung erweitern


stapel

# Indexvektor mit Sequenzoperator
1:length(stapel)

# Indexvektor mit seq_along()
seq_along(stapel)


### -------------------------------------------------------------------------
### 4.8.2  Fallbeispiel: Lottotippscheine


# Generiere Spalten- und Zeilenindizes für die Zahlen
spalte <- rep(1:6, length.out = 45)
zeile <- rep(1:8, each = 6)[1:45]

spalte
zeile

zeile[tipp]   # Zeilen der getippten Zahlen selektieren
spalte[tipp]  # Spalten der getippten Zahlen selektieren


# Die Daten der Lotterie
nzahlen <- 45   # Anzahl der Zahlen der Lotterie
ncol <- 6       # Anzahl der Spalten des Tippscheins

# Bestimme die Anzahl der Zeilen (rows) des Tippscheins - mit Fehler
# 1. Versuch (funktioniert nicht)
nrow <- nzahlen %/% ncol
nrow

# Bestimme die korrekte Anzahl der Zeilen (rows) des Tippscheins
# 2. Versuch (funktioniert nicht immer)
nrow <- nzahlen %/% ncol + 1
nrow

# Generiere Spalten- und Zeilenindizes für die Zahlen
zeile <- rep(1:nrow, each = ncol)[1:nzahlen]
spalte <- rep(1:ncol, length.out = nzahlen)

zeile[tipp]   # Zeilen der getippten Zahlen selektieren
spalte[tipp]  # Spalten der getippten Zahlen selektieren


# Funktioniert so nicht für die Lotterie 6 aus 49

# Die Daten der Lotterie
nzahlen <- 49   # Anzahl der Zahlen der Lotterie
ncol <- 7       # Anzahl der Spalten (columns) des Tippscheins

# Bestimme die Anzahl der Zeilen (rows) des Tippscheins
nrow <- nzahlen %/% ncol + 1
nrow

# Ist die letzte Zeile des Lottoscheins voll?
c(45, 49) %% c(6, 7) == 0

# 1 hinzuaddieren, wenn die letzte Zeile nicht voll ist.
+ (c(45, 49) %% c(6, 7) != 0)

# Anzahl der Zeilen für die Lotterien 6 aus 45 und 6 aus 49
c(45, 49) %/% c(6, 7) + (c(45, 49) %% c(6, 7) != 0)


# Korrekte und saubere Lösung des Beispiels

# Die Daten der Lotterie
nzahlen <- 45   # Anzahl der Zahlen der Lotterie
ncol <- 6       # Anzahl der Spalten (columns) des Tippscheins

# Bestimme die Anzahl der Zeilen (rows) des Tippscheins
nrow <- nzahlen %/% ncol + (nzahlen %% ncol != 0)
nrow

# Generiere Spalten- und Zeilenindizes für die Zahlen
zeile <- rep(1:nrow, each = ncol)[1:nzahlen]
spalte <- rep(1:ncol, length.out = nzahlen)

zeile[tipp]   # Zeilen der getippten Zahlen selektieren
spalte[tipp]  # Spalten der getippten Zahlen selektieren



### -------------------------------------------------------------------------
### 4.9  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 4.9.3  Übungen


stapel

# Selektiere jedes zweite Element aus stapel (beginnend beim ersten)
stapel[c(1, 3, 5)]


x <- c(6.49, 6.5, 6.51)
x
