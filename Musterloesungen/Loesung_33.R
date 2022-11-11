### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 33
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


### a)

# In Code A wird res mit NULL initialisiert und laufend erweitert. Diese
# laufende Erweiterung verursacht einen unnoetigen Aufwand fuer R. Besser
# ist es, res schon mit der richtigen Laenge zu initialisieren, so wie in
# Code C.


### b)

# Die Matrix M hat viel weniger Spalten als Zeilen, daher sind in Code D
# deutlich weniger Schleifendurchlaeufe notwendig. Wichtige Grundregel:
# Halte die Anzahl der Schleifendurchlaeufe moeglichst klein.


### c)

# apply() ist ein schleifenaehnliches Konstrukt und geht ueber die Zeilen.
# Also wird sich Code B von der Laufzeit ungefaehr im Bereich von Code C
# befinden, da Code C ebenso ueber die Zeilen iteriert.


### d)

# Wir fuehren zunaechst die Codes A bis D aus.
# Abbruch ist mit ESC moeglich.

# Matrix generieren
n <- 10^6  # Anzahl der Zeilen
k <- 10    # Anzahl der Spalten
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

# Wir koennen hier auf Schleifen verzichten und vektorwertige Funktionen
# verwenden. Vektorwertige Funktionen sind fast immer deutlich schneller
# als Schleifen!
res <- rowSums(M^2)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Wir schreiben den gegebenen Code des zellulaeren Automaten zunaechst als
# Funktion auf. Zusaetzlich schaffen wir die Moeglichkeit, den seed
# einzustellen.

automat1 <- function(n = 5, tmax = 10, seed) {
  # n ...... Die Anzahl der Zellen
  # tmax ... Maximale Anzahl an Iterationen
  # seed ... Welcher Seed soll verwendet werden?
  #          Wird nichts uebergeben, wird irgendein seed verwendet.

  # Zustandsmatrix erzeugen
  if (!missing(seed)) {
    set.seed(seed)
  }
  x <- sample(-1:1, size = n, replace = TRUE)
  X <- t(x)

  # Aeussere Schleife
  for (t in 2:tmax) {
    z <- rep(NA, n)

    # Innere Schleife
    for (j in 1:n) {
      if (j == 1) {
      # Linke Zelle
        z[1] <- X[t - 1, 1] + X[t - 1, 2]
      }
      else {
        if (j == n) {
          # Rechte Zelle
          z[n] <- X[t - 1, n - 1] + X[t - 1, n]
        }
        else {
          # Zelle in der Mitte
          z[j] <- sum(X[t - 1, (j - 1):(j + 1)])
        }
      }
    }

    # Zustaende updaten und an die Matrix anhängen
    xt <- ifelse(z > 0, 1, ifelse(z < 0, -1, 0))
    X <- rbind(X, xt)

    # Pruefe auf Konvergenz
    if (all(X[t - 1, ] == X[t, ]))
      break
  }

  # Ausgabe des Automaten
  colnames(X) <- paste0("X_", 1:ncol(X))
  rownames(X) <- paste("t =", 1:nrow(X))
  invisible(X)
}

X1 <- automat1(n = 10^6, tmax = 100, seed = 123)
dim(X1)

# Obwohl nur 9 Iterationen gerechnet werden, dauert das sehr lange.

# Warum ist der Code langsam? Bzw. wo liegen die Verbesserungsmoeglichkeiten?
# 1.) Die aeussere Schleife ist notwendig, da wir die Berechnungen
#     sequenziell vornehmen muessen. Das Ergebnis der t. Iteration kann erst
#     bestimmt werden, wenn wir die Ergebnisse der t-1. Iteration kennen.
#     Da wir nicht genau wissen, wie viele Iterationen benoetigt werden,
#     ist eine konkrete Initialisierung kaum moeglich. Wenn die Anzahl der
#     der simulierten Zeitschritte gering ist (so wie hier), dann verursacht
#     aber das Anhaengen weiterer Ergebnisse an die Matrix X keinen
#     nennenswerten Mehraufwand.
# 2.) Die innere Schleife hingegen ist redundant. Wenn n gross ist, verursacht
#     sie viele (unnoetige) Berechnungen. Wir koennen die innere Schleife
#     durch eine vektorwertige Loesung ersetzen.
# 3.) Das Zustandsupdate erfolgt mit ifelse(). Tatsaechlich koennen wir eine
#     spezialisiertere Funktion einsetzen, die schneller arbeitet.


### Modifikation: Wir bauen die Schritte 2.) und 3.) ein und staunen ;-)

