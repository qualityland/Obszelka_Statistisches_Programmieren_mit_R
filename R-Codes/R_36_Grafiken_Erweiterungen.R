### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 36: Grafikfenster und Layout
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 36.1  Grafikfenster: Devices
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 36.1.1  Neues Device öffnen -- dev.new()


# Neues Device mit 7 x 7 inches
dev.new()

# Neues Device mit 3 x 8 inches
dev.new(height = 3, width = 8)



### -------------------------------------------------------------------------
### 36.2  Grafiken speichern
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 36.2.2  Speichern von Grafiken


# Plotregion vorbereiten
dev.new(height = 0.5, width = 0.7)    # Neues Grafikfenster
par(mar = c(0, 0, 0, 0))              # keine Ränder

# Rechte Grafik erstellen
plot(0, 0, type = "n", axes = FALSE)  # Leere Grafik
text(0, 0, " Scharf mit \n Vektorgrafik ", cex = 1)

# Grafik als PostScript (Vektorgrafik) abspeichern
savePlot("Vektorgrafik", type = "ps")

# Linke Grafik erstellen
plot(0, 0, type = "n", axes = FALSE)  # Leere Grafik
text(0, 0, " Unscharf mit \n Rastergrafik ", cex = 1)

# Grafik als png (Rastergrafik) abspeichern
savePlot("Rastergrafik", type = "png")

# Alle Grafikdevices schliessen
graphics.off()



### -------------------------------------------------------------------------
### 36.3  Fenstereinteilung und Layout
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 36.3.1  Äussere Grafikränder -- par()$mar, par()$mai


# Standardeinstellungen
dev.new()
plot(0:10, 0:10, main = "Titel")

# Ränder umstellen
par(mar = c(2, 2, 8, 0))
plot(0:10, 0:10, main = "Titel")


### -------------------------------------------------------------------------
### 36.3.2  Einfache Fensterteilung -- par()$mfrow


# Alle numerischen Spalten selektieren
iris.num <- iris[sapply(iris, is.numeric)]
head(iris.num, n = 3)

# Device vorbereiten
dev.new(width = 12, height = 8)
par(mfrow = c(2, length(iris.num)))

# 1. Zeile: Histogramme
for (i in 1:length(iris.num)) {
  hist(iris.num[[i]], main = names(iris.num)[i], xlab = "cm")
}

# 2. Zeile: Boxplots
for (i in 1:length(iris.num)) {
  boxplot(iris.num[[i]], main = names(iris.num)[i])
}

# Alle Devices schliessen
graphics.off()


### -------------------------------------------------------------------------
### 36.3.3  Paarweise Streudiagramme -- pairs()


# Alle numerischen Spalten selektieren
iris.num <- iris[sapply(iris, is.numeric)]

# Definiere Farben und Punktformen für jede Spezies
col.roh <- c(2, 3, 4)
pch.roh <- c(1, 2, 3)

# Paarweise Streudiagramme zeichnen
pairs(iris.num, main = "Anderson's Iris Data",
  col = col.roh[iris$Species], pch = pch.roh[iris$Species])


### -------------------------------------------------------------------------
### 36.3.4  Eigene Layouts definieren -- layout(), layout.show(), lcm()


# Alle numerischen Spalten selektieren
iris.num <- iris[sapply(iris, is.numeric)]
k <- length(iris.num)   # Anzahl der numerischen Variablen

# Generiere ein Layout mit 2 Zeilen und k Spalten.
M <- matrix(1:(2 * k), nrow = 2, byrow = TRUE)
M

# Layout für M erstellen
n <- layout(M)          # Layout gibt die Anzahl der Bereiche zurück.
n

# Zeige die ersten 2 Zellen an
layout.show(2)

# Zeige alle n Zellen an
layout.show(n)


# Zufallszahlengenerator konfigurieren
RNGversion("4.0.2")
set.seed(1)

# Grafikfenster vorbereiten und Layout erstellen
dev.new(width = 12, height = 8)
n <- layout(M)

# n Stichproben der Grösse 100 einer Standardnormalverteilung
for (i in 1:n) {
  x <- rnorm(100)
  hist(x, main = paste("Stichprobe", i))
}

# 1. Zeile: Histogramme
for (i in 1:length(iris.num)) {
  hist(iris.num[[i]], main = names(iris.num)[i], xlab = "cm")
}

# 2. Zeile: Boxplots
for (i in 1:length(iris.num)) {
  boxplot(iris.num[[i]], main = names(iris.num)[i])
}


M <- matrix(c(1, 1, 2, 4, 3, 4),
  ncol = 3)
M

n <- layout(M)
layout.show(n)


M <- matrix(c(1, 1, 2, 0, 3, 0),
  ncol = 3)
M

