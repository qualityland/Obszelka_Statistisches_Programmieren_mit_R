### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 34: Einführung in die 2D-Grafik
### -------------------------------------------------------------------------


# Iris-Datensatz laden
data(iris)
head(iris, n = 4)



### -------------------------------------------------------------------------
### 34.1  Basisfunktion zur Grafikerstellung -- plot()
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 34.1.1  Erste Grafiken und Einstellungen


# Definiere Beispielpunkte
x <- c(1, 2, 3, 4, 5)   # x-Koordinaten der Beispielpunkte
y <- c(2, 5, 4, 1, 3)   # y-Koordinaten der Beispielpunkte

plot(x = x, y = y,
  main = "Punktegrafik")

plot(x, y, type = "l",
  main = "Liniengrafik")

plot(x, y, type = "b",
  main = "Punkte und Linien")

plot(x, y, type = "n",
  main = "Leere Grafik")

plot(x, y, type = "S",
  main = "Treffengrafik S",
  sub = "Variante S")

plot(x, y, type = "s",
  main = "Treppengrafik s",
  sub = "Variante s")


# Stabdiagramme: angelehnt an Histogramme
plot(x, y, type = "h", main = "Stabdiagramm")

# Beschrifte die Achsen und verändere den Zeichnungsbereich
plot(x, y, type = "h", main = "Stabdiagramm",
  xlab = "Anzahl", ylab = "Häufigkeiten",
  xlim = c(0, max(x)), ylim = c(0, max(y) + 1))


# x und y verknüpfen
M <- cbind(x, y)
M

# plot() mit n x 2 Matrix
plot(M,
  main = "Grafik aus Matrix",
  xlab = "x-Achse = 1. Spalte",
  ylab = "y-Achse = 2. Spalte")


### -------------------------------------------------------------------------
### 34.1.2  Streudiagramme zum Ersten -- plot()


# Streudiagramm zeichnen
plot(x = iris$Petal.Length, y = iris$Petal.Width,
  main = "Darstellung der iris-Daten",
  xlab = "Petal Length", ylab = "Petal Width")



### -------------------------------------------------------------------------
### 34.2  Grafikparameter steuern -- par()
### -------------------------------------------------------------------------


# pch (point character) speichert die Form der Punkte
par()$pch  # Defaultwert 1 entspricht den Ringen

# col (color) steuert die Farbe der Punkte
par()$col  # Defaultwert "black" entspricht Schwarz

# cex (character expansion) regelt die Grösse der Punkte
par()$cex  # Defaultwert 1 entspricht der Normalgrösse

# Definiere Beispielpunkte
x <- c(1, 2, 3, 4, 5)  # x-Koordinaten der Beispielpunkte
y <- c(2, 5, 4, 1, 3)  # y-Koordinaten der Beispielpunkte


### -------------------------------------------------------------------------
### 34.2.1  Skalierung -- cex


# Betrachte die Standardwerte für die 5 cex-Parameter
par()[c("cex", "cex.axis", "cex.lab", "cex.main", "cex.sub")]


# cex in par() umstellen
par(cex = 2)
par()$cex
plot(x, y, main = "Maintext",
  cex.main = 0.6, cex.axis = 0.5)

# cex in par() umstellen
par(cex = 1)
par()$cex
plot(x, y, main = "Maintext",
  cex = 2, cex.main = 1.2)


### -------------------------------------------------------------------------
### 34.2.3  Punktarten -- pch


# cex, col vektorwertig definieren
# pch mit Nummerncodes definieren
plot(x, y, cex = 1:5, col = 1:5,
pch = 1:5)

# cex, col für alle Punkte gleich
# pch mit Zeichen definieren
plot(x, y, cex = 2, col = 4,
pch = c("A", "B", "C", "+", "@"))


### -------------------------------------------------------------------------
### 34.2.5  Hintergrundfarbe -- bg, "transparent"


par()$bg


### -------------------------------------------------------------------------
### 34.2.6  Umgang mit par()


