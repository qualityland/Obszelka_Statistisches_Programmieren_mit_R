### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 29: Eigene Funktionen: Grundlagen
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 29.1  Eigene Funktionen schreiben -- function
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 29.1.3  Rückgabe -- return(), invisible()


# return-Rückgabe
f1 <- function(x) {
  return(x)
  print("unreachable")
}
f1(1:5)
res <- f1(1:3)
res

# letzter Ausdruck
f2 <- function(x) {
  mode(x)
  x
}
f2(1:5)
res <- f2(1:3)
res

# invisible-Rückgabe
f3 <- function(x) {
  mode(x)
  invisible(x)
}
f3(1:5)

res <- f3(1:3)
res


quadratgleichung <- function(a, b, c) {
  res <- (-b + c(-1, 1) * sqrt(b^2 - 4 * a * c)) / (2 * a)
  return(res)
}

# Funktion für a = 2, b = -5, c = 3 aufrufen
quadratgleichung(2, -5, 3)


is.symmetric <- function(X) {
  if (all(X == t(X))) {
    ergebnis <- TRUE
  }
  else {
    ergebnis <- FALSE
  }
  return(ergebnis)
}

is.symmetric <- function(X) {
  if (all(X == t(X)))
    return(TRUE)
  return(FALSE)
}

M1 <- cbind(c(4, 0), c(0, 3))
M1
is.symmetric(M1)

M2 <- cbind(c(4, 0), c(1, 3))
M2
is.symmetric(M2)

# Übergebe is.symmetric() einen Vektor
is.symmetric(1:10)



### -------------------------------------------------------------------------
### 29.2  Fehlermeldungen und Warnungen -- stop(), warning()
### -------------------------------------------------------------------------


is.symmetric <- function(X) {
  text <- "\nX muss eine quadratische Matrix sein."

  if (!is.matrix(X)) {
    stop(text)   # Keine Matrix => Fehler!
  }

  # Wir wissen: X ist eine Matrix => ncol und nrow existieren
  if (ncol(X) != nrow(X)) {
    stop(text)   # Keine quadratische Matrix => Fehler!
  }

  if (all(X == t(X))) {
    return(TRUE)
  }
  return(FALSE)
}

# Übergebe einen Vektor
is.symmetric(1:10)

Temp <- rbind(1:3, 2:4)
Temp

# Übergebe nichtquadratische Matrix
is.symmetric(Temp)



### -------------------------------------------------------------------------
### 29.3  Bedingungen verknüpfen zum Zweiten -- "&&", "||"
### -------------------------------------------------------------------------


is.symmetric <- function(X) {
  if (is.matrix(X) & nrow(X) == ncol(X)) {
    if (all(X == t(X))) {
      return(TRUE)
    }
    else {
      return(FALSE)
    }
  }
  stop("\nX muss eine quadratische Matrix sein.")
}

# Übergebe einen Vektor
is.symmetric(1:10)

X <- 1:10
nrow(X)
nrow(X) == ncol(X)
is.matrix(X) & nrow(X) == ncol(X)

X <- 1:10
is.matrix(X) && nrow(X) == ncol(X)


is.symmetric <- function(X) {
  if (is.matrix(X) && nrow(X) == ncol(X)) {
    if (all(X == t(X))) {
      return(TRUE)
    }
    else {
      return(FALSE)
    }
  }
  stop("\nX muss eine quadratische Matrix sein.")
}

# Übergebe einen Vektor
is.symmetric(1:10)



### -------------------------------------------------------------------------
### 29.4  Parameter und Argumente
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 29.4.1  Statische Defaultwerte und Wrapper-Funktionen


norm <- function(x, p = 2) {
  if (!is.vector(x) || !is.numeric(x))
    stop("\nx muss ein numerischer Vektor sein!")
  return(sum(abs(x)^p) ^ (1/p))
}

# Verwende Defaultwert p = 2
norm(1:4)

# Spezifiziere p = 1
norm(1:4, p = 1)


# Wrapper für Betragsnorm
norm1 <- function(x) {
  return(norm(x, p = 1))
}

# Wrapper für euklidische Norm
norm2 <- function(x) {
  return(norm(x, p = 2))
}

# norm1()
norm1(1:4)

# norm() mit p = 1
norm(1:4, p = 1)


# Wrapper für p = 1
norm1 <- function(x) {
  return(sum(abs(x)))
}

# Wrapper für p = 2
norm2 <- function(x) {
  return(sum(x^2)^(1/2))
}

