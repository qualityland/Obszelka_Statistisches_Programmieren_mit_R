### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 18: Wiederholte Funktionsanwendung bei Listen
### -------------------------------------------------------------------------


pizzen <- list(
    Margherita  = c("Tomaten", "Kaese"),
    Cardinale   = c("Tomaten", "Kaese", "Schinken"),
    "San Romio" = c("Tomaten", "Kaese", "Schinken", "Salami", "Mais"),
    Provinciale = c("Tomaten", "Kaese", "Schinken", "Mais", "Pfefferoni"))

pizzen



### -------------------------------------------------------------------------
### 18.1  Wiederholte Funktionsanwendung auf Elemente einer Datenstruktur --
###       lapply(), sapply()
### -------------------------------------------------------------------------


# Anzahl der Zutaten jeder Pizza bestimmen
anz.zutaten <- c(length(pizzen[[1]]), length(pizzen[[2]]),
                 length(pizzen[[3]]), length(pizzen[[4]]))
names(anz.zutaten) <- names(pizzen)
anz.zutaten


# Bestimme die Anzahl der Zutaten jeder Pizza
# Bestimme die Länge von jedem Listenelement (Vektor) von pizza
sapply(pizzen, FUN = length)


# lapply() gibt immer
# eine Liste zurück!
lapply(pizzen, FUN = length)

# sapply(): Vereinfachung abstellen
sapply(pizzen, FUN = length,
  simplify = FALSE)

# Vereinfachung des Ergebnisobjektes (hier in einen Vektor)
sapply(pizzen, FUN = length)



### -------------------------------------------------------------------------
### 18.2  Parameterübergabe innerhalb von sapply() und lapply()
### -------------------------------------------------------------------------


# Aufsteigend sortieren

lapply(pizzen, FUN = sort)

# Absteigend sortieren
lapply(pizzen, FUN = sort,
  decreasing = TRUE)

sort(pizzen[[1]], decreasing = TRUE)   # Aufruf für die erste Pizza
sort(pizzen[[2]], decreasing = TRUE)   # Aufruf für die zweite Pizza


lapply(list(TRUE, FALSE), FUN = sort, x = 1:3)

# Aufruf für 1. Element
sort(TRUE, x = 1:3)

# Aufruf für 2. Element
sort(FALSE, x = 1:3)


lapply(list(TRUE, FALSE), FUN = sort, 1:3)

# Aufruf für 1. Element
sort(TRUE, 1:3)

# Aufruf für 2. Element
sort(FALSE, 1:3)



### -------------------------------------------------------------------------
### 18.3  Operatoren als Funktion verwenden
### -------------------------------------------------------------------------


pizzen[["Provinciale"]]

# "==" als Operator anwenden
pizzen[["Provinciale"]] == "Schinken"

# "==" als Funktion anwenden
"=="(x = pizzen[["Provinciale"]], y = "Schinken")


lapply(pizzen, FUN = "==", y = "Schinken")


bool.schinken <- lapply(pizzen, FUN = "==", y = "Schinken")

# Auf welchen Pizzen befindet sich Schinken?
bool.res <- sapply(bool.schinken, any)
bool.res

names(bool.res)[bool.res]


bool <- lapply(pizzen, FUN = "%in%", table = c("Schinken", "Mais"))
bool

# Welche Pizzen sind mit Schinken und Mais belegt?
bool.sum <- sapply(bool, sum)
bool.sum

names(bool.res)[bool.sum == 2]



### -------------------------------------------------------------------------
### 18.4  Vereinfachung der Datenstruktur bei sapply()
### -------------------------------------------------------------------------


liste <- list(A = 1:4, B = 1:3)
liste

sapply(liste, max)   # Vektor: max() gibt immer einen Skalar zurück.

sapply(liste, range) # Matrix: range() gibt 2-elementigen Vektor zurück.

sapply(liste, rev)   # Liste: rev() erzeugt hier ungleich lange Vektoren.



### -------------------------------------------------------------------------
### 18.5  sapply() und lapply() bei Vektoren und Matrizen
### -------------------------------------------------------------------------


# sapply() bei Vektoren
sapply(-2:2, max, 0)   # pmax(-2:2, 0) ist deutlich effizienter!

sapply(c(TRUE, FALSE), sort, x = 1:3)

# sapply() bei Matrizen
M <- matrix(1:9, ncol = 3)
M

sapply(M, sum)



### -------------------------------------------------------------------------
### 18.6  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 18.6.2  Ausblick


sapply(c(TRUE, FALSE), sort, x = 1:3)
vapply(c(TRUE, FALSE), sort, FUN.VALUE = c(0, 0, 0), x = 1:3)
mapply(sort, decreasing = c(TRUE, FALSE), MoreArgs = list(x = 1:3))


### -------------------------------------------------------------------------
### 18.6.3  Übungen


pizzen


x <- list(c("L", "E", "A"), c("I", "S", "S", "T"),
          c("E", "I", "E", "R"))
x
