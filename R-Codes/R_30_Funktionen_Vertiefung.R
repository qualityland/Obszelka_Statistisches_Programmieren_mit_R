### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 30: Eigene Funktionen: Ergänzung und Vertiefung
### -------------------------------------------------------------------------


# Daten laden
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
load("Test.RData")
test



### -------------------------------------------------------------------------
### 30.1  *apply() vs. Schleifen
### -------------------------------------------------------------------------


n <- 8  # berechne 8 Folgenglieder
fibo <- rep(1, n)
fibo

sapply(3:n, function(i) {
  fibo[i] <- fibo[i-1] + fibo[i-2]
  return(fibo[i])
})

fibo  # nichts passiert


# Globale Zuweisung <<- *nicht* empfohlen!
n <- 8  # berechne 8 Folgenglieder
fibo <- rep(1, n)
fibo

sapply(3:n, function(i) {
  fibo[i] <<- fibo[i-1] + fibo[i-2]
  return(fibo[i])
})

fibo  # überschrieben


# Wollen jede Punktespalte von test auf 100% skalieren
test

# Punktespalten bestimmen und in einer for-Schleife manipulieren
names.pkt <- grep("Pkt", names(test), value = TRUE)
names.pkt

for (j in names.pkt) {
  # Spalte j skalieren
  test[[j]] <- test[[j]] / 40 * 100
}

test
j



### -------------------------------------------------------------------------
### 30.2  Anonyme Funktionen -- function()
### -------------------------------------------------------------------------


iqr <- function(x, na.rm = FALSE) {
  # Berechnet die Interquartilsdistanz für einen Vektor x
  return(diff(quantile(x, prob = c(0.25, 0.75), na.rm = na.rm)))
}

# Interquartilsdistanz von Pkt getrennt nach Gruppe berechnen
tapply(test$Pkt, test$Gruppe, iqr, na.rm = TRUE)


# Interquartilsdistanz von Pkt getrennt nach Gruppe berechnen
tapply(test$Pkt, test$Gruppe, function(x)
  return(diff(quantile(x, prob = c(0.25, 0.75), na.rm = TRUE)))
)


# Interquartilsdistanz aller Pkt-Spalten getrennt nach Gruppe berechnen
sapply(test[names.pkt], function(x)
  tapply(x, test$Gruppe, iqr, na.rm = TRUE)
)



### -------------------------------------------------------------------------
### 30.3  Rekursion -- Recall()
### -------------------------------------------------------------------------


fakultaet <- function(n) {
  # Abbruchsbedingung
  if (n <= 1)
    return(1)
		
  return(n * fakultaet(n - 1))
}

fakultaet <- function(n) {
  # Abbruchsbedingung
  if (n <= 1)
    return(1)
		
  return(n * Recall(n - 1))
}

fakultaet(4)

fakultaet(1:4)   # Funktioniert nicht wie gewünscht

# Besser, da vektorwertig
factorial(1:4)

# Hier noch besser
cumprod(1:4)


permutation <- function(x) {
  # Gibt eine Matrix mit allen Permutationen der Menge x zurück.
	
  # Abbruchbedingung
  if (length(x) <= 1)
    return(t(x))  # t(x), damit eine Matrix erzeugt wird.
	
  # Rekursiver Abstieg
  M <- NULL       # Initialisierung notwendig
  for (i in 1:length(x)) {
    M <- rbind(M, cbind(x[i], Recall(x[-i])))
  }
  return(M)
}

permutation(1:3)
permutation(LETTERS[1:3])


fibonacci_iterativ <- function(n) {
  if (!is.numeric(n) || n <= 0 || n %% 1 != 0)
    stop("n muss eine positive ganze Zahl sein!")
		
  # Abbruchbedingung
  if (n <= 2)
    return(1)
		
  # Initialisierung und Berechnung
  fibo <- rep(1, n)
	
  for (i in 3:n) {
    fibo[i] <- fibo[i - 2] + fibo[i - 1]
  }
  return(fibo[n])
}
	
fibonacci_iterativ(7)


fibonacci_rekursiv <- function(n) {
  if (!is.numeric(n) || n <= 0 || n %% 1 != 0)
    stop("n muss eine positive ganze Zahl sein!")
		
  # Abbruchbedingung
  if (n <= 2)
    return(1)
		
  # Rückführung
  return(Recall(n - 2) + Recall(n - 1))
}
	
fibonacci_rekursiv(7)

# Abbruch mit ESC möglich
# fibonacci_rekursiv(30)
# fibonacci_iterativ(30)


# Hauptfunktion (wird vom Benutzer aufgerufen)
sequenz <- function(buch, k) {
	
  # Bestimmt eine Sequenz der Länge k mit den Zeichen von buch.
  # Fuer buch = letters[1:3]: a b c aa ab ac ba bb bc ca bc ...
  # buch ... Zeichensatz (zum Beispiel c("a", "b", "c"))
  # k ...... Wie lange soll die Sequenz sein.
	
  # Abbruchsbedingung
  if (k <= length(buch)) {
    # Hier reicht ein Zeichen fuer alle k Elemente aus. 
    return(buch[1:k])
  }
	
  # Aufruf der rekursiven Subfunktion: Hier brauchen wir mehr Zeichen.
  liste <- list(buch)
  liste1 <- sequenz.sub(buch, k - length(buch), stellen = 2, liste = liste)
  return(unlist(liste1))
}

