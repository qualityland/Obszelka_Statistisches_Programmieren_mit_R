### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 11: Einfache Datentypen, Modes und Typumwandlung
### -------------------------------------------------------------------------


12 < "9"



### -------------------------------------------------------------------------
### 11.2  Mode abfragen -- mode(), is.datentyp()
### -------------------------------------------------------------------------


# Mische numerische Werte und logische Werte: Ergebnis ist vom Mode numeric
x <- c(5, TRUE, 0, FALSE)
x

mode(x)                 # Abfrage des Modes
is.numeric(x)           # Abfrage auf numeric
mode(x) == "numeric"    # Alternative Abfrage auf numeric


# Mische Strings mit anderen Modes: Ergebnis ist vom Mode character
x <- c(1, "a", TRUE, -5.5, 1/4)
x

mode(x)                 # Abfrage des Modes
is.character(x)         # Abfrage auf character
mode(x) == "character"  # Alternative Abfrage auf character



### -------------------------------------------------------------------------
### 11.3  Implizite Typumwandlung
### -------------------------------------------------------------------------


TRUE + FALSE

3 * TRUE
sum(c(TRUE, FALSE))


"2" + "3"
sum(c("2", "3"))


1976 | 1977  # intern: (1976 != 0) | (1977 != 0)
2 & 3        # intern: (2 != 0) & (3 != 0)


"FALSE" | TRUE


12 < 9
"12" < 9



### -------------------------------------------------------------------------
### 11.4  Explizite Typumwandlung -- as.datentyp()
### -------------------------------------------------------------------------


text <- c("5", "2", "6", "3")
text
mean(text)     # Kann keinen Mittelwert berechnen, da character.

# Explizite Umwandlung in Mode numeric
zahlen <- as.numeric(text)
zahlen
mean(zahlen)   # Jetzt funktioniert der Mittelwert, da numeric.


x <- c("A", "1/5", 1, TRUE)
x

as.numeric(x)  # "A", "1/5" und "TRUE" nicht (direkt) konvertierbar
as.logical(x)  # "A", "1/5" und "1" nicht (direkt) konvertierbar

y <- -1:2
y

as.logical(y)
y != 0  # in diesem Fall äquivalent



### -------------------------------------------------------------------------
### 11.5  Komplexe Zahlen -- complex, Re(), Im(), NaN
### -------------------------------------------------------------------------


# Koeffizienten definieren
a <- 0.5
b <- -3
c <- 6.5

# Eingabe der komplexwertigen Lösungen
x <- c(3 - 2i, 3 + 2i)
x

# Kontrolle
a * x^2 + b * x + c

# Realteile von x
Re(x)

# Imaginärteile von x
Im(x)



### -------------------------------------------------------------------------
### 11.6  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 11.6.3  Übungen


x <- c(1, 2, 3, 5)