par(lwd = 1)             # setzt lwd auf 1
par(cex = 1.5, col = 2)  # setzt cex auf 1.5 und die Farbe auf Rot

# Speichere aktuelle Einstellungen und überschreibe lwd und cex
par.alt <- par(lwd = 2, cex = 2)
par()$lwd   # Auf 2 eingestellt

# Diverser Code zur Grafikerstellung und -bearbeitung

# Zurücksetzen der par()-Einstellungen
par(par.alt)
par()$lwd   # Wieder auf 1 zurückgesetzt


### -------------------------------------------------------------------------
### 34.2.7  Streudiagramme zum Zweiten


# Definiere Farben und Punktformen für jede Spezies
col.roh <- c(2, 3, 4)
pch.roh <- c(1, 2, 3)

# Weise den Punkten die korrekten Farben und Symbole zu
col <- col.roh[iris$Species]
pch <- pch.roh[iris$Species]

# Grafik zeichnen
plot(iris$Petal.Length, iris$Petal.Width, col = col, pch = pch)



### -------------------------------------------------------------------------
### 34.3  Grafikelemente hinzufügen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 34.3.1  Punkte, Linien, Texte -- points(), lines(), text(), mtext()


# Grafik zeichnen
plot(iris$Petal.Length, iris$Petal.Width, 
  main = "Iris: Petal.Width ~ Petal.Length", col = col, pch = pch)

# Mittelwerte getrennt nach Spezies berechnen
mw.length <- tapply(iris$Petal.Length, iris$Species, mean, na.rm = TRUE)
mw.width  <- tapply(iris$Petal.Width, iris$Species, mean, na.rm = TRUE)

# Mittelwertsvektoren einzeichnen
points(mw.length, mw.width, col = col.roh, pch = 16, cex = 2) 
text(2, c(2.5, 2.25, 2), labels = levels(iris$Species), col = col.roh)


### -------------------------------------------------------------------------
### 34.3.2  Legenden -- legend()


# Grafik zeichnen
plot(iris$Petal.Length, iris$Petal.Width,
  main = "Iris: Petal.Width ~ Petal.Length", col = col, pch = pch)

# Legende einzeichnen (links oben)
legend("topleft", legend = levels(iris$Species),
  col = col.roh, pch = pch.roh)


plot(iris$Petal.Length, iris$Petal.Width,
  main = "Iris: Petal.Width ~ Petal.Length", col = col, pch = pch)

# Legende einzeichnen (rechts unten)
legend(x = max(iris$Petal.Length), y = min(iris$Petal.Width),
  xjust = 1, yjust = 0, col = col.roh, pch = pch.roh,
  legend = levels(iris$Species))


plot(iris$Petal.Length,
  iris$Petal.Width,
  col = col, pch = pch)

legend("topleft", inset = 0.05,
  legend = levels(iris$Species),
  pch = pch.roh, col = col.roh,
  bg = "lightgray",
  text.col = col.roh)


plot(iris$Petal.Length,
  iris$Petal.Width,
  col = col, pch = pch)

legend("topleft",
  inset = c(0.02, 0.05),
  legend = levels(iris$Species),
  pch = pch.roh, col = col.roh,
  title = "Spezies", bty = "n")


### -------------------------------------------------------------------------
### 34.3.3  Boxen, Gitter, Achsen -- box(), grid(), axis(), pretty()


# Definiere die x|y Koordinaten
x <- seq(-2, 2, length = 201)  # Bildgenauigkeit
y <- tanh(x)

# axes = FALSE => keine Box und keine Achsen
plot(x, y, type = "l", axes = FALSE, lwd = 2, 
  col = 4, main = "Tangenshyperbolicus")

# Gitternetz einzeichnen
grid(lwd = 20, lty = 1)        # lwd = 20 ist zu dick, siehe gleich ;-)

# Achsen einzeichnen
axis(side = 1, pos = 0)        # Zeichne horizontale Achse bei y = 0
axis(side = 2, pos = 0)        # Zeichne vertikale Achse bei x = 0

