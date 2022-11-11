### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 02: Los geht's
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 2.2  Aus der guten Programmierpraxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 2.2.2  Programmierstil: Gliederung, Lesbarkeit und Kommentierung


# Ermittle die Lösungen für die quadratische Gleichung
# a x^2 + b x + c = 0

# Festlegen der Koeffizienten
a <- 2
b <- -5
c <- 3

# Ermittlung der Lösungen
x1 <- (-b + sqrt(b^2 - 4 * a * c)) / (2 * a)
x2 <- (-b - sqrt(b^2 - 4 * a * c)) / (2 * a)

# Anzeigen der Lösungen
x1
x2



### -------------------------------------------------------------------------
### 2.3  Kommentare und Zuweisungen -- "#", "<-"
### -------------------------------------------------------------------------


# Linkszuweisung
# Empfohlen!
a <- 2
a

# Rechtszuweisung
# Nicht empfohlen!
2 -> a
a

# Zuweisung mit "="
# Unüblich in R!
a = 2
a


# Kommentare können auch neben dem Code stehen.
a <- 2    # Parameter a definieren



### -------------------------------------------------------------------------
### 2.4  R als Taschenrechner -- "+", "-", "*", "/", "^", "( )", sqrt()
### -------------------------------------------------------------------------


# Klammersetzung beeinflusst Punkt- vor Strichrechnung
4 * 2 + 3
4 * (2 + 3)

# Klammersetzung bei Multiplikation mit einer negativen Zahl
(2 + 3) * (-4)
(2 + 3) * -4

# Einfache Potenzen und Quadratwurzeln
3 ^ 2
sqrt(9)     # Quadratwurzel aus 9
9 ^ 0.5     # ebenfalls die Quadratwurzel aus 9

# Beachte die Klammersetzung!
9 ^ (1/2)   # entspricht Wurzel aus 9
9 ^ 1 / 2   # das nicht (entspricht (9 ^ 1) / 2

# Wurzeln höherer Ordnung
27 ^ (1/3)  # 3. Wurzel aus 27
3 ^ 3       # Kontrolle


# Verhältnis des Goldenen Schnittes
gamma <- (sqrt(5) - 1) / 2
gamma
