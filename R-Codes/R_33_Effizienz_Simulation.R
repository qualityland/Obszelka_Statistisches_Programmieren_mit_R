### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 33: Effizienz
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 33.1  Laufzeitmessung: Spaltenmittelwerte einer Matrix
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 33.1.1  Messung mittels Stoppuhr -- Sys.time()


n <- 10     # Anzahl der Zeilen
k <- 10^7   # Anzahl der Spalten

# Matrix generieren
matrix <- matrix(sample(1:100, size = n * k, replace = TRUE), ncol = k)


# Variante 1: apply()
{
  zeit1 <- Sys.time()
  apply(matrix, 2, mean)
  zeit2 <- Sys.time()
}

zeit2 - zeit1   # Zeitdifferenz bestimmen


# Variante 2a: for-Schleife mit NULL-Initialisierung
{
  zeit1 <- Sys.time()
  z <- NULL
  for (j in 1:ncol(matrix)) {
    z[j] <- mean(matrix[, j])
  }
  zeit2 <- Sys.time()
}

zeit2 - zeit1   # Zeitdifferenz bestimmen


# Variante 2b: for-Schleife mit besserer Initialisierung
{
  zeit1 <- Sys.time()
  z <- numeric(k)   # besser als NULL!
  for (j in 1:ncol(matrix)) {
    z[j] <- mean(matrix[, j])
  }
  zeit2 <- Sys.time()
}

zeit2 - zeit1   # Zeitdifferenz bestimmen


# Variante 3: colMeans()
{
  zeit1 <- Sys.time()
  colMeans(matrix)
  zeit2 <- Sys.time()
}

zeit2 - zeit1   # Zeitdifferenz bestimmen


### -------------------------------------------------------------------------
### 33.1.2  Messung der CPU-Zeit: system.time()


system.time(colMeans(matrix))
system.time(apply(matrix, 2, mean))



### -------------------------------------------------------------------------
### 33.2  Beispiel: Dreiecksdichte auswerten
### -------------------------------------------------------------------------


x <- seq(-1.5, 1.5, by = 0.5)
x


ddreieck1 <- function(x) {
  return(max(0, 1 - abs(x)))
}

ddreieck1(x)


ddreieck2 <- function(x) {
  res <- sapply(x, function(z) {
    max(0, 1 - abs(z))
  } )
	
  return(res)
}

ddreieck2(x)


ddreieck3 <- function(x) {
  res <- numeric(length(x))
	
  for (i in 1:length(x))
    res[i] <- max(0, 1 - abs(x[i]))
	
  return(res)
}

ddreieck3(x)


ddreieck4 <- function(x) {
  z <- 1 - abs(x)
  return(ifelse(z >= 0, z, 0))
}

ddreieck4(seq(-1, 1, length = 5))


ddreieck5 <- function(x) {
  pmax(0, 1 - abs(x))   # 0 wird ggf. recycelt
}

ddreieck5(seq(-1, 1, length = 5))



### -------------------------------------------------------------------------
### 33.3  Laufzeitvergleiche
### -------------------------------------------------------------------------


# Liste der Funktionen und Vektor der Vektorlängen.
funktionen <- list(ddreieck2, ddreieck3, ddreieck4, ddreieck5)
laengen <- c(10000, 100000, 1000000, 10000000)

# Wissenschaftliche Notation unterdrücken. 
optalt <- options(scipen = 10000000)

# Gehe alle Vektorlängen durch
erg <- sapply(laengen, function(k) {
	
  # Erstelle Testvektor
  werte <- seq(-2, 2, length = k + 1)
	
  # Gehe alle Funktionen durch
  res <- sapply(funktionen, function(fun) {
    return(system.time(fun(werte))[3])
  })
	
  return(res)
})

erg <- t(erg)    # Hier muss transponiert werden
colnames(erg) <- paste("ddreieck", 2:5, "()", sep = "")
rownames(erg) <- paste("k =", laengen)

erg
options(optalt)  # Optionen zurücksetzen


### Fundierter Laufzeitvergleich

# Wissenschaftliche Notation unterdrücken. 
optalt <- options(scipen = 1000000000)

N <- 20          # Anzahl der Durchgänge (je mehr desto genauer)

# Array mit 3 Dimensionen erstellen
Zeit <- array(dim = c(length(laengen), length(funktionen), N))
colnames(Zeit) <- paste("ddreieck", 2:5, "()", sep = "")
rownames(Zeit) <- paste("k =", laengen)

for (i in 1:N) {
  # Erzeuge den i. von N Versuchen
  for (k in 1:length(laengen)) {
    # Gehe alle Problemgrössen durch
    werte <- seq(-2, 2, length = laengen[k] + 1)
    for (j in 1:length(funktionen)) {
      # Gehe alle Funktionen durch
      Zeit[k, j, i] <- system.time(funktionen[[j]](werte))[3]
    }
  }
}