# Hilfsfunktion (wird von \textcolor{rinput}{sequenz()} aufgerufen)
sequenz.sub <- function(buch, k, stellen, liste) {
	
  # buch ...... Zeichensatz
  # k ......... Laenge der Restsequenz
  # stellen ... Anzahl der Zeichen
  # liste ..... Liste, an welche die naechsten
  #             Sequenzglieder angehaengt werden.
	
  # Maximal moegliche Anzahl der Sequenzglieder mit genau stellen Zeichen
  anz <- length(buch)^stellen
	
  # Alle stellen-langen Sequenzglieder erzeugen
  temp <- paste0(rep(liste[[stellen - 1]], each = length(buch)), buch)
	
  # Abbruchsbedingung
  if (k <= anz) {
    # Können alle restlichen Glieder abdecken
    liste[[stellen]] <- temp[1:k]
    return(liste)
  }
	
  # Rekursiver Abstieg
  liste[[stellen]] <- temp
  return(Recall(buch, k - anz, stellen + 1, liste))
}

sequenz(c("A", "B", "C", "D"), k = 10)

sequenz(c("a", "b", "c"), k = 24)



### -------------------------------------------------------------------------
### 30.4  Methoden für generische Funktionen schreiben
### -------------------------------------------------------------------------


# Beispieldaten
datum <- as.Date(c("1.1.2018", "2.1.2018"), format = "%d.%m.%Y")
class(datum)

print(datum)    # Interner Aufruf: print.Date(datum)

# Überschreibe die Funktion print.Date()
print.Date <- function(x) {
  res <- format(x, format = "%d.%m.%Y")
  print.default(res)
}

print(datum)    # Verwendet jetzt unsere Funktion print.Date()

# Zugriff auf die print.Date-Funktion der Klasse base
base::print.Date(datum)

# Lösche abschliessend unsere Funktion print.Date()
rm(print.Date)
print(datum)    # Jetzt wird wieder wie früher gedruckt.



### -------------------------------------------------------------------------
### 30.5  Eigene Operatoren schreiben
### -------------------------------------------------------------------------


"%out%" <- function(a, b) {
  return(!(a %in% b))
}

c(6, 7) %in% 1:6
c(6, 7) %out% (1:6)

"%out%"(c(6,7), 1:6)  # Entspricht c(6,7) %out% 1:6



### -------------------------------------------------------------------------
### 30.6  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 30.6.1  Fallbeispiel: Klasse Bruch


is.ganzzahlig <- function(x) {
  # Prüft, ob alle Elemente des Vektors x annähernd ganzzahlig sind.
	
  return(all((x %% 1)^2 < .Machine$double.eps))
}

is.ganzzahlig(-1)
is.ganzzahlig(-1.0000001)
is.ganzzahlig(-1.00000000000000000001)  # Annähernd ganzzahlig

z <- c(1.99, 2, 2.01)
z

# Umwandlung in integer
# (ohne Rundung)
z.int <- as.integer(z)
z.int
class(z.int)

# Umwandlung in integer
# (mit Rundung)
z.int <- as.integer(round(z))
z.int
class(z.int)


Bruch <- function(zaehler, nenner) {
  # Erzeugt aus zwei annaehernd ganzzahligen Skalaren zaehler und nenner
  # ein Objekt der Klasse Bruch
	
  # Pruefe auf numerische Skalare
  if (!is.numeric(zaehler) || !is.numeric(nenner) ||
    length(zaehler) > 1 || length(nenner) > 1) {
    stop("Zaehler und Nenner muessen numerische Skalare sein!")
  }
	
  # Ergebnisobjekt erstellen
  res <- c(zaehler, nenner)
	
  # Pruefe auf gültige Werte und annaehernde Ganzzahligkeit
  if (any(is.na(res)) || !is.ganzzahlig(res)) {
    stop("Zaehler und Nenner muessen ganzzahlig sein!")
  }
	
  # In Integer (ganzzahlige Werte) umwandeln
  res <- as.integer(round(res))
	
  # Klasse "Bruch" hinzufügen und Bruch zurückgeben
  class(res) <- c("Bruch", class(res))
  return(res)
}

b <- Bruch(2, 3)  # Erzeuge den Bruch 2/3
print(b)

print.Bruch <- function(bruch) {
  cat(paste0(bruch[1], "/", bruch[2], "\n"))
}

"print.Bruch" %in% methods(print)

# Ruft intern print(b) auf
b

# Ruft intern print.Bruch(b) auf
print(b)


b1 <- Bruch(2, 3)
b1

b2 <- Bruch(1, 2)
b2

