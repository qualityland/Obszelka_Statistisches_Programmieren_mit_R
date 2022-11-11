### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 35: Standardgrafiken und Farben
### -------------------------------------------------------------------------


# Ggf. Arbeitsverzeichnis wechseln
# setwd(...)
wahl <- read.table("NRWahlen.txt", na.string = ".",
  dec = ",", header = TRUE, skip = 5, encoding = "UTF-8")

tail(wahl, n = 3)



### -------------------------------------------------------------------------
### 35.1  Standardgrafiken
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 35.1.1  Parallele Liniengrafiken, Matrixplot -- matplot()


# x-Werte erzeugen
x <- seq(0, 2, length = 201)

# Erste Linie zeichnen
plot(x, y = 1 * x, type = "l",
  xlab = "x", ylab = "k * x")

# Weitere Linien einzeichnen
for (k in 2:3) {
  lines(x, k * x, col = k)
}

# Alle Linien berechnen
Y <- cbind(1 * x, 2 * x, 3 * x)


# Leeren Plot erzeugen
plot(range(x), range(Y),
  type = "n",
  xlab = "x", ylab = "k * x")

# Alle Linien einzeichnen
for (k in 1:ncol(Y)) {
  lines(x, Y[, k], col = k)
}


# x-Werte erzeugen und alle y-Werte berechnen
x <- seq(0, 2, length = 201)
Y <- cbind(1 * x, 2 * x, 3 * x)

# Alle Linien zeichnen
matplot(x, Y, type = "l", lwd = 3,
  xlab = "x", ylab = "k * x")

# Alle Linien zeichnen
matplot(x, Y, type = "l", lty = 1,
  xlab = "x", ylab = "k * x")


### Nationalratswahlenbeispiel

# Schritt 1: Kategorie Sonstige aufbereiten

tail(wahl, n = 3)

temp <- is.na(wahl[c(nrow(wahl) - 1, nrow(wahl)), ])
bool.na <- colSums(temp) == 2
which(bool.na)

# Sonstige updaten und nicht angetretene Parteien entfernen
temp <- wahl[c(names(which(bool.na)), "Sonstige")]
wahl$Sonstige <- rowSums(temp, na.rm = TRUE)
wahl[bool.na] <- list(NULL)

tail(wahl, n = 3)


# Schritt 2: Grafik zeichnen

# Neues Fenster mit 8 inches Breite und 6 inches Höhe
dev.new(width = 8, height = 6)

# Plot vorbereiten: Dimension und Beschriftungen
matplot(wahl$Wahljahr, wahl[-1], type = "n", axes = FALSE,
  xlab = "Wahljahr", ylab = "Prozent der gültigen Stimmen", ylim = c(0, 55),
  main = "Nationalratswahlen in Österreich")

# Gitternetz einzeichnen
abline(v = wahl$Wahljahr, col = "grey")       # Vertikale Linien
abline(h = seq(0, 55, by = 5), col = "grey")  # Horizontale Linien
abline(h = 50, col = "grey", lwd = 3)         # Absolute Mehrheit

# Parteifarben definieren und Ergebnisverläufe einzeichnen
parteifarben <- c(SPÖ = "red", ÖVP = "black", FPÖ = "blue", KPÖ = "brown",
  Grüne = "chartreuse4", BZÖ = "orange", FRANK = "gray40",
  NEOS = "deeppink2", PILZ = "chartreuse", Sonstige = "gray80")

matlines(wahl$Wahljahr, wahl[-1], lty = 1, type = "b", pch = 1,
  col = parteifarben[names(wahl)[-1]], lwd = 1)

# Achsen und Legende einzeichnen
box()
axis(1, at = wahl$Wahljahr, las = 2, cex.axis = 0.8)
axis(2, at = seq(0, 55, by = 5), las = 2)

legend(min(wahl$Wahljahr), 55/2, legend = names(wahl)[-1],
  col = parteifarben[names(wahl)[-1]], lwd = 2, bg = "white",
  yjust = 0.5, ncol = 2, inset = c(0.03, 0))


