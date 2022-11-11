### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 36
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Aus der R-Hilfe unten bei den Beispielen entnehmen wir die Funktion
# panel.hist().

## put histograms on the diagonal
panel.hist <- function(x, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(usr[1:2], 0, 1.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}

pairs(iris, diag.panel = panel.hist)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


### Vorbereitungen

# Darzustellende Funktion definieren
f <- function(x, y) {
  sin(x) + cos(y)
}

# Wertebereich festlegen
x <- seq(-10, 10, length = 10)
y <- seq(-10, 10, length = 5)

# Funktionswerte berechnen mit outer()
# z ist eine length(x) x length(y) Matrix. In der i. Zeile wird x[i],
# in der j. Spalte wird y[j] in f() eingesetzt.
z <- outer(x, y, FUN = f)
z

# Die Funktionen image(), contour() und filled.contour() haben allesamt
# die Parameter x, y, z, xlim, ylim und zlim, welche analoge Bedeutungen
# haben wie bei 2D-Grafiken. Fuer Details sei auf die R-Hilfe verwiesen.


### a) Experimentiere mit der Bildauflösung

n <- 11
x <- seq(-10, 10, length = n)
y <- seq(-10, 10, length = n)
z <- outer(x, y, FUN = f)

image(x, y, z)
contour(x, y, z)
filled.contour(x, y, z)


n <- 101
x <- seq(-10, 10, length = n)
y <- seq(-10, 10, length = n)
z <- outer(x, y, FUN = f)

image(x, y, z)
contour(x, y, z)
filled.contour(x, y, z)


n <- 201
x <- seq(-10, 10, length = n)
y <- seq(-10, 10, length = n)
z <- outer(x, y, FUN = f)

image(x, y, z)
contour(x, y, z)
filled.contour(x, y, z)


n <- 501
x <- seq(-10, 10, length = n)
y <- seq(-10, 10, length = n)
z <- outer(x, y, FUN = f)

image(x, y, z)
contour(x, y, z)
filled.contour(x, y, z)


# Fuer 501 x 501 Bildpunkte wirken die Grafiken schon recht glatt. Beachte,
# dass praezisere Grafiken mehr Zeit fuer den Bildaufbau brauchen und mehr
# Speicherplatz benoetigen.


### a) Experimentiere mit Farbpaletten

# Generell gilt: Bei zu wenigen Farbabstufungen geht Information verloren,
# bei zu vielen Abstufungen erkennen wir den Verlauf oft nicht mehr gut.
# Ein Mittelweg ist gefragt.

# Bei image() gibt es den Parameter col:
# col = hcl.colors(12, "YlOrRd", rev = TRUE)
# Dem Parameter col uebergeben wir einen Vektor mit Farben bzw. Farbwerten.
# Standardmaessig werden 12 Farben uebergeben, das koennen wir umstellen.
# Sofern wir den Parameter breaks nicht spezifizieren, wird aus der Anzahl
# der Farben die dazu passende Anzahl fuer breaks bestimmt.

# Bei filled.contour() wiederum gibt es den parameter color.palette:
# color.palette = function(n) hcl.colors(n, "YlOrRd", rev = TRUE)
# Hierbei uebergeben wir eine Funktion, welche mit Hilfe des Parameters n 
# entsprechend viele Farben erzeugt.


# Farbpalette von Blau ueber Hellgrau zu Rot
colfun <- colorRampPalette(c(4, grey(0.8), 2))

image(x, y, z, col = colfun(3))
image(x, y, z, col = colfun(5))
image(x, y, z, col = colfun(10))
image(x, y, z, col = colfun(11))  # ganz gute Einstellung
image(x, y, z, col = colfun(21))

filled.contour(x, y, z, color.palette = colfun)
filled.contour(x, y, z, color.palette = colfun, nlevels = 8)


# Farbpalette von Weiß bis Schwarz
colfun <- colorRampPalette(c("white", "black"))

image(x, y, z, col = colfun(3))
image(x, y, z, col = colfun(5))
image(x, y, z, col = colfun(10))
image(x, y, z, col = colfun(11))  # ganz gute Einstellung
image(x, y, z, col = colfun(21))

filled.contour(x, y, z, color.palette = colfun)
filled.contour(x, y, z, color.palette = colfun, nlevels = 8)


### b)

# Eine alternative Farbpalette mit hcl()-Farben
colfun <- colorRampPalette(hcl(h = c(240, 0, 0), c = c(80, 0, 80),
  l = c(40, 90, 40)))

# Zunaechst definieren wir die breaks, also jene Stellen, bei denen die
# Farben wechseln bzw. die Hoehenschichtlinien verlaufen.

# Bestimme automatisiert den Wertebereich
z.lim <- range(z)
z.lim[1] <- floor(z.lim[1] * 100) / 100
z.lim[2] <- ceiling(z.lim[2] * 100) / 100
z.lim

# Stuetzstellen berechnen
n <- 11
br <- seq(-2, 2, length = n)
br

# image()-Plot erstellen. Da wir breaks spezifizieren, muessen wir auch col
# ueberschreiben (eine Farbe weniger, als es Stuetzstellen gibt).
image(x, y, z, breaks = br, col = colfun(n - 1))

# Hoehenschichtlinien darueberzeichnen. Dabei verwenden wir dieselben breaks
# (Parameter levels). Wichtig: mit add = TRUE werden die Hoehenschichtlinien
# ueber die existierende Grafik daruebergezeichnet.
contour(x, y, z, add = TRUE, levels = br)
title(main = "Darstellung der Funktion f(x, y) = sin(x) + cos(y)")


# Mit weniger Stuetzstellen
n <- 6
br <- seq(-2, 2, length = n)
br

image(x, y, z, breaks = br, col = colfun(n - 1))
contour(x, y, z, add = TRUE, levels = br)
title(main = "Darstellung der Funktion f(x, y) = sin(x) + cos(y)")



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


### a)

# Siehe zum Beispiel
# https://de.wikipedia.org/wiki/Parallele_Koordinaten


### b)

# Es gibt einige Paketloesungen, die infrage kommen:
# 1.) parcoord() der library MASS
#     Baut auf matplot() auf.
# 2.) parcoord() der library ggally
#     Baut auf dem Grafikpaket ggplot2 auf. ggplot2 hat eine andere Syntax
#     als die Basisgrafikpakete.
# 3.) add_trace() der library plotly

# Wir schauen uns die erste Variante mit MASS an.

data(iris)

# Paket MASS laden
library(MASS)
# ?MASS::parcoord

# Funktionsaufruf
# parcoord(x, col = 1, lty = 1, var.label = FALSE, ...)

# Numerische Spalten selektieren
iris.numeric <- iris[sapply(iris, is.numeric)]
iris.species <- iris$Species

# Wir bauen die finale Grafik schrittweise auf.

# 1. Schritt: Blanke Grafik erstellen
parcoord(iris.numeric)

# 2. Schritt: Farbinformation an Spezies koppeln
parcoord(iris.numeric, col = as.numeric(iris.species) + 1)

# 3. Schritt: Zusaetzlich Minima und Maxima fuer jede Variable anzeigen
# sowie Ueberschrift einfuegen
parcoord(iris.numeric, col = as.numeric(iris.species) + 1,
  var.label = TRUE, main = "Darstellung der iris-Daten")

# 4. Schritt: Legende einzeichnen
col = c(2, 3, 4)
# Hierzu koennen wir zum Beispiel mit ylim Platz auf der y-Achse schaffen
parcoord(iris.numeric, col = col[iris.species],
  var.label = TRUE, main = "Darstellung der iris-Daten", ylim = c(0, 1.15))
legend("top", legend = levels(iris.species), col = col, lwd = 1,
  ncol = nlevels(iris.species), bty = "n")


### c)

# In dieser Loesung bilden wir den internen Code von parcoord() ab:
parcoord

# Der Code baut auf matplot() auf. Folgende Schritte werden durchgefuehrt:
# 1.) Bestimme die Spannweiten jeder Variablen
# 2.) Fuehre fuer jede Variable eine Min-Max-Standardisierung durch
# 3.) Zeichne mit matplot() die Linien
# 4.) Zeichne Achsen ein
# 5.) Zeichne vertikale Linien und ggf. Labels fuer die Variablen ein.

function (x, col = 1, lty = 1, var.label = FALSE, ...) {
    # 1.) 2L bedeutet, dass 2 ganzzahlig (Integer) ist
    rx <- apply(x, 2L, range, na.rm = TRUE)

    # 2.)
    x <- apply(x, 2L, function(x) (x - min(x, na.rm = TRUE))/(max(x, 
        na.rm = TRUE) - min(x, na.rm = TRUE)))

    # 3.) Beachte, dass hier das Dreipunkteargument an matplot()
    #     weitergereicht wird. Dadurch haben wir eine extrem hohe
    #     Flexibilitaet und koennen etwa ylim umstellen.
    matplot(1L:ncol(x), t(x), type = "l", col = col, lty = lty, 
        xlab = "", ylab = "", axes = FALSE, ...)

    # 4.) Die Beschriftungen werden den Spaltennamen von x entnommen.
    axis(1, at = 1L:ncol(x), labels = colnames(x))

    # 5.) 
    for (i in 1L:ncol(x)) {
        lines(c(i, i), c(0, 1), col = "grey70")
        if (var.label)
            # Hier erkennen wir einige elegante Einstellmoeglichkeiten
            # bei text().
            text(c(i, i), c(0, 1), labels = format(rx[, i], digits = 3), 
                xpd = NA, offset = 0.3, pos = c(1, 3), cex = 0.7)
    }

    # Es wird null zurueckgegeben. Damit es nicht gedruckt wird, verwenden
    # wir invisible().
    invisible()
}



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


### a)

lambda <- c(0.5, 1, 2)

# x- und y-Werte definieren
# x-Werte: Den Wert fuer to bestimmen wir sinnvoll per Hand. Man kann einen
#   guten Wert auch automatisiert finden: Dazu muessen wir uns fuer alle
#   Parameterkonstellationen bererchnen, ab welchem Wert die Verteilungs-
#   funktion einen vorgegebenen Wert (etwa 0.99) ueberschreiten. Das
#   ueberlassen wir dir als Uebung ;-)
# y-Werte: Wir erstellen eine Matrix mit 3 Spalten: eine Spalte fuer jede
#   Parameterkonstellation.
x <- seq(0, 10, length = 201)
Y <- sapply(lambda, function(l) pexp(x, rate = l))

# plot vorbereiten
matplot(x, Y, type = "n", lty = 1,
  main = "Verteilungsfunktion der Exponentialverteilung",
  xlab = "x", ylab = "F(x)")

# Gitternetz einzeichnen
grid(lty = 1, col = "darkgrey")

# Verteilungsfunktionen fuer alle Parameterkonstellationen ueber das
# Gitternetz zeichnen.
matlines(x, Y, type = "l", lty = 1)


### b)

# Überblick über die Syntax
# ?plotmath
# demo(plotmath)

# Wir bauen uns die Zeichenkette zusammen. lambda bezeichnet den
# gleichnamigen griechischen Buchstaben. Um ein Gleichheitszeichen
# darzustellen, schreiben wir ==.
string <- paste0("lambda == ", lambda)
string

# Jetzt wandeln wir den Vektor in eine expression um. Dazu verwenden wir
# parse() mit dem Parameter text.
text <- parse(text = string)
text

# Legende unten rechts einzeichnen
legend(max(x), min(Y), xjust = 1, yjust = 0, legend = text,
  col = 1:3, lwd = 1, bg = "white")