# Aggregiere über die ersten beiden Dimensionen
mittelwerte <- apply(Zeit, MARGIN = 1:2, mean, simplify = FALSE)

# Darstellung der mittleren Laufzeiten
round(mittelwerte, 2)

# Optionen zurücksetzen
options(optalt)



### -------------------------------------------------------------------------
### 33.4  Beispiel: Zeilenminima einer Matrix
### -------------------------------------------------------------------------


nrow <- 10^7  # Anzahl der Zeilen
ncol <- 10    # Anzahl der Spalten

# Matrix mit gleichverteilten Zufallszahlen generieren
M <- matrix(runif(nrow * ncol), nrow = nrow, ncol = ncol)


zeit1 <- system.time(apply(M, MARGIN = 1, min))
zeit1


zeit2 <- system.time({
  res <- numeric(nrow)     # Denke an eine sinnvolle Initialisierung ;-)
  for (i in 1:nrow) {
    res[i] <- min(M[i, ])  # Minimum der i. Zeile berechnen
  }
})
zeit2


zeit3 <- system.time({
  res <- M[, 1]
	
  for (j in 2:ncol) {
    res <- pmin(res, M[, j])
  }
})
zeit3



### -------------------------------------------------------------------------
### 33.5  Beispiel: Würfelwurf -- Augensumme erreichen
### -------------------------------------------------------------------------


# Die Parameter
n <- 10^6  # Anzahl der Simulationsläufe
k <- 100   # gewünschte Augensumme


sim1 <- function(n, k) {
  res <- numeric(n)   # Ergebnisvektor initialisieren
	
  for (i in 1:n) {
    iter <- 0
    summe <- 0
	
    while (summe < k) {
      iter <- iter + 1
      summe <- summe + sample(1:6, size = 1)
    }
	
    res[i] <- iter
  }
	
  return(invisible(res))
}

time1 <- system.time(res.sim1 <- sim1(n, k))
time1

summary(res.sim1)   # Plausibilitätscheck


sim2 <- function(n, k) {
	
  # Definiere temporäre Funktion - wie oben
  tempfun <- function(k) {
    iter  <- 0  # zählt Würfelwürfe
    summe <- 0  # aktuelle Augensumme
	
    while (summe < k) {
      iter <- iter + 1
      summe <- summe + sample(1:6, size = 1)
    }
	
    res <- iter
    return(res)
  }
	
  # n Mal tempfun() ausführen und Ergebnisse zurückgeben
  res <- sapply(rep(k, n), tempfun)
  return(invisible(res))
}

time2 <- system.time(res.sim2 <- sim2(n, k))
time2

summary(res.sim2)   # Plausibilitätscheck


sim3 <- function(n, k) {
	
  # n x k Matrix mit Würfelwürfen
  Wurf <- matrix(sample(1:6, size = n * k, replace = TRUE), ncol = k)
	
  # Berechne kumulierte (Augen)Summen
  # Ergebnis ist k x n - Matrix (Warum?)
  temp <- apply(Wurf, 1, cumsum)
	
  # Zählen für jeden Durchgang, wie lange die Augensumme unter k bleibt
  # und zählen den entscheidenden Wurf mit + 1 dazu.
  res <- colSums(temp < k) + 1
	
  return(invisible(res))
}

time3 <- system.time(res.sim3 <- sim3(n, k))
time3

summary(res.sim3)   # Plausibilitätscheck


# Funktionsweise nachvollziehen
RNGversion("4.0.2")
set.seed(116952)

Wurf <- matrix(sample(1:6, size = 10 * 5, replace = TRUE), ncol = 5)
Wurf
temp <- apply(Wurf, 1, cumsum)
temp
colSums(temp < 5) + 1


sim4 <- function(n, k) {
	
  res <- numeric(n)   # Initialisiere Ergebnisvektor
  summe <- rep(0, n)  # Vektor der Augensummen
  iter <- 0           # Iterationszähler: Anzahl der Würfelwürfe
	
  while(any(summe < k)) {
    # bool markiert jene Elemente von summe, die noch kleiner als k sind
    # und bei denen noch mind. ein Würfelwurf erfolgen muss.
    bool <- summe < k
	
    # Einen weiteren Wurf hinzuaddieren
    iter <- iter + 1
    summe <- summe + sample(1:6, size = n, replace = TRUE)
	
    # bestimme jene Durchgänge, die vor dem Durchgang noch nicht fertig
    # waren (bool == TRUE) und die in diesem Durchgang die Augensumme von 
    # k erreicht oder überschritten haben (summe >= k).
    fertig <- bool & (summe >= k)
    res[fertig] <- iter
  }
	
  return(invisible(res))
}

