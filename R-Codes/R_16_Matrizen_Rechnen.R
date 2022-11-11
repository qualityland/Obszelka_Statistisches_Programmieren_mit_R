### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 16: Rechnen mit Matrizen und Lineare Algebra
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 16.1  Diagonalmatrizen und Diagonalelemente -- diag()
### -------------------------------------------------------------------------


# 3-dimensionale Einheitsmatrix
diag(3)

# Diagonalmatrix mit 1:3
diag(1:3)


# Generiere eine Matrix D ...
D <- matrix(1:9, ncol = 3)
D

# ... und selektiere ihre Diagonalelemente
diag(D)

# Ersetzen der Diagonalelemente
diag(D) <- c(10, 11, 12)
D


# Diagonalmatrix aus den Diagonalelementen generieren
diag(diag(D))



### -------------------------------------------------------------------------
### 16.2  Rechnen mit Matrizen
### -------------------------------------------------------------------------


# Beispielmatrizen definieren
A <- cbind(c(1, 1), c(3, 2))
A
B <- cbind(c(-2, 2), c(2, -1))
B


### -------------------------------------------------------------------------
### 16.2.1  Elementweises Rechnen -- "+", "-", "*", "/", "^"


A + B
A * B
B ^ A
A * c(2, 3)


### -------------------------------------------------------------------------
### 16.2.2  Matrixmultiplikation -- "%*%", crossprod(), tcrossprod()


# Matrixmultiplikation
A %*% B

# A transponiert mal B
t(A) %*% B
crossprod(A, B)

# A mal B transponiert
A %*% t(B)
tcrossprod(A, B)


### -------------------------------------------------------------------------
### 16.2.3  Invertierung und Determinante -- solve(), det()


# Die Matrix A
A

# A invertieren
solve(A)

# A mal A^(-1)
A %*% solve(A)

# Determinante von A
det(A)



### -------------------------------------------------------------------------
### 16.3  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 16.3.1  Fallbeispiel: Lineare Regression


# Die Daten (verwenden hier eine Doppelzuweisung)
x <- groesse <- c(184, 168, 160, 168, 170, 168, 163, 170)
y <- gewicht <- c(65, 70, 48, 52, 53, 56, 56, 59)

# Matrix X erstellen: Erste Spalte modelliert das Interzept.
X <- cbind(1, x)
X

# OLS-Schätzer berechnen 
beta.hat <- solve(crossprod(X)) %*% crossprod(X, y)
as.vector(beta.hat)   # Interzept und Steigung

# Prognostizierte Werte berechnen 
y.hat <- as.vector(X %*% beta.hat)
y.hat

# Residuen berechnen 
u.hat <- y - y.hat
round(u.hat, digits = 4)


### -------------------------------------------------------------------------
### 16.3.2  Fallbeispiel: Lineare Gleichungssysteme lösen -- solve()


# Parameter definieren
A <- matrix(c(3, 1, 4, 2), ncol = 2)
b <- c(2, 0)

# Löse das lineare Gleichungssystem A x = b 
res <- solve(A) %*% b
res

# Lösung als Vektor ausgeben
as.vector(res)


S <- matrix(rep(1, 4), ncol = 2)
S    # S ist offensichtlich nicht invertierbar.

# Inverse einer nicht invertierbaren Matrix
solve(S)


# Löse Gleichungssystem Ax = b direkt mit solve()
solve(A, b)



### -------------------------------------------------------------------------
### 16.4  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 16.4.3  Übungen


D <- matrix(1:16, ncol = 4)
D

D * (row(D) == col(D))