n <- layout(M)
layout.show(n)


M <- matrix(1:9, ncol = 3)
M

n <- layout(M,
  widths = c(1, 2, 4))
layout.show(n)

n <- layout(M,
  widths = c(1, 2, 4),
  heights = c(1, 2, 4))
layout.show(n)

n <- layout(M,
  widths = lcm(c(2, 3, 4)),
  heights = c(1, 2, 4))
layout.show(n)

n <- layout(M,
  widths = c(1, "2 cm", 2),
  heights = c(1, "3 cm", 2))
layout.show(n)



### -------------------------------------------------------------------------
### 36.4  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 36.4.1  Fallbeispiel: Streudiagramme mit Randverteilungen -- density(),
###         substitute()


# Spalten des Iris-Datensatzes global verfügbar machen
attach(iris)

# Farben aussuchen: Rot, Grün, Blau
hue <- c(0, 120, 240)
col.hell   <- hcl(hue, 70, 70)
col.dunkel <- hcl(hue, 70, 50)

# Layout definieren
dev.new()
n <- layout(matrix(c(2, 1, 4, 3), ncol = 2),
  widths = c(5, 2), heights = c(2, 5))
layout.show(n)

# Streudiagramm zeichnen (Position 1)
par(mar = c(4, 4, 1, 1))  # Äussere Grafikränder einstellen
par(mgp = c(2, .5, 0))    # Achsentitel und Achsenlabels näher rücken

plot(Petal.Length, Petal.Width, col = col.dunkel[Species], las = 1)


# Obere Randverteilung zeichnen (Position 2)
par(mar = c(0, 4, 1, 1))

h <- hist(Petal.Length, plot = FALSE)
barplot(h$density, axes = FALSE, space = 0)

# Rechte Randverteilung zeichnen (Position 3)
par(mar = c(4, 0, 1, 1))

h <- hist(Petal.Width, plot = FALSE)
barplot(h$density, horiz = TRUE, axes = FALSE, space = 0)


# Legende einzeichnen (Position 4)
par(mar = c(0, 0, 1, 1))
plot(0, 0, type = "n", axes = FALSE)

# Legende zentriert einzeichnen
legend(x = "center", legend = levels(Species), pch = 1,
  col = col.dunkel, text.col = col.dunkel, cex = 1, bty = "n")

# iris wieder einpacken
detach(iris)


zeichne.bar <- function(x, gruppe, horiz = FALSE, col) {
  # Hilfsfunktion für das Histogramm. Falls gruppe (Klasse factor)
  # spezifiziert wurde, so wird die Gruppe farblich gemäss col markiert.
	
  h <- hist(x, plot = FALSE)
	
  if (missing(gruppe)) {
    # Einfärbiges Balkendiagramm
    barplot(h$density, axes = FALSE, horiz = horiz, space = 0)
  }
  else {
    # Mehrfärbiges Balkendiagramm
    temp <- tapply(x, gruppe, function(u) {
      hist(u, breaks = h$breaks, plot = FALSE)
    })
	
    mat <- t(sapply(temp, function(y) y$counts))
    barplot(mat, col = col, horiz = horiz, axes = FALSE, space = 0)
  }
}

graphics.off()   # Alle Devices schliessen.

# einfärbig, horizontale Balken
zeichne.bar(iris$Petal.Length,
  horiz = TRUE)

# mehrfärbig, vertikale Balken
zeichne.bar(iris$Petal.Length,
  gruppe = iris$Species, col = 2:4)


zeichne.dichte <- function(x, gruppe, horiz = FALSE, kernel = FALSE, col) {
  # Hilfsfunktion für die Dichtegrafiken.
  # kernel ... FALSE: Es wird Normalverteilung angenommen.
  #            TRUE: Es werden Kerndichteschätzer berechnet.
	
  # 1.) Vorbereitungen
  lim <- range(x)
  xx <- seq(lim[1], lim[2], length = 201)
  Y <- matrix(NA, nrow = length(xx), ncol = nlevels(gruppe))
	
  # 2.) y-Werte der Dichtekurven berechnen.
  for (i in 1:nlevels(gruppe)) {
    temp <- x[gruppe == levels(gruppe)[i]]
	
    if (kernel)
      # Kerndichteschätzer bestimmen
      Y[, i] <- density(temp, from = lim[1], to = lim[2], n = length(xx))$y
    else
      # Dichteschätzer unter Normalverteilungsannahme bestimmen
      Y[, i] <- dnorm(xx, mean(temp, na.rm = TRUE), sd(temp, na.rm = TRUE))
  }
	
  # 3.) Dichtekurven zeichnen.
  if (horiz)
    matplot(Y, xx, col = col, type = "l", lwd = 2, lty = 1,
      axes = FALSE, las = 1, xlab = "", ylab = "")
  else
    matplot(xx, Y, col = col, type = "l", lwd = 2, lty = 1,
      axes = FALSE, las = 1, xlab = "", ylab = "")
}