### -------------------------------------------------------------------------
### 35.1.2  Balkendiagramme -- barplot()


# Selektiere Ergebnisse aller 2017 angetretenen Parteien als Vektor
wahl17 <- unlist(wahl[wahl$Wahljahr == 2017, -1])
wahl17 <- wahl17[!is.na(wahl17)]
wahl17

# Linkes Balkendiagramm zeichnen
barplot(wahl17, main = "Nationalratswahl 2017",
  col = parteifarben[names(wahl17)], las = 2)

# Jetzt absteigend sortieren und "Sonstige" hinten anhängen
wahl17.sort <- c(sort(wahl17[names(wahl17) != "Sonstige"],
  decreasing = TRUE), wahl17["Sonstige"])
wahl17.sort

# Rechtes Balkendiagramm zeichnen
barplot(wahl17.sort, main = "Nationalratswahl 2017",
  col = parteifarben[names(wahl17.sort)], las = 2)


lighten <- function(color, faktor = 0.5) {
  # Hellt die übergebenen Farben auf.
  # color .... Vektor mit Farben
  # faktor ... Wert zwischen 0 und 1. Je grösser, desto heller.
	
  # Die Farben Richtung Weiss verschieben.
  col <- col2rgb(color)
  col <- col + (255 - col) * faktor
  return(rgb(col[1, ], col[2, ], col[3, ], max = 255))
}


# Selektiere die letzten beiden Wahlen als Matrix
wahl2 <- as.matrix(wahl[(nrow(wahl) - 1):nrow(wahl), -1])
wahl2

# Jetzt nach 2017 absteigend sortieren und Sonstige hinten anhängen
order <- c(order(wahl2[2, colnames(wahl2) != "Sonstige"],
  decreasing = TRUE, na.last = TRUE), ncol(wahl2))
order

# Parteifarben wählen (inkl. duplizieren und aufhellen)
farben <- rep(parteifarben[colnames(wahl2)[order]], each = 2)
farben[c(TRUE, FALSE)] <- lighten(farben[c(TRUE, FALSE)], 0.7)

# Gruppiertes Balkendiagramm zeichnen
barplot(wahl2[, order], main = "Nationalratswahl 2013 vs. 2017",
  col = farben, las = 2, beside = TRUE)


# wahl2 transponieren
wahl2t <- t(wahl2[, order])
colnames(wahl2t) <- c(2013, 2017)
wahl2t

# Fehlende Werte durch 0 ersetzen
wahl2t[is.na(wahl2t)] <- 0

# Farben auswählen
farben <- parteifarben[rownames(wahl2t)]

# Gestapeltes Balkendiagramm zeichnen
barplot(wahl2t, main = "Nationalratswahl 2013 vs. 2017",
  col = farben, las = 1, beside = FALSE)


### -------------------------------------------------------------------------
### 35.1.3  Histogramme -- hist()


# Zufallszahlen ziehen
set.seed(111)
x <- rnorm(50)


# Histogramm zeichnen
hist(x)

# Histogramm zeichnen
hist(x, freq = FALSE)


# Säulen einfärben
hist(x, freq = FALSE,
  col = "lightblue")

# Säulen schraffieren
hist(x, freq = FALSE,
  density = 6, col = "black")


# Histogramm mit 4 Säulen
hist(x, freq = FALSE,
  breaks = 4)

# Histogramm mit 30 Säulen
hist(x, freq = FALSE,
  breaks = 30)


# Histogramm zeichnen
hist(x, col = "white")

# Zeige die inneren Ränder an
tmp <- par()$usr
tmp

# x- und y-Werte der Dichte
xx <- seq(tmp[1], tmp[2],
  length = 201)
yy <- dnorm(xx)

# Dichte zeichnen
lines(xx, yy, col = "red")


# Histogramm zeichnen
hist(x, freq = FALSE, col = "white")

# Zeige die inneren Ränder an
tmp <- par()$usr
tmp