b1 * b2  # funktioniert schon
b1 / b2  # funktioniert nicht!


"/.Bruch" <- function(bruch1, bruch2) {
  bruch1 * rev(bruch2)
}

b1 / b2


b1 + b2

"+.Bruch" <- function(bruch1, bruch2) {
  nenner <- bruch1[2] * bruch2[2]
  zaehler <- bruch1[1] * bruch2[2] + bruch2[1] * bruch1[2]
  return(Bruch(zaehler, nenner))
}

b1 + b2


b1 + 2
2 + b1

"Bruch" %in% class(b)
inherits(b, "Bruch")

"+.Bruch" <- function(bruch1, bruch2) {
  if (!inherits(bruch1, "Bruch")) {
    bruch1 <- Bruch(bruch1, nenner = 1)  # Versuche Bruch zu erstellen
  }
  if (!inherits(bruch2, "Bruch")) {
    bruch2 <- Bruch(bruch2, nenner = 1)  # Versuche Bruch zu erstellen
  }
	
  nenner <- bruch1[2] * bruch2[2]
  zaehler <- bruch1[1] * bruch2[2] + bruch2[1] * bruch1[2]
  return(Bruch(zaehler, nenner))
}

b1 + 2   # klappt einwandfrei
2 + b1   # klappt einwandfrei


5.5 + 2/1   # Funktioniert immer noch!
5.5 + b1    # Fehlermeldung: 5.5 ist nicht ganzzahlig.


"<.Bruch" <- function(bruch1, bruch2) {
  return(bruch1[1] * bruch2[2] < bruch2[1] * bruch1[2])
}

">=.Bruch" <- function(bruch1, bruch2) {
  return(bruch2 < bruch1)
}

b1
b2

b1 < b2
b1 >= b2


### -------------------------------------------------------------------------
### 30.6.2  Fallbeispiel: Auswertung von Polynomen


polynom <- function(beta) {
	
  # Gibt eine Funktion zurueck, die das Polynom
  # f(x) = beta[1] + beta[2] * x +
  #        beta[3] * x^2 + ... + beta[n] * x^(n-1)
  # auswertet.
	
  # Definiere die Funktion, die zurueckgegeben wird.
  fun <- function(x) {
	
    # Berechnet die Funktionswerte des zugrundeliegenden
    # Polynoms fuer jedes x.
	
    # Berechne fuer jedes x den Funktionswert 
    res <- sapply(x, function(u) {
      y <- u ^ (0:(length(beta) - 1))  # u enthält ein Element von x
      return(sum(beta * y))            # y enthält u^0, u^1, u^2 etc.
    })
	
    # Gebe die Funktionswerte zurueck
    return(res)
  }
	
  # Gebe die Funktion zurueck
  return(fun)
}

beta <- c(0, 1)

# Kann jetzt Polynom berechnen.
polyfun <- polynom(beta = c(-1, 1, 2))

# polyfun ist eine function
is.function(polyfun)

# polyfun hat Mode function
mode(polyfun)

polyfun(x = 0:2)


fun <- function(x) {
  res <- sapply(x, function(u) {
    y <- u ^ (0:(length(beta) - 1))
    return(sum(beta * y))
  })
	
  return(res)
}

polynom.neu <- function(beta) {
  return(fun)
}

beta <- c(0, 1)
polyfun.neu <- polynom.neu(beta = c(-1, 1, 2))

polyfun.neu(x = 0:2)  # beta <- c(0, 1) wird herangezogen
polyfun(x = 0:2)      # beta = c(-1, 1, 2) wird herangezogen


polyfun <- function(x, beta) {
  res <- sapply(x, function(u) {
    y <- u ^ (0:(length(beta) - 1))
    return(sum(beta * y))
  })
  return(res)
}

polyfun.effizient <- function(x, beta) {
  y <- rep(x, each = length(beta)) ^ (0:(length(beta) - 1))
  M <- matrix(beta * y, ncol = length(beta), byrow = TRUE)
  return(rowSums(M))
}

beta <- c(-1, 1, 2)

polyfun(x = 0:2, beta)
polyfun.effizient(x = 0:2, beta)


x <- sample(-10:10, size = 10000000, replace = TRUE)

# Ineffiziente Variante
# res <- polyfun(x, beta)

# Effiziente Variante
# res <- polyfun.effizient(x, beta)



### -------------------------------------------------------------------------
### 30.7  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 30.7.3  Übungen


# Lösche Objekte
rm(v, w, x, y, z)

w <- 1
x <- 2
y <- 3
z <- 4

fun <- function(x = 5, y) {
  v <- 0
  w <- -1
  return(v + w + x + y + z)
}


geschlecht <- c("w", "m", NA, "m", "w", "w", "w", "m", "m", "m")
groesse <- c(176, 181, 181, 183, 163, 157, 164, 166, 176, 184)
gewicht <- c(65, 92, 65, 93, 49, 47, NA, 50, 62, 84)

daten <- data.frame(geschlecht, groesse, gewicht)
