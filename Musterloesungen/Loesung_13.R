### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 13
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Der Ausdruck ist TRUE. Denn 0.375 kann exakt mit 2er-Potenzen dargestellt
# werden:
2^-2 + 2^-3
5.375 - 0.375 == 5



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


### a)

k <- 1:1000
x = (2^(1/k))^k


### b)

# Den Zielwert (2) muessen wir auf dieselbe Laenge bringen wie x.
all.equal(rep(2, length(k)), x)


### c)

# Das in all.equal() verwendete epsilon
# ?all.equal
eps <- .Machine$double.eps^0.5
eps

# Pruefung auf annaehernde Gleichheit
all(abs(x - 2) < eps)


### Zusatzfrage
sum(x == 2)

# Nur wenige Elemente gleichen exakt 2!