graphics.off()   # Alle Devices schliessen.

# Normalverteilung, vertikal
zeichne.dichte(iris$Petal.Length,
  gruppe = iris$Species,
  horiz = FALSE, kernel = FALSE,
  col = 2:4)

# Kerndichten, horizontal
zeichne.dichte(iris$Petal.Length,
  gruppe = iris$Species,
  horiz = TRUE, kernel = TRUE,
  col = 2:4)


plot.auswahl <- function(x, type, gruppe, col, horiz = FALSE) {
  # Hilfsfunktion, welche die zum type passende Zeichenfunktion aufruft.
  switch(type,
    bar = zeichne.bar(x, horiz = horiz),
    bar.col = zeichne.bar(x, gruppe, horiz, col = col),
    normal = zeichne.dichte(x, gruppe, horiz, kernel = FALSE, col),
    kernel = zeichne.dichte(x, gruppe, horiz, kernel = TRUE, col),
    {
      warning("type unbekannt, zeichne einfaerbige Balken!");
      zeichne.bar(x, horiz = horiz)
    }
  )
}


plot.streu <- function(x, y, gruppe, type = "bar", hue, pch) {
  # Zeichnet ein Streudiagramm mit diversen Randverteilungen
  # x, y ..... x und y-Variable
  # gruppe ... Objekt der Klasse factor
  # type ..... "bar" (default): Einfärbiges Balkendiagramm
  #            "bar.col": Balkendiagramm; gruppe wird eingefärbt
  #            "normal": Normalverteilungsdichten
  #            "kernel": Kerndichten
  # hue ...... Farbton aus dem HCL-Farbraum
  # pch ...... pch-Werte für die Gruppen
	
  xlab <- substitute(x)     # Name für die x-Achse extrahieren
  ylab <- substitute(y)     # Name für die y-Achse extrahieren
	
  # Farben definieren
  col1 <- hcl(hue, 70, 70)  # hell (Balken, Dichten)
  col2 <- hcl(hue, 70, 50)  # dunkel (Legenden, Punkte)
	
  # Layout definieren
  dev.new()
  n <- layout(matrix(c(2, 1, 4, 3), ncol = 2),
    widths = c(5, 2), heights = c(2, 5))
  layout.show(n)
	
  # Streudiagramm zeichnen (Position 1)
  par(mar = c(4, 4, 1, 1))  # Äussere Grafikränder einstellen.
  par(mgp = c(2, .5, 0))    # Abstand der Achsenbeschriftung.
  plot(x, y, col = col2[gruppe], las = 1, pch = pch[gruppe],
    xlab = xlab, ylab = ylab)
	
  # Obere Randverteilung zeichnen (Position 2)
  par(mar = c(0, 4, 1, 1))
  plot.auswahl(x, type, gruppe, col1, horiz = FALSE)
	
  # Rechte Randverteilung zeichnen (Position 3)
  par(mar = c(4, 0, 1, 1))
  plot.auswahl(y, type, gruppe, col1, horiz = TRUE)
	
  # Legende zentriert einzeichnen (Position 4)
  par(mar = c(0, 0, 1, 1))
  plot(0, 0, type = "n", axes = FALSE)
  legend(x = "center", legend = levels(gruppe), pch = pch,
    col = col2, text.col = col2, cex = 1, bty = "n")
}


# Parametereinstellungen
hue <- c(0, 120, 240)
pch <- 1:3

# Iris-Daten global verfügbar machen.
attach(iris)

# Einfärbiges Balkendiagramm
plot.streu(Petal.Length,
  Petal.Width, Species,
  type = "bar",
  hue = hue, pch = pch)

# Mehrfärbiges Balkendiagramm
plot.streu(Petal.Length,
  Petal.Width, Species,
  type = "bar.col",
  hue = hue, pch = pch)

# Normalverteilungsdichte
plot.streu(Petal.Length,
  Petal.Width, Species,
  type = "normal",
  hue = hue, pch = pch)

# Kerndichteschätzer
plot.streu(Petal.Length,
  Petal.Width, Species,
  type = "kernel",
  hue = hue, pch = pch)

# Iris-Daten wieder einpacken.
detach(iris)


fun <- function(x) {
  print(substitute(x))
  x <- 5
  print(substitute(x))
}

# Aufruf mit rohem Ausdruck 3 * 4
fun(3 * 4)

n <- layout(matrix(c(5, 2, 1, 5, 4, 3), ncol = 2),
  widths = c(5, 2), heights = c(lcm(k), 2, 5))
