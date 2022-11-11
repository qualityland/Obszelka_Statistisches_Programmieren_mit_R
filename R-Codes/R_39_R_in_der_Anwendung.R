### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 39: Programmierpraxis
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 39.1  R-Code in mehrere Dateien teilen -- source()
### -------------------------------------------------------------------------


source("Funktionen.R")
source("Daten.R")
source("Auswertung.R")



### -------------------------------------------------------------------------
### 39.2  R-Code und Dokumentation integrieren
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 39.2.3  Dokument mit R-Code ausführen -- knit(), render()


knitr::knit("beispiel.Rnw")
knitr::knit("beispiel.Rhtml")
knitr::knit("beispiel.Rmd")



### -------------------------------------------------------------------------
### 39.3  Fehlertypen und Fehlersuche (Debugging)
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 39.3.1  Fehlertypen


# Syntaktischer Fehler
paste(1 2)

# Semantischer Fehler
a * 2

# Logischer Fehler
34 / 7
# Korrekte Syntax
34 %/% 7


## Für einen Vektor die Anzahl der Werte > 1 bestimmen

# Inputvektor
x <- 1:2

# Möglichkeit 1.)
sum(x > 1)

# Möglichkeit 2.)
length(x[x > 1])

# Möglichkeit 3.)
length(which(x > 1))

# Alternativer Inputvektor 
x <- c(1:2, NA)

# Fehlerhafte Codes
sum(x > 1)                # 1.)
length(x[x > 1])          # 2.)

# Korrekte bzw. korrigierte Codes
sum(x > 1, na.rm = TRUE)  # 1.)
x1 <- x[!is.na(x)]        # 2.)
length(x1[x1 > 1])
length(which(x > 1))      # 3.)


### -------------------------------------------------------------------------
### 39.3.2  Fehlersuche und -korrektur -- browser(), recover()


f1 <- function(a, b)

z <- 5
rm(z)
f2 <- function() z
f2()

f3 <- function(x) {
  y <- log(x[x > 0])
  return(t.test(x, y, paired = TRUE))
}
f3(0:4)


### Eine Funktion global machen


x <- 0:4                     # Parameter x global machen.
y <- log(x[x > 0])           # Parameter y global machen.
t.test(x, y, paired = TRUE)  # return() muss entfernt werden.
y  # y ist jetzt global verfügbar.


### print()-Befehle einbauen


f3_print <- function(x) {
  cat("x:", x, "\n")
  y <- log(x[x > 0])
  cat("y:", y, "\n")
  return(t.test(x, y, paired = TRUE))
}
f3_print(0:4)


### traceback() verwenden


f3(0:4)
traceback()


### browser()-Befehle einbauen


f3_browser <- function(x) {
  browser()
  y <- log(x[x > 0])
  browser()
  return(t.test(x, y, paired = T))
}

f3_browser(0:4)


### debug() verwenden


debug(f3)
f3(0:4)


### recover() verwenden


old <- getOption("error")  # ursprünglichen Wert der Option speichern
options(error = recover)
f3(0:4)
options(error = old)  # Option auf alten Wert zurücksetzen
