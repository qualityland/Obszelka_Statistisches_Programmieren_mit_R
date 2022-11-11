### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 29
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


sum <- function(..., na.rm = TRUE) {
  # ... und na.rm werden an base::sum() weitergereicht.
  base::sum(..., na.rm)
}

# Das Problem: na.rm kommt nach dem Dreipunkteargument und muss exakt
# benannt werden. Das ist hier nicht der Fall, daher wird na.rm wie
# ein normaler Summand behandelt und in die Summe mit einbezogen. Dabei
# wird TRUE in 1 umkonvertiert.

sum(1:4)
sum(c(1:4, NA))


# Damit es funktioniert, muss na.rm exakt benannt werden.

sum <- function(..., na.rm = TRUE) {
  # ... und na.rm werden an base::sum() weitergereicht.
  base::sum(..., na.rm = na.rm)
}

sum(1:4)
sum(c(1:4, NA))

rm(sum) # ACHTUNG: Loesche unsere Funktion wieder!



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


transformation <- function(x, a = 0, b = 1) {
  # Diese Funktion transformiert einen Vektor x wie folgt:
  #      ( 0                  falls x < a
  # y = <| (x - a) / (b - a)  falls a <= x <= b
  #      ( 1                  falls x > b
  # a ... ein numerischer Skalar (Defaultwert 0)
  # b ... ein numerischer Skalar (Defaultwert 1)
  # Es muss a < b gelten. Falls b >= a wird die Funktion mit einem
  # Fehler abgebrochen.

  # Pruefe auf geeignete Werte fuer a und b
  # Wir verwenden dabei das doppelte Oder (||). Damit wird ein Ausdruck
  # nur dann ausgewertet, wenn alle linksstehenden Ausdruecke FALSE sind.
  if (!is.numeric(a) || !is.numeric(b) ||
    length(a) != 1 || length(b) != 1 || a >= b) {
    stop("a und b muessen numerische Skalare sein und a < b muss gelten!\n")
  }

  # Transformierten Vektor berechnen ...
  y <- ifelse(x < a, 0, ifelse(x > b, 1, (x - a) / (b - a)))

  # ... und zurueckgeben
  return(y)
}

# Testen unsere Funktion
x <- -3:3
x

transformation(x)
transformation(x, a = -0.5, b = 1.5)

# Fehlermeldung checken
transformation(x, a = 0, b = 0)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


# Funktion norm() aus dem Buch
norm <- function(x, p = 2) {
  if (!is.vector(x) || !is.numeric(x))
    stop("\nx muss ein numerischer Vektor sein!")
  return(sum(abs(x)^p) ^ (1/p))
}


# y bekommt einen dynamischen Defaultwert, da er von der Laenge von x
# abhaengt.

distanz <- function(x, y = rep(0, length(x)), p = 2) {
  # Berechnet die p-Distanz zwischen zwei Vektoren x und y.
  # ||x - y||_p = (sum |x - y|^p)^(1/p)
  # x ... numerischer Vektor
  # y ... numerischer Vektor (Standardwert: Nullvektor)
  # p ... numerischer Skalar. Welche Distanz soll berechnet werden?
  #       Standardwert p = 2: Euklidische Distanz
  # Falls x und y nicht gleich lange numerische Vektoren sind oder p kein
  # numerischer Skalar ist, wird die Funktion mit einem Fehler abgebrochen.

  # Pruefe auf plausible Werte fuer x und y
  if (!is.numeric(x) || !is.numeric(y) || length(x) != length(y)) {
    stop("x und y muessen gleich lange numerische Vektoren sein!\n")
  }

  # Pruefe auf plausible Werte fuer p
  if (!is.numeric(p) || length(p) != 1) {
    stop("p muss ein numerischer Skalar sein!\n")
  }  

  # Zurueckfuehren auf die Funktion norm()
  return(norm(x - y, p = p))
}


# Testen unsere Funktion
x <- 1:4
y <- rep(5, 4)

x
y

# Manhattan-Distanz (p = 1)
distanz(x, y, p = 1)

# Euklidische Distanz (p = 2 Standard)
distanz(x, y)

# Defaultwert fuer y testen
distanz(x)

# Fehlermeldungen testen
distanz(x, y = 1:2)
distanz(x, p = 1:2)


# Der Vorteil der Rueckfuehrung liegt darin, dass wir die Formel fuer die
# Berechnung der Norm nur ein Mal aufschreiben muessen. Entdecken wir dort
# einen Fehler, brauchen wir nur an einer Stelle zu korrigieren.



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Bei dieser Aufgabe gibt es mehrere Zugaenge. Man koennte zum Beispiel den
# Datumsvektor als Stringvektor auffassen und das Datumsformat mitgeben,
# sodass mit geeigneten Stringfunktionen die gewuenschten Informationen
# korrekt extrahiert werden.

# Wir gehen in unserer Variante davon aus, dass der Datumsvektor ein Objekt
# der Klasse Date, POSIXct oder POSIXlt ist. Gerne darfst du auch andere
# Varianten umsetzen!

# Beim Rueckgabeobjekt gibt es unter anderem zwei naheliegende Varianten:
# 1.) Eine Matrix mit drei Spalten (Jahr, Monat, Tag)
# 2.) Ein Dataframe mit vier Variablen (Datum, Jahr, Monat, Tag)
# Wir entscheiden uns hier fuer die Matrix, gerne darfst du den Code derart
# umschreiben, dass ein Dataframe erzeugt wird.

datumsinfo <- function(datum) {
  # Extrahiert aus dem Datumsvektor datum die Jahre, Monate und Tage als
  # Zahlen und gibt eine dreispaltige Matrix zurueck.
  # datum ... Ein Datumsvektor der Klassen Date, POSIXct oder POSIXlt

  # Pruefe, ob datum eine geeignete Klasse ist.
  bool <- c("Date", "POSIXct", "POSIXlt") %in% class(datum)
  if (!any(bool)) {
    stop("datum muss ein Objekt der Klasse Date, POSIXct oder POSIXlt sein!\n")
  }

  # Jahre, Monate und Tage extrahieren
  jahr <- as.numeric(format(datum, format = "%Y"))
  monat <- as.numeric(format(datum, format = "%m"))
  tag <- as.numeric(format(datum, format = "%d"))

  # Und zu einer Matrix zusammensetzen
  return(cbind(Jahr = jahr, Monat = monat, Tag = tag))
}


# Testen unsere Funktion
datum <- Sys.Date() + 0:6
datum

uhr <- Sys.time() + (0:6) * 60 * 60 * 24
uhr

datumsinfo(datum)
datumsinfo(uhr)
datumsinfo("2020-01-01")