# Masterfunktion norm
norm <- function(x, p = 2) {
  if (!is.vector(x) || !is.numeric(x))
    stop("\nx muss ein numerischer Vektor sein!")
  if (p == 1) return(norm1(x))
  if (p == 2) return(norm2(x))
  return(sum(abs(x)^p) ^ (1/p))
}


### -------------------------------------------------------------------------
### 29.4.2  Dynamische Defaultwerte


rwuerfel <- function(n, seiten = 6, prob = rep(1, seiten)) {
  return(sample(1:seiten, size = n, replace = TRUE, prob = prob))
}

# n = 10, 6 Seiten
rwuerfel(10)

# n = 2, 2 Seiten
rwuerfel(10, seiten = 2)


### -------------------------------------------------------------------------
### 29.4.3  Unspezifizierte Parameter


mittelwert <- function(x, weights, na.rm = TRUE) {
  # Keine Gewichte -> gewöhnliches Mittel
  if (missing(weights))
    return(mean(x, na.rm = na.rm))

  # Jetzt wissen wir: weights ist spezifiziert.
  # Längen müssen übereinstimmen.
  if (length(weights) != length(x)) {
    stop("\nweights hat nicht die selbe Länge wie x!")
  }

  # Falls na.rm TRUE ist, entferne fehlende Werte
  if (na.rm) {
    weights <- weights[!is.na(x)]
    x <- x[!is.na(x)]
  }

  # Ergebnis berechnen und zurückgeben
  return(sum(x * weights / sum(weights)))
}

# Ohne Gewichte und mit NA
mittelwert(c(1:3, NA))

# Mit Gewichten
mittelwert(1:3, c(4, 1, 1))

# x und gewichte ungleich lang
mittelwert(1:3, c(4, 1, 1, 1))


### -------------------------------------------------------------------------
### 29.4.4  Objekte switchen -- switch()


mittel <- function(x, type = "arith", na.rm = TRUE) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }

  ergebnis <- switch(type, 
    arith = mean(x),
    geom  = prod(x)^(1/length(x)),
    harm  = length(x) / sum(1/x),
    quadr = sqrt(mean(x^2)),
    NULL   # falls type zu keiner linken Seite passt
  )

  if (is.null(ergebnis)) {
    warning("type ungültig! Gebe arithmetisches Mittel zurück.")
    ergebnis <- mean(x)
  }

  return(ergebnis)
}

# Beispielanwendungen für unsere Funktion mittel()
x <- c(60, 120)

mittel(x)
mittel(x, "geom")
mittel(x, "harm")
mittel(x, "quadr")

# Übergebe ungültigen type
mittel(x, "Mich gibt es nicht")


fun <- function(type) {
  switch(type, "1" = "typ1", "2" = "typ2", "typUnbekannt")
}

fun(1)
fun(2)
fun(3)


### -------------------------------------------------------------------------
### 29.4.5  Das Dreipunkteargument -- ..., list(...)


a <- 2
b <- 5

# Übergebe 6 Elemente
paste("Das Ergebnis von ", a, " + ", b, " ist ", a + b, sep = "")

# Übergebe 2 Elemente
paste(c("a", "b"), c(a, b), sep = " = ", collapse = " und ")

# collapse muss exakt benannt werden!
paste(c("a", "b"), c(a, b), sep = " = ", coll = " und ")


M <- matrix(1:6, ncol = 3)
M

# 20%- und 80%-Quantil für jede Spalte
apply(M, 2, quantile, probs = c(0.2, 0.8))

# Jede Spalte absteigend sortieren
apply(M, 2, sort, decreasing = TRUE)


fun <- function(...) {
  args <- list(...)  # packe alle Elemente in eine Liste
  print(args)        # drucke die Liste auf die Console

  cat("Folgende Argumente für ... übergeben:\n")
  cat(paste0(1:length(args), ".) ", names(args), collapse = "\n"))
  cat("\n")
}

fun(x = 1:5, na.rm = TRUE)

fun(x = 2, y = 5:8, f = sum)



### -------------------------------------------------------------------------
### 29.5  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 29.5.1  Programmierstil: Funktionskommentare


