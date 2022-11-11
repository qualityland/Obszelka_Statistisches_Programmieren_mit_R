### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 28: Kontrollstrukturen
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 28.1  Anweisungsblöcke -- { }
### -------------------------------------------------------------------------


{
  1:3  # wird nicht gedruckt
  4:6  # letzter Ausdruck
}

{
  print(1:3)
  print(4:6)
}



### -------------------------------------------------------------------------
### 28.2  Bedingte Anweisung und Verzweigung
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 28.2.1  Bedingte Anweisung -- if


x <- -1

if (x < 0) {
  x <- x * (-2)
}

x


x <- 1

if (x < 0) {
  x <- x * (-2)
}

x


### -------------------------------------------------------------------------
### 28.2.2  Wenn/Dann-Verzweigung -- if, else


x <- c(1, 2, 3, NA)              # Beispielvektor mit NA

if (is.na(x)) {
  cat("x enthält NAs\n")         # Meldung auf Console drucken
} else {
  cat("x enthält keine NAs\n")   # Meldung auf Console drucken
}


x <- c(1, 2, 3, NA)              # Beispielvektor mit NA

if (any(is.na(x))) {
  cat("x enthält NAs\n")         # Meldung auf Console drucken
} else {
  cat("x enthält keine NAs\n")   # Meldung auf Console drucken
}


{
  if (any(is.na(x))) {
    cat("x enthält NAs\n")
  }
  else {
    cat("x enthält keine NAs\n")
  }
}