automat2 <- function(n = 5, tmax = 10, seed) {
  # n ...... Die Anzahl der Zellen
  # tmax ... Maximale Anzahl an Iterationen
  # seed ... Welcher Seed soll verwendet werden?
  #          Wird nichts uebergeben, wird irgendein seed verwendet.

  # Zustandsmatrix erzeugen
  if (!missing(seed)) {
    set.seed(seed)
  }
  x <- sample(-1:1, size = n, replace = TRUE)
  X <- t(x)

  # Aeussere Schleife
  for (t in 2:tmax) {
    z <- rep(NA, n)

    # Ad 2.) Ersetze innere Schleife durch vektorwertige Loesung.
    # Dazu bestimmen wir die Zustaende des linken bzw. rechten Nachbarn
    # (bei Randzellen schieben wir von links bzw. rechts eine Null ein),
    # sowie den aktuellen Zustand der Zellen.
    links   <- c(0, X[t - 1, -n])  # 0 links einschieben
    rechts  <- c(X[t - 1, -1], 0)  # 0 rechts einschieben
    aktuell <- X[t - 1, ]
    
    z <- links + rechts + aktuell

    # Ad 3.) Wir verwenden die Funktion sign(), die Vorzeichenfunktion
    xt <- sign(z)
    X <- rbind(X, xt)

    # Pruefe auf Konvergenz
    if (all(X[t - 1, ] == X[t, ]))
      break
  }

  # Ausgabe des Automaten
  colnames(X) <- paste0("X_", 1:ncol(X))
  rownames(X) <- paste("t =", 1:nrow(X))
  invisible(X)
}

X2 <- automat2(n = 10^6, tmax = 100, seed = 123)
dim(X2)

# Ueberzeugen uns, dass die Ergebnisse ident sind (bei selbem Seed)
all(X1 == X2)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


n <- 10^6
x <- sample(1:6, size = n, replace = TRUE)

# Mit ESC kann man den Code abbrechen ;-)


### a)

mittelwert <- NULL
  for (i in 1:length(x)) {
  mittelwert <- c(mittelwert, mean(x[1:i]))
}

# Der Code ist langsam, weil er einerseits auf Schleifen basiert (mit 
# vielen Iterationen und einer denkbar schlechten Initialisierung mit NULL)
# und andererseits redundante Berechnungen durchfuehrt.

# Schnellere Variante: Mit cumsum()
mittelwert2 <- cumsum(x) / (1:length(x))

# Haendische Stichprobenkontrolle, ob beide Vektoren gleich sind.
head(mittelwert)
head(mittelwert2)


### b)

varianz <- NULL
  for (i in 1:length(x)) {
  varianz <- c(varianz, var(x[1:i]))
}

# Aehnliche Gruende fuer die Langsamkeit wie in a). Hier ist es aber etwas
# aufwaendiger, eine effiziente vektorwertige Loesung zu finden.

# Wir wenden den Verschiebungssatz an.
sqx <- cumsum(x^2) - 1 / (1:length(x)) * cumsum(x)^2
varianz2 <- 1 / (1:length(x) - 1) * sqx

v2 <- varianz

# Haendische Stichprobenkontrolle, ob beide Vektoren gleich sind.
head(varianz)
head(varianz2)



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


n <- 10^6
k <- 5
W <- matrix(sample(1:6, size = n * k, replace = TRUE), ncol = k)
W.sort <- t(apply(W, 1, sort))

W.sort <- W
for (i in 1:(ncol(W.sort) - 1)) {
  for (j in ((i + 1) : ncol(W.sort))) {
    bool <- W.sort[, i] < W.sort[, j]
    W.sort[, i] <- ifelse(bool, W.sort[, i], W.sort[, j])
    W.sort[, j] <- ifelse(bool, W.sort[, j], W.sort[, i])
  }
}


### a)

# Der Algorithmus ist grundsaetzlich funktionstuechtig. Wir nehmen die i.
# Spalte von W.sort und vergleichen sie mit allen weiteren Spalten j. Wir
# vertauschen die Werte der i. und j. Spalte, wenn die j. Spalte einen
# kleineren Wert als die i. Spalte hat, dadurch ruecken die kleinen Werte
# nach vorne. Das Ganze fueren wir fuer i = 1, 2, ... aus.

# Das Problem ist, dass bei der ersten ifelse()-Anweisung W.sort[, i]
# ggf. mit W.sort[, j] ueberschrieben wird, wenn bool an den entsprechenden
# Stellen FALSE ist.

# Fuer die Matrix W <- t(c(5, 6, 5, 1, 2)) im Hinweis wuerde fuer i = 1 und
# j = 4 zuerst der Wert 1 an die erste Stelle kopiert werden (statt der 5),
# sodass beim zweiten ifelse() die 5 bereits durch 1 ueberschrieben wurde.
# Unterm Strich kommt [1 1 1 1 2] heraus.


### b)

# Wir brauchen also einen Zwischenpuffer. Wir koennen etwa die parallelen
# Minima bzw. Maxima berechnen und diese auf W.sort[, i] bzw. W.sort[, j]
# zuweisen.

# Korrektur
W.sort <- W
for (i in 1:(ncol(W.sort) - 1)) {
  for (j in ((i + 1) : ncol(W.sort))) {
    temp.min <- pmin(W.sort[, i], W.sort[, j])
    temp.max <- pmax(W.sort[, i], W.sort[, j])
    W.sort[, i] <- temp.min
    W.sort[, j] <- temp.max
  }
}


### c)