rwuerfel <- function(n, seiten = 6, prob = rep(1, seiten)) {

  # Gibt n zufaellige Wuerfelwuerfe zurueck.
  # n ........ Die Anzahl der gewuenschten Wuerfelwuerfe.
  # seiten ... Die Anzahl der Seiten des Wuerfels.
  # prob ..... Die Wahrscheinlichkeitsgewichte. Standardgemaess
  #            hat jede Seite die gleiche Wahrscheinlichkeit.

  return(sample(1:seiten, size = n, replace = TRUE, prob = prob))
}


mittel <- function(x, type = "arith", na.rm = TRUE) {

  # Diese Funktion berechnet verschiedene Mittelwerte
  # für den Vektor x
  # x ....... numerischer Datenvektor
  # type .... Welcher Mittelwert soll berechnet werden?
  #           "arith": arithmetisches Mittel (default)
  #           "geom": geometrisches Mittel
  #           "harm": harmonisches Mittel
  #           "quadr": quadratisches Mittel
  # na.rm ... TRUE: NA-Einträge werden entfernt, sonst nicht

  if (na.rm) {
    x <- x[!is.na(x)]
  }  

  ergebnis <- switch(type, 
    arith = mean(x),
    geom  = prod(x)^(1/length(x)),
    harm  = length(x) / sum(1/x),
    quadr = sqrt(mean(x^2)),
    NULL
  )

  if (is.null(ergebnis)) {
    warning("type ungültig! Gebe arithmetisches Mittel zurück.")
    ergebnis <- mean(x)
  }

  return(ergebnis)
}


### -------------------------------------------------------------------------
### 29.5.2  Fallbeispiel: Bisektion


bisektion <- function(f, intervall, eps = 10^(-9)) {
  # Gibt eine Liste mit einer Nullstelle von f und dem Funktionswert
  # an dieser Stelle zurueck.
  # f ........... Objekt vom Typ function, gibt reelle Zahl zurück
  # intervall ... Intervall, in dem gesucht werden soll.
  # eps ......... Rechengenauigkeit

  links <- min(intervall)
  rechts <- max(intervall)

  # Checke Vorzeichenbedingung
  if (f(links) * f(rechts) > 0)
    stop("Kein Vorzeichenwechsel im übergebenen Intervall!")

  mitte <- (links + rechts) / 2

  # Solange die absolute Abweichung von f(mitte) > eps
  while(abs(f(mitte)) > eps) {
    if (f(mitte) * f(links) > 0) {
      # Vorzeichen wechselt nicht
      links <- mitte
    }
    else {
      # Vorzeichen wechselt
      rechts <- mitte
    }
    mitte <- (links + rechts) / 2
  }

  # Gebe Liste zurück mit der näherungsweisen Nullstelle und 
  # dem Funktionswert.
  return(list(Nullstelle = mitte, Funktionswert = f(mitte)))
}

# Berechne die Wurzel aus 2
fun <- function(x) x^2 - 2
bisektion(fun, intervall = c(0, 2))

# Zur Kontrolle
sqrt(2)



### -------------------------------------------------------------------------
### 29.6  Environments und Scoping
### -------------------------------------------------------------------------


zeilen <- 2
spalten <- 5

# Funktion, die eine Matrix generiert und zurückgibt.
hugo <- function(spalten) {
  zeilen <- zeilen + 1
  spalten <- spalten + 1
  M <- matrix(ncol = spalten, nrow = zeilen)
  return(M)
}

hugo(spalten = spalten)  # 2 + 1 = 3 Zeilen, 5 + 1 = 6 Spalten

zeilen   # Nicht auf 3 erhöht
spalten  # Nicht auf 6 erhöht

hugo()   # spalten hat keinen Standardwert.



### -------------------------------------------------------------------------
### 29.7  Funktionen überschreiben -- "::", rm()
### -------------------------------------------------------------------------


# Die wohlbekannte Funktion mean() aus dem Paket base
mean(1:3)

# Überschreibe die Funktion mean()
mean <- function(x) {
  return("Mittelwert")
}

mean(1:3)


# Unsere Funktion
mean(1:3)

# Funktion des Pakets base
base::mean(1:3)

mean(1:3)

# Lösche unsere Funktion
rm(mean)

# Jetzt wieder Zugriff auf Funktion im Paket base
mean(1:3)



### -------------------------------------------------------------------------
### 29.8  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 29.8.3  Übungen


sum <- function(..., na.rm = TRUE) {
  # ... und na.rm werden an base::sum() weitergereicht.
  base::sum(..., na.rm)
}

sum(1:4)
sum(c(1:4, NA))

rm(sum)   # ACHTUNG: Lösche unsere Funktion wieder!