time4 <- system.time(res.sim4 <- sim4(n, k))
time4

summary(res.sim4)   # Plausibilitätscheck


sim5 <- function(n, k) {
	
  res <- numeric(n)   # Initialisiere Ergebnisvektor
  summe <- rep(0, n)  # Vektor der Augensummen
  iter <- 0           # Iterationszähler: Anzahl der Würfelwürfe
	
  anz.fertig <- 0     # Anzahl der fertig simulierten Durchgänge
	
  while(length(summe) > 0) {
    # Solange summe Elemente enthält, gibt es noch Durchgänge, die 
    # weiterer Würfe bedürfen.
	
    # Einen weiteren Würfelwurf hinzuaddieren
    iter <- iter + 1
    summe <- summe + sample(1:6, size = length(summe), replace = TRUE)
	
    # Elemente bestimmen, die (in dieser Iteration) fertig geworden sind.
    bool <- summe >= k
    # Anzahl der Durchgänge, die gerade fertig geworden sind.
    m <- sum(bool)
	
    if (m > 0) {
      summe <- summe[!bool]
	
      # anz.fertig ist die Anzahl der fertig simulierten Durchgänge.
      # Also fangen wir beim folgenden Eintrag von res an und befüllen
      # m Einträge mit iter.
      res[(anz.fertig + 1):(anz.fertig + m)] <- iter
	
      # m Durchgänge fertig simuliert - zu anz.fertig dazuzählen
      anz.fertig <- anz.fertig + m
    }
  }
	
  return(invisible(res))
}

time5 <- system.time(res.sim5 <- sim5(n, k))
time5

summary(res.sim5)   # Plausibilitätscheck


# Fazit

str <- paste0("c(", paste0("time", 1:5, "[3]", collapse = ", "), ")")
str

# Umwandlung in eine expression
expr <- parse(text = str)
expr

# Ausführung der Expression
zeit <- eval(expr)
names(zeit) <- paste0("Variante", 1:length(zeit))
zeit

# Sortiere die Laufzeiten absteigend
zeit.sort <- sort(zeit, decreasing = TRUE)
zeit.sort



### -------------------------------------------------------------------------
### 33.6  Beispiel: Flächeninhalt zufälliger Dreiecke
### -------------------------------------------------------------------------


n <- 10^6

# flaeche() gibt einen Flächeninhalt zurück.
flaeche <- function() {
  M <- matrix(runif(4), ncol = 2)
  res <- abs(det(M)) / 2
  return(res)
}

# Ergebnisse simulieren
res <- rep(NA, n)

for (i in 1:n) {
  res[i] <- flaeche()
}

# Erwartungswert schätzen
13 / 108     # exaktes Ergebnis

mean(res)    # simuliert

# Varianz schätzen
229 / 23328  # exaktes Ergebnis

var(res)     # simuliert


flaeche1 <- function(n) {
  temp <- runif(n) * runif(n) - runif(n) * runif(n)
  res <- abs(temp) / 2
  return(res)
}

# Ergebnisse simulieren
res <- flaeche1(n)
res <- flaeche1(n = 10 * n)

# Erwartungswert schätzen
13 / 108     # exaktes Ergebnis

mean(res)    # simuliert

# Varianz schätzen
229 / 23328  # exaktes Ergebnis

var(res)     # simuliert



### -------------------------------------------------------------------------
### 33.8  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 33.8.3  Übungen


# Matrix generieren
n <- 10^6   # Anzahl der Zeilen
k <- 10     # Anzahl der Spalten
M <- matrix(sample(1:6, size = n * k, replace = TRUE), ncol = k)

# Code A
res <- NULL
i <- 0
while (i < nrow(M)) {
  i <- i + 1
  res <- c(res, sum(M[i, ]^2))
}

# Code B
res <- apply(M, 1, function(x) {
  return(sum(x^2))
})

# Code C
res <- rep(0, nrow(M))
for (i in 1:nrow(M)) {
  res[i] <- sum(M[i, ]^2)
}

# Code D
res <- rep(0, nrow(M))
for (j in 1:ncol(M)) {
  res <- res + M[, j]^2
}


# Beispielvektor
x <- c(3, 6, -8, 2, 4, -1)
x

y <- x
for (i in 1:length(x)) {
  if (i == 1) {
    y[i] <- sum(x[i:(i+1)])
  }
  else if (i == length(x)) {
    y[i] <- sum(x[(i - 1):i])
  }
  else {
    y[i] <- sum(x[(i-1):(i+1)])
  }
}

y