# Zeichne eine "nette" Box ein
box(col = 2, lty = 2)


### -------------------------------------------------------------------------
### 34.3.4  Zeichenreihenfolge steuern -- type = "n"


# Definiere die x|y Koordinaten
x <- seq(-2, 2, length = 201)
y <- tanh(x)

# Schritt 1: Verhindere das Zeichnen der Funktionsgeraden
plot(x, y, type = "n", axes = FALSE, lwd = 2, 
  col = 4, main = "Tangenshyperbolicus")

# Schritt 2: Gitter und Achsen einzeichnen
grid(lwd = 20, lty = 1)
# Achsen einzeichnen
axis(side = 1, pos = 0)        # Zeichne horizontale Achse bei y = 0
axis(side = 2, pos = 0)        # Zeichne vertikale Achse bei x = 0

# Schritt 3: Funktionsgerade einzeichnen
lines(x, y, lwd = 2, col = 4)


### -------------------------------------------------------------------------
### 34.3.5  Rechtecke und Polygone -- rect(), polygon()


# Plotregion vorbereiten
par(pty = "s")   # Quadratische Plotregion einstellen
plot(0:5, 0:5, type = "n", xlab = "", ylab = "", main = "Polygone")

# Rotes Polygon zeichnen
x1 <- c(0, 0, 1, 1, 5, 5)
y1 <- c(0, 5, 5, 1, 1, 0)
polygon(x1, y1, col = 2, density = 8, angle = 90, border = NA)

# Blaues Polygon zeichnen
x2 <- c(2, 2, 3, 3, 5, 5)
y2 <- c(2, 5, 5, 3, 3, 2)
polygon(x2, y2, col = 4,
  density = 2)

# Oranges Polygon zeichnen
x3 <- c(4, 4, 5, 5)
y3 <- c(4, 5, 5, 4)
polygon(x3, y3, col = "orange")


### -------------------------------------------------------------------------
### 34.3.6  Adjustierungen und quadratische Plots -- adj, padj, par(pty =
###         "s")


# Grafik vorbereiten
par(pty = "s")  # Quadratische Plotregion
plot(0.5:8.5, 0.5:8.5, axes = FALSE, xlab = "", ylab = "", type = "n")

# Schachbrettmuster einzeichnen
for (i in 1:8) {
  for (j in 1:8) {
    x <- c(i - 0.5, i + 0.5, i + 0.5, i - 0.5)
    y <- c(j + 0.5, j + 0.5, j - 0.5, j - 0.5)
    polygon(x, y, col = (i + j + 1) %% 2)
  }
}

# Achsen einzeichnen
axis(1, at = 1:8, LETTERS[1:8], lwd = 0, padj = -2)
axis(2, at = 1:8, 1:8, lwd = 0, padj = 2)
axis(3, at = 1:8, LETTERS[1:8], lwd = 0, padj = 2)
axis(4, at = 1:8, 1:8, lwd = 0, padj = -2)


### -------------------------------------------------------------------------
### 34.3.7  Linien und Pfeile -- abline(), segments(), arrows()


# Plot mit dichteren Achsen
plot(1:10, 1:10, axes = FALSE)
box()
axis(1, 1:10)
axis(2, 1:10)

# Gitternetz einzeichnen
# grid() funktioniert hier nicht.
abline(h = 1:10,
  col = "grey", lty = "dotted")
abline(v = 1:10,
  col = "grey", lty = "dotted")

# zeichnet die Gerade a + b*x ein
abline(a = 0, b = 1, col = "red")

# Vorwärtspfeile (links --> rechts)
arrows(1, 5:10, 2, 5:10)
arrows(2, 5:10, 3, 5:10,
  angle = 60, length = 0.1)

# An beiden Enden Pfeile zeichnen
arrows(3, 5:10, 4, 5:10, code = 3)

# Blaue strichlierte Pfeile zeichnen
arrows(4, 5:10, 5:10, 4, col = 4,
  lty = "dashed", lwd = 3)