# Wenn n deutlich groesser als k ist, dann muss apply() n Mal sort()
# aufrufen. Wir haben also n Iterationen. Die Modifikation hingegen laeuft
# ueber die Spalten (Doppelschleife). Wir brauchen hierbei k*(k-1)/2
# Iterationen. In diesem Beispiel also 5*4/2 = 10 statt n = 10^6.



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


# Der Code aus "Wuerfelwurf - Augensumme erreichen" kann mit kleinen
# Modifikationen wiederverwertet werden. Unterschied: Anstatt einen Wuerfel
# zu werfen, werfen wir eine Muenze mit FALSE bzw. TRUE. Wir speichern uns
# die Anzahl der eingeklebten Bilder und wissen somit, wie gross die
# Wahrscheinlichkeit ist, dass wir im naechsten Durchgang einen neuen
# Sticker erwischen.

# Die folgende Funktion orientiert sich direkt an der Funktion sim4() des
# Wuerfelwurfbeispiels.

sammelbild <- function(m, n, seed) {
  # m ...... Anzahl der Bilder, die wir sammeln wollen
  # n ...... Anzahl der Simulationslaeufe
  # seed ... Der verwendete Seed. Wird nichts uebergeben, wird ein
  #          zufaelliger Seed verwendet.

  res <- numeric(n)  # Anzahl der insgesamt gekaufen Bilder
  k <- rep(m, n)     # Anzahl der fehlenden Bilder jedes Albums
  iter <- 0          # Iterationszaehler: Das wievielte Bild kaufen wir?

  if (!missing(seed)) {
    set.seed(seed)
  }

  # Solange noch mindestens ein Album nicht voll ist
  while (any(k > 0)) {
    # bool markiert jene Alben, die noch mindestens ein Bild benoetigen.
    bool <- k > 0

    # Ein weiteres Bild kaufen: Mit Wahrscheinlichkeit k / m haben wir
    # kein Duplikat erwischt.
    iter <- iter + 1
    k <- k - (runif(n) < k / m)

    # Bestimme jene Alben, die in diesem Durchgang voll wurden.
    fertig <- bool & (k == 0)
    res[fertig] <- iter
  }

  return(invisible(res))
}

m <- 20
res <- sammelbild(m = m, n = 10^6)

# Plausibilitaetscheck
mean(res)
sum(m / (1:m))

# Fuer Interessierte: Wir koennen ein Histogramm zeichnen und uns damit
# die Verteilung ansehen:
hist(res, freq = FALSE, xlab = "Anzahl der gekauften Bilder",
  ylab = "Relative Haeufigkeit")


# Gerne darfst du auch weitere Varianten (zum Beispiel angelehnt an sim5())
# ausprobieren!


# Eine spannende Alternative, die staerker den Prozess des Sammelns 
# modelliert ist folgende: Wir nummerieren die Bilder von 1 bis m durch.
# Eine Matrix Bool (n x m) gibt uns an, welche Bilder uns noch fehlen (TRUE)
# oder wir bereits besitzen (FALSE). Wenn in einer Zeile lauter FALSE stehen,
# ist das entsprechende Album voll.

sammelbild <- function(m, n, seed) {
  # m ...... Anzahl der Bilder, die wir sammeln wollen
  # n ...... Anzahl der Simulationslaeufe
  # seed ... Der verwendete Seed. Wird nichts uebergeben, wird ein
  #          zufaelliger Seed verwendet.

  res <- numeric(n)  # Anzahl der insgesamt gekaufen Bilder
  Bool <- matrix(TRUE, ncol = m, nrow = n)
                     # Welche Bilder fehlen uns noch?
  k <- rep(m, n)     # Anzahl der fehlenden Bilder jedes Albums
  iter <- 0          # Iterationszaehler: Das wievielte Bild kaufen wir?

  if (!missing(seed)) {
    set.seed(seed)
  }

  # Solange noch mindestens ein Album nicht voll ist
  while (any(k > 0)) {
    # bool markiert jene Alben, die noch mindestens ein Bild benoetigen.
    bool <- k > 0

    # Ein weiteres Bild kaufen.
    iter <- iter + 1
    bild <- sample(1:m, size = n, replace = TRUE)
    
    # Wenn das Bild kein Duplikat ist, dann k reduzieren
    k <- k - Bool[cbind(1:n, bild)]
    Bool[cbind(1:n, bild)] <- FALSE

    # Bestimme jene Alben, die in diesem Durchgang voll wurden.
    fertig <- bool & (k == 0)
    res[fertig] <- iter
  }

  return(invisible(res))
}

m <- 20
res <- sammelbild(m = m, n = 10^6)

# Plausibilitaetscheck
mean(res)
sum(m / (1:m))



### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


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


### Beschleunigung

# Bei der vektorwertigen Loesung bestimmen wir fuer jede Position den Wert
# des linken bzw. rechten Nachbarn (bei Randelementen schieben wir von links
# bzw. rechts eine Null ein), sowie den Wert der Position selbst. Dann
# addieren wir die drei gewonnenen Werte.

links   <- c(0, x[-length(x)])  # 0 links einschieben
rechts  <- c(x[-1], 0)          # 0 rechts einschieben
aktuell <- x
    
y <- links + rechts + aktuell
y

