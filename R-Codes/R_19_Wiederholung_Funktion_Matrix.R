### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 19: Wiederholte Funktionsanwendung bei Matrizen
### -------------------------------------------------------------------------


# Die Daten dieses Kapitels
# Ggf. Arbeitsverzeichnis wechseln oder Pfad angeben
objekte <- load("Minigolf_Matrizen.RData")
objekte

# Die Schlagzahlen der 3 Spieler
Schlaege



### -------------------------------------------------------------------------
### 19.1  Wiederholte Funktionsanwendung auf Zeilen und Spalten einer Matrix
###       -- apply()
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 19.1.1  Erstes Anwendungsbeispiel für apply()


# Schlagsummen mit apply()
apply(Schlaege, MARGIN = 2,
  FUN = sum)

# Schlagsummen mit colSums()
# Deutlich effizienter!
colSums(Schlaege)


# Arbeitsweise des obigen Codes
temp1 <- sum(Schlaege[, 1])    # sum() auf 1. Spalte anwenden
temp2 <- sum(Schlaege[, 2])    # sum() auf 2. Spalte anwenden
temp3 <- sum(Schlaege[, 3])    # sum() auf 3. Spalte anwenden

# Ergebnisobjekt zusammenbauen
res <- c(temp1, temp2, temp3)
names(res) <- colnames(Schlaege)
res


### -------------------------------------------------------------------------
### 19.1.2  Vereinfachung der Datenstruktur bei apply()


# 1.) Kumulierte Schlagzahlen berechnen
Schlaege.cum <- apply(Schlaege, MARGIN = 2, FUN = cumsum)
Schlaege.cum

# 2.) Bestimme jene Bahnen, nach denen Spieler 1 in Führung liegt.
Schlaege.cum.min <- apply(Schlaege.cum, MARGIN = 1, FUN = min)
Schlaege.cum.min

bool.fuehrung1 <- Schlaege.cum[, "Spieler1"] == Schlaege.cum.min
names(bool.fuehrung1)[bool.fuehrung1]


### -------------------------------------------------------------------------
### 19.1.3  Anordnung der Ergebnisse bei apply()


# Kleinste und grösste Schlagzahl bestimmen
Schlaege.range <- apply(Schlaege, MARGIN = 1, FUN = range)
Schlaege.range

t(Schlaege.range)


### -------------------------------------------------------------------------
### 19.1.4  Parameterübergabe innerhalb von apply()


# Das 0%- und 100%-Quantil für die Schlagzahlen jeder Bahn bestimmen
apply(Schlaege, MARGIN = 1, FUN = quantile, probs = c(0, 1))



### -------------------------------------------------------------------------
### 19.2  Über Zeilen und Spalten fegen -- sweep()
### -------------------------------------------------------------------------


# Spalten zentrieren
center <- colMeans(Schlaege)
Schlaege.centered <- sweep(Schlaege, MARGIN = 2, STATS = center, FUN = "-")
Schlaege.centered

# Kontrolliere, ob die Spalten tatsächlich zentriert sind
colMeans(Schlaege.centered)


# Zentriere Spalten einer Matrix
apply(Schlaege, MARGIN = 2, FUN = function(x) x - mean(x))


# Spalten skalieren (auf Standardabweichung 1 bringen)
temp <- apply(Schlaege.centered, MARGIN = 2, FUN = sd)
Schlaege.scaled <- sweep(Schlaege.centered, 2, STATS = temp, FUN = "/")
Schlaege.scaled

# Kontrolliere, ob die Spalten tatsächlich normiert sind
apply(Schlaege.scaled, MARGIN = 2, FUN = sd)



### -------------------------------------------------------------------------
### 19.3  Zentrierung und Standardisierung -- scale()
### -------------------------------------------------------------------------


# Standardisierung von Schlaege
Schlaege.scaled <- scale(Schlaege)
Schlaege.scaled



### -------------------------------------------------------------------------
### 19.4  Äussere Vektorprodukte -- outer(), "%o%"
### -------------------------------------------------------------------------


outer(1:10, 1:10, FUN = "*")   # Das kleine Einmaleins


# Zwei Beispielvektoren
x <- c(1, 2, 3)
y <- c(2, 4)

# Äusseres Vektorprodukt x y'
x %o% y

# Alternative für x y'
x %*% t(y)



### -------------------------------------------------------------------------
### 19.5  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 19.5.3  Übungen


Pkt <- matrix(c(43, 45, 17, NA, 13, 32, NA, NA, 49, 15),
              ncol = 2, byrow = TRUE)
rownames(Pkt) <- paste0("Stud", 1:nrow(Pkt))
colnames(Pkt) <- paste0("T", 1:ncol(Pkt))
Pkt
