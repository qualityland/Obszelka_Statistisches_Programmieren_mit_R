### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 17: Listen
### -------------------------------------------------------------------------


X <- matrix(c(2, 1, -2, 0, 0.5, 0, 2, 4, 7), ncol = 3)
X



### -------------------------------------------------------------------------
### 17.1  Eigenwerte und Eigenvektoren -- eigen()
### -------------------------------------------------------------------------


# Berechne Eigenwerte und Eigenvektoren von X
X.eigen <- eigen(X)
X.eigen



### -------------------------------------------------------------------------
### 17.2  Überblick über Listen -- is.list(), mode(), str(), length()
### -------------------------------------------------------------------------


# Abfrage auf list
is.list(X.eigen)

# Alternative Abfrage auf list
mode(X.eigen) == "list"


# Eigenschaften von X.eigen abfragen
str(X.eigen)
length(X.eigen)



### -------------------------------------------------------------------------
### 17.3  Subsetting und Names -- "$", "[ ]", "[[ ]]", names()
### -------------------------------------------------------------------------


# Names einer Liste extrahieren
names(X.eigen)


# Eigenwerte extrahieren und Maximum bestimmen - so klappt es nicht.
X.val <- X.eigen["values"]    # tendenziell robuster als X.eigen[1]
X.val

max(X.val)


# Eigenwerte selektieren und Maximum bestimmen - so geht's.
X.val <- X.eigen[["values"]]  # tendenziell robuster als x.eigen[[1]]
X.val

max(X.val)


# Zugriff auf vectors
X.eigen$vectors

# Zugriff auf values (val)
X.eigen$val
# Keine eindeutige Abkürzung
X.eigen$v 


# Zugriff auf die ersten beiden Elemente der Liste X.eigen
X.eigen[[1:2]]   # So geht es nicht!

# Zugriff mit Indizes
X.eigen[1:2]

# Alternative mit Names
X.eigen[c("values", "vectors")]


# Sortierung von A bis Z
temp <- order(names(X.eigen))

X.eigen[temp]


# Sortierung von Z bis A
temp <- order(names(X.eigen),
  decreasing = TRUE)
X.eigen[temp]



### -------------------------------------------------------------------------
### 17.4  Listen erstellen und initialisieren -- list(), vector("list")
### -------------------------------------------------------------------------


# Erstelle eine unbefüllte Liste mit 2 Elementen
vector(mode = "list", length = 2)


# Verschachtelte Liste erstellen

X.liste <- list(eigen = eigen(X),
  dim = dim(X), diag = diag(X))
X.liste
length(X.liste)

X.liste <- list(
  eigen = unclass(eigen(X)),
  dim = dim(X), diag = diag(X))
X.liste
length(X.liste)


# Selektiere aus X.liste die Eigenwerte
X.liste$eigen$values

# Rekursiver Zugriff auf die Eigenwerte
X.liste[[c("eigen", "values")]]
X.liste[["eigen"]][["values"]]



### -------------------------------------------------------------------------
### 17.5  Atomare und rekursive Objekte -- is.atomic(), is.recursive(),
###       is.vector()
### -------------------------------------------------------------------------


# Ist X.liste ein Vektor?
is.vector(X.liste)


# Extrahiere den Vektor mit den Eigenwerten
X.val <- X.eigen$val
X.val

is.atomic(X.liste)
is.recursive(X.liste)

is.atomic(X.val)
is.recursive(X.val)


# Abfrage auf "echten" Vektor - 1. Technik
is.vector(X.val) & is.atomic(X.val)
is.vector(X.liste) & is.atomic(X.liste)

# Abfrage auf "echten" Vektor - 2. Technik
is.vector(X.val, mode = "numeric")
is.vector(X.liste, mode = "numeric")



### -------------------------------------------------------------------------
### 17.6  Elemente hinzufügen, löschen und ersetzen -- c(), NULL
### -------------------------------------------------------------------------


# Spur hinzufügen
X.liste <- c(X.liste,
  spur = sum(diag(X.liste$diag)))
X.liste

# Determinante zusätlich hinzufügen
X.liste[["det"]] <- det(X)
X.liste$det <- det(X) # Alternative
X.liste

# Lösche zunächst eigen und dim
X.liste[c("eigen", "dim")] <- NULL
X.liste

# Lösche noch diag
X.liste$diag <- NULL  # oder X.liste[["diag"]] <- NULL
X.liste

# Ersetze Element spur durch NULL-Eintrag
X.liste["spur"] <- list(NULL)
X.liste

# Ersetze Element spur durch den Vektor 1:3
X.liste[["spur"]] <- 1:3
X.liste



### -------------------------------------------------------------------------
### 17.7  Listen zu Vektoren vereinfachen -- unlist()
### -------------------------------------------------------------------------


# Die Liste "unlisten" (make a list "flat")
X.vektor <- unlist(X.liste)
X.vektor


# Liste mit unterschiedlichen Modes
liste <- list(Zahl = c(1, 2, 7, 3), Bool = c(TRUE, FALSE))
liste

# Konvertierung bei Überführung in eine Liste
unlist(liste)
