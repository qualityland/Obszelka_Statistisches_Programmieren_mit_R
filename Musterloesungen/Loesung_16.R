### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 16
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


D <- matrix(1:16, ncol = 4)
D


### a)

# Quadratisch, wenn die Anzahl der Zeilen gleich der Anzahl der Spalten
nrow(D) == ncol(D)


### b)

spur <- sum(diag(D))
spur


### c)

# Der Code multipliziert die Diagonalelemente mit TRUE (1) und alle anderen
# Elemente mit FALSE (0)
D * (row(D) == col(D))

# Alternativ
diag(diag(D))


### d)

# Matrix mit den Spalten- und Zeilenindizes von D
col(D)
row(D)

# Obere Dreiecksmatrix: Spaltenindex ist größer (gleich) Zeilenindex
col(D) > row(D)

D * (col(D) > row(D))   # Ohne Diagonalelemente
D * (col(D) >= row(D))  # Mit Diagonalelementen

# Alternativen:
D * upper.tri(D)
D * upper.tri(D, diag = TRUE)


# Analog funktioniert das fuer untere Dreiecksmatrizen
# Untere Dreiecksmatrix: Spaltenindex ist kleiner (gleich) Zeilenindex

D * (col(D) < row(D))   # Ohne Diagonalelemente
D * (col(D) <= row(D))  # Mit Diagonalelementen

# Alternativen:
D * lower.tri(D)
D * lower.tri(D, diag = TRUE)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


X <- matrix(c(1, 3, 5, 7), ncol = 2)
X


### a)

X.inv <- solve(X)
X.inv


### b)

# Bei der Matrixmultiplikation entsteht ein kleiner Rundungsfehler
X %*% X.inv

# Daher ist keine exakte Gleichheit gegeben
all(X %*% X.inv == diag(2))


### c)

# Variante 1: Mit all.equal()
all.equal(X %*% X.inv, diag(2))

# Variante 2: Ohne all.equal()
# Die Genauigkeit erfahren wir aus der R-Hilfe zu all.equal().
eps <- .Machine$double.eps ^ 0.5
temp <- X %*% X.inv - diag(2)
all(abs(temp) < eps)