if (any(is.na(x))) {
  cat("x enthält NAs\n")
}
else {



### -------------------------------------------------------------------------
### 28.3  Schleifen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 28.3.1  for-Schleife -- for


fibo <- numeric(5)            # Numerischen Vektor der Länge 5 erstellen
fibo[1:2] <- 1                # 1. und 2. Fibonaccizahl per Definition

fibo[3] <- fibo[1] + fibo[2]  # 3. Fibonaccizahl berechnen
fibo[4] <- fibo[2] + fibo[3]  # 4. Fibonaccizahl berechnen
fibo[5] <- fibo[3] + fibo[4]  # 5. Fibonaccizahl berechnen

fibo                          # Ergebnis ausgeben


fibo <- numeric(5)            # Numerischen Vektor der Länge 5 erstellen
fibo[1:2] <- 1                # 1. und 2. Fibonaccizahl per Definition

i <- 3
fibo[i] <- fibo[i - 2] + fibo[i - 1]
i <- 4
fibo[i] <- fibo[i - 2] + fibo[i - 1]
i <- 5
fibo[i] <- fibo[i - 2] + fibo[i - 1]

fibo                          # Ergebnis ausgeben


fibo <- numeric(5)            # Numerischen Vektor der Länge 5 erstellen
fibo[1:2] <- 1                # 1. und 2. Fibonaccizahl per Definition

for (i in 3:length(fibo)) {
  fibo[i] <- fibo[i - 2] + fibo[i - 1]
}

fibo                          # Ergebnis ausgeben


### -------------------------------------------------------------------------
### 28.3.2  Zwei Anwendungsvarianten der for-Schleife


x <- c(5, -2, 3)

# Indexbasierte Schleife
for (i in 1:length(x)) {
  print(x[i]^2)
}

# Inhaltsbasierte Schleife
for (y in x) {
  print(y^2)
}


x


# Nachbau indexbasierte Schleife

# Iteration Nummer 1
i <- 1     # nächstes Element
x[i]
x[i]^2

# Iteration Nummer 2
i <- 2     # nächstes Element
x[i]
x[i]^2

# Iteration Nummer 3
i <- 3     # nächstes Element
x[i]
x[i]^2


# Nachbau inhaltsbasierte Schleife

# Iteration Nummer 1
y <- x[1]  # nächstes Element
y
y^2

# Iteration Nummer 2
y <- x[2]  # nächstes Element
y
y^2

# Iteration Nummer 3
y <- x[3]  # nächstes Element
y
y^2


# Initialisierung mit NULL
erg <- NULL

for (i in 1:length(x)) {
  erg[i] <- x[i]^2
}

erg


# Bessere Initialisierung
erg <- numeric(length(x))

for (i in 1:length(x)) {
  erg[i] <- x[i]^2
}

erg


### -------------------------------------------------------------------------
### 28.3.3  Sequenzielle vs. parallele Berechnung, Schleifenvermeidung


x

# Effiziente Berechnung der quadrierten Werte
erg <- x ^ 2
erg


fibo <- numeric(5)            # Numerischen Vektor der Länge 5 erstellen
fibo[1:2] <- 1                # 1. und 2. Fibonaccizahl per Definition

for (i in 3:length(fibo)) {
  fibo[i] <- fibo[i - 2] + fibo[i - 1]
}

fibo                          # Ergebnis ausgeben


# Berechne die 1. bis 5. Fibonaccizahl mit der geschlossenen Formel
k <- 1:5
fibo <- 1 / sqrt(5) * (((1 + sqrt(5)) / 2)^k - ((1 - sqrt(5)) / 2)^k)
fibo


### -------------------------------------------------------------------------
### 28.3.4  while-Schleife -- while


i <- 1

while (i < 4) {
  print(i)
  i <- i + 1
}


# Nachbau der while-Schleife
i <- 1

# Iteration Nummer 1
i           # i zu Iterationsbeginn
i < 4       
# TRUE => Schleifenrumpf ausführen
print(i)    # drucke i aus
i <- i + 1  # i hochzählen

# Iteration Nummer 2
i           # i zu Iterationsbeginn
i < 4       
# TRUE => Schleifenrumpf ausführen
print(i)    # drucke i aus
i <- i + 1  # i hochzählen

# Iteration Nummer 3
i           # i zu Iterationsbeginn
i < 4       
# TRUE => Schleifenrumpf ausführen
print(i)    # drucke i aus
i <- i + 1  # i hochzählen

# Iteration Nummer 4
i           # i zu Iterationsbeginn
i < 4       
# FALSE => Schleife abbrechen


# Ergebnisvektor initialisieren
fibo <- c(1, 1)

# Der Iterationszähler
iter <- 2

while (fibo[iter] <= 100) {
  # Iterationszähler hochzählen und neue Fibonaccizahl anhängen
  iter <- iter + 1
  fibo[iter] <- fibo[iter - 2] + fibo[iter - 1]
}
fibo

# Anzahl der Folgenglieder ausgeben
iter
length(fibo)


### -------------------------------------------------------------------------
### 28.3.5  Schleifensteuerung -- break, next


for (i in 1:10) {
  if (i <= 4) {
    next
  }
  print(i)
  if (i >= 8) {
    break
  }
}


### -------------------------------------------------------------------------
### 28.3.6  Endlosschleifen -- while (TRUE), repeat


# Ergebnisvektor initialisieren
fibo <- c(1, 1)
fibo

while (TRUE) {
  # n ... Die wievielte Fibonaccizahl berechnen wir jetzt?
  n <- length(fibo) + 1
  fibo[n] <- fibo[n - 2] + fibo[n - 1]
  # Abbruchsbedingung
  if (fibo[n] > 100) {
    break
  }
}

fibo
length(fibo)



### -------------------------------------------------------------------------
### 28.4  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 28.4.1  Programmierstil: Einrückungen


# Unuebersichtlicher Code

x <- 0
while (x < 5){if (x <= 1){temp<-1
x <- x + 1}else{if(x %in% c(2, 3)){x <- x + 2}else{x <- x - 1}}}


# Uebersichtlicher Code

x <- 0
while (x < 5) {
  if (x <= 1) {
    temp <- 1
    x <- x + temp
  }
  else {
    if (x %in% c(2, 3)) {
      x <- x + 2
    }
    else {
      x <- x - 1
    }
  }
}


### -------------------------------------------------------------------------
### 28.4.2  Fallbeispiel: Zelluläre Automaten


# 1.) Definiere Parameter
n <- 5      # Anzahl der Zellen
tmax <- 10  # Maximale Anzahl an Iterationen

# Die Matrix X (T x n) speichert die Zustände, wobei T nicht fix.
# Zeile t: Zustände zum Zeitpunkt t. Spalte i: Zustandsentwicklung von Zelle i.
# definiere X(1); können auch selbst Startzustand vorgeben
x <- sample(-1:1, size = n, replace = TRUE)
X <- t(x)

# 2.) Äussere Schleife definieren
for (t in 2:tmax) {

  # 3.) Z(t) berechnen
  z <- rep(NA, n)

  # Innere Schleife definineren
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

  # 4.) Zustände updaten und an die Matrix anhängen
  xt <- ifelse(z > 0, 1, ifelse(z < 0, -1, 0))
  X <- rbind(X, xt)

  # 5.) Prüfe auf Konvergenz: Wenn alle Zellen unverändert sind,
  # breche die (äussere) Schleife ab.
  if (all(X[t - 1, ] == X[t, ])) break
}

# 6.) Ausgabe des Automaten
colnames(X) <- paste0("X_", 1:ncol(X))
rownames(X) <- paste("t =", 1:nrow(X))
X



### -------------------------------------------------------------------------
### 28.5  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 28.5.3  Übungen


gebtag <- c(Daniel = "07.07.1986", Andreas = "12.09.1973",
  Neujahr98 = "01.01.1998", Felix2902 = "29.02.1996")
gebtag