# x- und y-Werte der Dichte
xx <- seq(tmp[1], tmp[2],
  length = 201)
yy <- dnorm(xx)

# Dichte zeichnen
lines(xx, yy, col = "red")


### -------------------------------------------------------------------------
### 35.1.4  Rückgabeobjekte von Grafikfunktionen verwerten


set.seed(111)
x <- rnorm(50)

res.hist <- hist(x, plot = FALSE)
res.hist

# Histogramm zeichnen
res.hist <- hist(x, col = "white")

# Mittelpunkt und Höhe der
# 3. Säule bestimmen
x1 <- res.hist$mids[3]
y1 <- res.hist$counts[3]

# Rote Linie in der 3. Säule
lines(c(x1, x1), c(0, y1),
  col = 2, lwd = 5)

# 5. Säule schraffieren
x1 <- res.hist$breaks[5:6]
y1 <- res.hist$counts[5]

x2 <- c(x1, rev(x1))
y2 <- c(0, 0, y1, y1)
x2
y2
polygon(x2, y2, density = 5)


### -------------------------------------------------------------------------
### 35.1.5  Boxplots -- boxplot()


# Iris-Daten laden
data(iris)
head(iris)

# Boxplot zeichnen
boxplot(iris$Sepal.Length,
  main = "Boxplot von Sepal.Length",
  ylab = "cm")

# Mit hellblauer Box
boxplot(iris$Sepal.Length,
  main = "Boxplot von Sepal.Length",
  ylab = "cm", col = "lightblue")


# Alle Sepal-Spalten selektieren
iris.sepal <- iris[grepl("Sepal", names(iris))]

# Boxplot zeichnen
boxplot(iris.sepal,
  main = "Boxplots für iris",
  ylab = "cm")

# Mit unterschiedlichen Farben
boxplot(iris.sepal,
  main = "Boxplots für iris",
  ylab = "cm", col = c(2, 4))


# 1. Möglichkeit
boxplot(
  iris$Sepal.Width ~ iris$Species)

# 3. Möglichkeit
plot(
  iris$Species, iris$Sepal.Width)



### -------------------------------------------------------------------------
### 35.2  Die Welt der Farben
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 35.2.1  RGB-Farben -- rgb()


# Farben definieren und zeichnen
col1 <- rgb(  0,   0,   0, max = 255)   # Schwarz
col2 <- rgb(127, 127, 127, max = 255)   # Grau
col3 <- rgb(255, 255, 255, max = 255)   # Weiss
col4 <- rgb(255,   0,   0, max = 255)   # Rot
col5 <- rgb(0  , 255, 255, max = 255)   # Türkis (Mische Grün und Blau)
col6 <- rgb(0  , 127, 127, max = 255)   # dunkleres Türkis
col7 <- rgb(255, 255,   0, max = 255)   # Gelb (Mische Rot und Grün)
col <- c(col1, col2, col3, col4, col5, col6, col7)

# Plotregion vorbereiten
dev.new(width = 7, height = 1)  # Neues Fenster der Breite 7 und Höhe 1
par(mar = rep(0, 4))            # Ränder entfernen

# Farben darstellen
barplot(rep(1, length(col)), space = 0, col = col, axes = FALSE)


### -------------------------------------------------------------------------
### 35.2.3  Standardfarbpaletten -- Palettes


# Plotregion vorbereiten
dev.new(width = 7, height = 1)  # Neues Fenster der Breite 7 und Höhe 1
par(mar = rep(0, 4))            # Ränder entfernen

x <- rep(1, 15)
n <- length(x)

# Ohne Farbübergabe
barplot(x, space = 0, axes = FALSE)
barplot(x, space = 0, axes = FALSE,
  col = rainbow(n))
barplot(x, space = 0, axes = FALSE,
  col = heat.colors(n))
barplot(x, space = 0, axes = FALSE,
  col = cm.colors(n))
barplot(x, space = 0, axes = FALSE,
  col = terrain.colors(n))