# Rote Linien und Pfeile zeichnen
segments(5:10, 4, 5:10, 2)
arrows(5:10, 2, 5:10, 1, col = 2)


### -------------------------------------------------------------------------
### 34.3.8  Titel und Überschriften -- title()


plot(0:1, 0:1,
  xlab = "", ylab = "")

# Titel und Achsenbeschriftungen
# hinzufügen
title(main = "Main",
  xlab = "xlab", ylab = "ylab")


plot(0:1, 0:1,
  xlab = "", ylab = "")

# line ändern
title(main = "Main 0", line = 0)
title(main = "Main 1", line = 1)
title(main = "Main 2", line = 2)



### -------------------------------------------------------------------------
### 34.4  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 34.4.1  Fallbeispiel: Uhr


circle <- function(mx = 0, my = 0, radius = 1, prec = 360) {
  # Diese Funktion berechnet Kreiskoordinaten
  # mx und my ... Mittelpunkt
  # radius ...... Radius des Kreises
  # prec ........ Anzahl der Punkte (Präzision)
  # Gibt eine (prec + 1) Mal 2 - Matrix zurück

  # Berechnung der kartesischen Koordinaten
  winkel <- seq(0, 2 * pi, length = prec + 1)
  x <- radius * cos(winkel)
  y <- radius * sin(winkel)

  # Unsichtbare Rückgabe der kartesischen Koordinaten
  invisible(cbind(x = x + mx, y = y + my))
}


uhr <- function() {
  # Grafikfenster vorbereiten und Umriss einzeichnen
  dev.new()                          # Neues Grafikfenster öffnen
  par(pty = "s", mar = rep(0.5, 4))  # Grafikränder verkleinern
  plot(circle(), type = "l", axes = FALSE, xlab = "", ylab = "",
    xlim = c(-1.1, 1.1), ylim = c(-1.1, 1.1))

  # Segmente vorbereiten: Jede der 60 Minuten bekommt ein Häkchen ...
  p1 <- circle(prec = 60)
  p2 <- circle(prec = 60, radius = 0.95)

  # ... wobei alle 5 Minuten deutlich gekennzeichnet und verbunden werden.
  bool.5 <- rep(rep(c(TRUE, FALSE), times = c(1, 4)), length = 60)
  seg <- p1[bool.5, ]
  segments(seg[1:6, 1], seg[1:6, 2], seg[7:12, 1], seg[7:12, 2], col = "grey")  

  # Häkchen für jede Minute einzeichnen
  segments(p1[, 1], p1[, 2], p2[, 1], p2[, 2],
    lwd = 2 * bool.5 + 2, col = c(2, 4)[bool.5 + 1])

  # Systemzeit abfragen und in Winkel umrechnen
  time <- as.POSIXlt(Sys.time())
  stunde <- -(time$hour %% 12) * pi / 6 + pi/2 - (time$min / 60) * pi/6
  minute <- -(time$min) * pi/30 + pi/2

  # Umrechnung in kartesische Koordinaten
  # Koordinaten des Stundenzeigers: x[1] und y[1]
  # Koordinaten des Minutenzeigers: x[2] und y[2]
  # Der Minutenzeiger soll länger sein als der Stundenzeiger.
  x <- c(0.6, 0.85) * cos(c(stunde, minute))
  y <- c(0.6, 0.85) * sin(c(stunde, minute))

  # Zeiger einzeichnen
  arrows(0, 0, x, y, lwd = 2)
  points(0, 0, pch = 16, col = 4, cex = 2)

  # Beschrifte die Stunden der Uhr
  temp <- circle(prec = 12, radius = 1.1)
  w <- temp[c(4:1, 12:5), ]
  text <- c(12, 1:11)

  # Rotiere die Stundenzahlen mit srt (String RoTation)
  srt <- seq(360, 1, by = -30)  # srt funktioniert leider nicht vektorwertig!
  for (i in 1:length(srt)) {
    text(w[i, 1], w[i, 2], text[i], srt = srt[i], cex = 1.7)
  }
}

uhr()   # Aktuelle Zeit als Uhr darstellen
