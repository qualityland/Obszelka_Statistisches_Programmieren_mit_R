### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 10: Texte, Zeichenketten und Strings
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 10.1  Zeichenketten erstellen -- " "
### -------------------------------------------------------------------------


namen <- c("Walter", "Alex", "Julia")
namen


namen <- c(Walter, Alex, Julia)



### -------------------------------------------------------------------------
### 10.2  Zeichenketten sortieren -- sort(), order(), rank()
### -------------------------------------------------------------------------


namen

# Alphabetische Sortierung
sort(namen)

# Absteigende Sortierung
sort(namen, decreasing = TRUE)

# 1. Name im Alphabet
min(namen)

# Letzter Name im Alphabet
max(namen)


# Zahlen als Zahlen
# Sortierung nach Grösse
sort(c(12, 9, 314))

# Zahlen als Text
# Alphabetische Sortierung
sort(c("12", "9", "314"))



### -------------------------------------------------------------------------
### 10.3  Zeichenketten verknüpfen -- paste(), paste0()
### -------------------------------------------------------------------------


# String der Form x1 und x2 erzeugen
paste("x", 1:2)    # Erster Versuch
paste("x", 1:2, sep = "")
paste("x", 1:2, sep = "", collapse = " und ")


paste(1:3, 4:6, 7:9, sep = " * ", collapse = " und ")


# Variablen basteln
var <- paste("x", 1:2, sep = "")
var

# Ergebnisse basteln
res <- c(x1, x2)
res

# var und res geeignet zusammenbauen
paste(var, res, sep = " = ", collapse = " und ")


paste0("x", 1:2)   # sep = ""



### -------------------------------------------------------------------------
### 10.4  Buchstaben und Case sensitivity -- letters und LETTERS
### -------------------------------------------------------------------------


letters   # Alle Kleinbuchstaben

# Der wievielte Buchstabe im Alphabet ist c?
which(letters == "c")

# Sequenz von "a" bis "c"
letters[1:which(letters == "c")]

# Sequenz von "a" bis "c"
letters[letters <= "c"]

LETTERS   # Alle Grossbuchstaben


"A" == "a"
"A" == "A"



### -------------------------------------------------------------------------
### 10.5  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 10.5.3  Übungen


z1 <- c(3, 8, 4, 1)
z1

z2 <- c(5, 9, 2, 5)
z2


tipp <- c(4, 7, 15, 19, 20, 38)
lotto <- c(3, 19, 24, 23, 7, 34, 16)