barplot(x, space = 0, axes = FALSE,
  col = topo.colors(n))


### -------------------------------------------------------------------------
### 35.2.4  Eigene Farbpaletten -- colorRamp(), colorRampPalette()


# Plotregion vorbereiten
dev.new(width = 7, height = 1)  # Neues Fenster der Breite 7 und Höhe 1
par(mar = rep(0, 4))            # Ränder entfernen

x <- rep(1, 15)
n <- length(x)


# von Weiss bis Schwarz
fun <- colorRampPalette(
  c("white", "black"))

barplot(x, space = 0, axes = FALSE,
  col = fun(n))


# Blau - Weiss - Rot
fun <- colorRampPalette(
  c(4, "white", 2))

barplot(x, space = 0, axes = FALSE,
  col = fun(n))


# Die Daten der fiktiven Umfrage
M <- matrix(c(0:4, (1:5) + 1), ncol = 2)  # absolute Häufigkeiten
M <- prop.table(M, 2)                     # Spaltenprozente
M

# Zeilen und Spalten beschriften
colnames(M) <- c("Gr. 1", "Gr. 2")
rownames(M) <- c("nicht wichtig", "eher nicht wichtig", "teils/teils",
  "eher wichtig", "wichtig")
M

# Eigene Farbpalette definieren:
# Von Blau (nicht wichtig) über Weiss (teils/teils) bis Rot (wichtig)
palette.fun <- colorRampPalette(c(4, "white", 2))

# Grafik zeichnen
barplot(M, col = palette.fun(nrow(M)), main = "Wichtigkeit der Statistik",
  legend.text = rownames(M), xlim = c(0, 6))



### -------------------------------------------------------------------------
### 35.3  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 35.3.1  Fallbeispiel: Farblich markierte Balkendiagramme


# Iris-Daten laden
data(iris)

# Farben für die Spezies aussuchen: Rot, Grün, Blau
hue <- c(0, 120, 240)
col.bar <- hcl(hue, 70, 70)     # Farben für die Balken
col.legend <- hcl(hue, 70, 50)  # Farben für die Legende (dunkler!)

# Speichere Histogrammdaten
hist.info <- hist(iris$Petal.Length, plot = FALSE)
hist.info[1:3]

class(hist.info)

# Farbloses Histogramm zeichnen. Interner Aufruf: plot.histogram()
plot(hist.info)

# 1.) Histogramm für jede Gruppe berechnen (mit denselben Breaks!)
temp <- tapply(iris$Petal.Length, iris$Species, function(u) {
  hist(u, breaks = hist.info$breaks, plot = FALSE)
})

# 2.) Ordne die counts zu einer Matrix an.
mat <- t(sapply(temp, function(x) x$counts))
mat

# Balkendiagramm zeichnen und Legende einzeichnen
barplot(mat, col = col.bar, axes = FALSE, space = 0)
legend("topright", legend = levels(iris$Species),
  pch = 15, col = col.legend, text.col = col.legend, bty = "n")

# Beschriftungen und y-Achse einzeichnen
title(main = "Histogramm von Petal.Length", ylab = "Anzahl", xlab = "cm")
axis(side = 2)   # y-Achse einzeichnen
axis(side = 1)   # x-Achse einzeichnen


# Breite der Balken bestimmen
width <- hist.info$breaks[2] - hist.info$breaks[1]

# Balkendiagramm zeichnen und Legende einzeichnen
barplot(mat, width = width, col = col.bar, axes = FALSE, space = 0)
legend("topright", legend = levels(iris$Species),
  pch = 15, col = col.legend, text.col = col.legend, bty = "n")

# Beschriftungen und y-Achse einzeichnen
title(main = "Histogramm von Petal.Length", ylab = "Anzahl", xlab = "cm")
axis(side = 2)

# x-Achse einzeichnen
xx <- pretty((0:ncol(mat)) * width)
xx
axis(side = 1, at = xx, labels = xx + hist.info$breaks[1])
