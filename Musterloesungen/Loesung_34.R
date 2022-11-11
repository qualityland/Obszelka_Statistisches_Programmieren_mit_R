### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 34
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Dichtefunktion definieren
ddreieck5 <- function(x) {
  pmax(0, 1 - abs(x))
}

# x- und y-Werte definieren
# Wir definieren für x eine Sequenz zwischen -1.5 und 1.5. In diesem Fall
# bietet es sich an, by zu verwenden, damit die Stellen -1, 0 und +1 (jene
# Stellen, an denen die Funktion einen Knick hat) sicher im Vektor
# enthalten sind.
x <- seq(-1.5, 1.5, by = 0.1)
y <- ddreieck5(x)

# Grafik vorbereiten
# Um Platz für die Legende oben rechts zu schaffen, wird der Wertebereich
# der y-Achse um 20% vergroessert.
xlim <- range(x)
ylim <- c(min(y), max(y) * 1.2)

# Einen leeren Plot zeichnen, Wertebereich definieren und Beschriftungen
# hinzufuegen.
plot(x, y, type = "n", xlab = "x", ylab = "f(x)",
  main = "Dichte einer symmetrischen Dreiecksverteilung",
  xlim = xlim, ylim = ylim)

# Gitter einzeichnen
grid(lty = 1, col = "darkgrey")

# Dichtefunktion einzeichnen
lines(x, y, col = 4, lwd = 2)

# Legende rechts oben einzeichnen
# Damit die Legende nicht am Rand klebt, waehlen wir als rechten oberen
# Eckpunkt (angedeutet durch xjust = 1 und yjust = 1) den Punkt max(xlim)
# und max(ylim).
legend(x = max(xlim), y = max(ylim), xjust = 1, yjust = 1,
  legend = "f(x) = max(0, 1 - |x|)", col = 4, lwd = 2, bg = "white")



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# iris-Daten laden
data(iris)

# Definiere Farben und Punktformen für jede Spezies
col.roh <- c(2, 3, 4)
pch.roh <- c(1, 2, 3)

# Weise den Punkten die korrekten Farben und Symbole zu
col <- col.roh[iris$Species]
pch <- pch.roh[iris$Species]

# Grafik zeichnen
plot(iris$Sepal.Length, iris$Sepal.Width, 
  main = "Iris: Sepal.Width ~ Sepal.Length", col = col, pch = pch)

# Mittelwerte getrennt nach Spezies berechnen
mw.length <- tapply(iris$Sepal.Length, iris$Species, mean, na.rm = TRUE)
mw.width  <- tapply(iris$Sepal.Width, iris$Species, mean, na.rm = TRUE)

# Mittelwertsvektoren einzeichnen
points(mw.length, mw.width, col = col.roh, pch = 16, cex = 2)

# Legende einzeichnen (links oben)
legend("topright", legend = levels(iris$Species),
  col = col.roh, pch = pch.roh)


# Die Bluetenblaetter sind besser geeignet. Die Gattung setosa laesst sich
# sowohl bei Bluetenblaettern als auch bei den Kelchblaettern gut von den
# anderen beiden Gattungen unterscheiden, die Gattungen versicolor und
# virginica unterscheiden sich bei Bluetenblaettern allerdings deutlicher
# voneinander.



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


### Uebertrag

# Zunaechst uebertragen wir die Daten und die Berechnung der Regressions-
# geraden.

# Die Daten (verwenden hier eine Doppelzuweisung)
x <- groesse <- c(184, 168, 160, 168, 170, 168, 163, 170)
y <- gewicht <- c(65, 70, 48, 52, 53, 56, 56, 59)

# Matrix X erstellen: Erste Spalte modelliert das Interzept.
X <- cbind(1, x)
X

# OLS-Schätzer berechnen
beta.hat <- solve(crossprod(X)) %*% crossprod(X, y)
as.vector(beta.hat)   # Interzept und Steigung

# Prognostizierte Werte berechnen
y.hat <- as.vector(X %*% beta.hat)
y.hat

# Residuen berechnen
u.hat <- y - y.hat
round(u.hat, digits = 4)


### Grafik zeichnen

# Grafik zeichnen
plot(groesse, gewicht, main = "Regressionsbeispiel: Gewicht vs. Größe",
  xlab = "Körpergröße in cm", ylab = "Gewicht im kg")

# Regressionsgerade und Residuen einzeichnen
lines(sort(x), y.hat[order(x)], col = 2)
segments(x, y, x, y.hat, col = 4)

# Legende einzeichnen: Wir waehlen die rechte untere Ecke
legend(max(x), min(y), xjust = 1, yjust = 0,
  legend = c("Regressionsgerade", "Residuen"), col = c(2,4), lwd = 1)



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Grafik vorbereiten
par(pty = "s")  # Quadratische Plotregion
plot(0.5:8.5, 0.5:8.5, axes = FALSE, xlab = "", ylab = "", type = "n")

# Schachbrettmuster einzeichnen
# Hier kommt die Modifikation mit rect() ins Spiel.

# Schritt 1: linken unteren (x1 und y1) Eckpunkt jedes Feldes bestimmen.
# Die rechten oberen Eckpunkte ergeben sich durch Addition von 1.
x1 <- y1 <- 0.5:7.5

# Wuerden wir folgendes eingeben, so wuerden nur die 8 Felder in der
# Diagonalen gezeichnet:
# rect(x1, y1, x1 + 1, y1 + 1)

# Daher arbeiten wir mit rep() um die Korrdinaten zu replizieren. Dabei
# halten wir zum Beispiel die x-Koordinaten jeweils 8 Mal fest (each = 8)
# und die y-Koordinaten replizieren wir 8 Mal als Ganzes (times = 8). Ginge
# auch umgekehrt.

x1.rep <- rep(x1, each = 8)
y1.rep <- rep(y1, times = 8)

# Jetzt fehlen noch die Farben. Wir fangen links unten mit schwarz an
# (col = 1). Wir befuellen das Brett von links unten beginnend *zeilenweise*.
# Das heißt, wir brauchen fuer die erste Zeile den Vektor 1 0 1 0 1 0 1 0.
col1 <- rep(c(1, 0), times = 4)
col1

# Die naechste Zeile faengt bei 0 an.
col2 <- rep(c(0, 1), times = 4)
col2

# col1 und col2 muessen wir jetzt verketten und dann 4 Mal wiederholen.
col <- rep(c(col1, col2), times = 4)
col

# Jetzt haben wir alles zusammengetragen, was wir brauchen :-)
rect(x1.rep, y1.rep, x1.rep + 1, y1.rep + 1, col = col)


# Achsen einzeichnen
axis(1, at = 1:8, LETTERS[1:8], lwd = 0, padj = -2)
axis(2, at = 1:8, 1:8, lwd = 0, padj = 2)
axis(3, at = 1:8, LETTERS[1:8], lwd = 0, padj = 2)
axis(4, at = 1:8, 1:8, lwd = 0, padj = -2)



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


# Funktion circle() aus dem Uhrenbeispiel
circle <- function(mx = 0, my = 0, radius = 1, prec = 360) {

  # Diese Funktion berechnet kartesische Kreiskoordinaten
  # mx und my ... Mittelpunkt des Kreises
  # radius ...... Radius des Kreises
  # prec ........ Anzahl der Punkte (Präzision)
  # Gibt eine (prec + 1) Mal 2 - Matrix mit kartesischen Koordinaten zurück
	
  # Berechnung der kartesischen Koordinaten
  winkel <- seq(0, 2 * pi, length = prec + 1)
  x <- radius * cos(winkel)
  y <- radius * sin(winkel)

  invisible(cbind(x = x + mx, y = y + my))
}


dev.new()
par(pty = "s")  # quadratische Plotregion

# Bereite die Plotregion vor
plot(-5:5, -5:5, type = "n",
  main = "Triffst du ins Schwarze?", axes = FALSE,
  xlab = "", ylab = "")

# Zeichne die Kreise ein; Die Farbe wechselt hierbei.
color <- rep(c("black", "white"), length = 5)

# Wichtig ist, dass wir die Kreise von aussen nach innen zeichnen. Das
# heisst, innere Kreise ueberdecken die groesseren aeusseren Kreise.
for (i in 5:1) {
  polygon(circle(radius = i), col = color[i])
}

# Zeichne die Wertigkeiten ein
wertigkeit <- seq(100, 20, by = -20)
text(rep(0, 5), c(0, 1.5:4.5), label = wertigkeit,
  col = c("white", "black"), cex = 1)
	


### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


# Funktion circle() aus dem Uhrenbeispiel
circle <- function(mx = 0, my = 0, radius = 1, prec = 360) {

  # Diese Funktion berechnet kartesische Kreiskoordinaten
  # mx und my ... Mittelpunkt des Kreises
  # radius ...... Radius des Kreises
  # prec ........ Anzahl der Punkte (Präzision)
  # Gibt eine (prec + 1) Mal 2 - Matrix mit kartesischen Koordinaten zurück
	
  # Berechnung der kartesischen Koordinaten
  winkel <- seq(0, 2 * pi, length = prec + 1)
  x <- radius * cos(winkel)
  y <- radius * sin(winkel)

  invisible(cbind(x = x + mx, y = y + my))
}


# Wir markieren Aenderungen mit ##** 
# Die wesentliche Idee: Wir brauchen jetzt doppelt so viele
# Stundenmarkierungen.
# Die Funktion selbst erweitern wir um einen Parameter format, mit dem
# wir zwischen dem 12- und dem 24-Stundenformat switchen koennen. Als
# Defaultwert nehmen wir das 12-Stundenformat.

uhr <- function(format = 12) {

  # Parameter format checken
  if (!format %in% c(12, 24)) {
    stop("format muss entweder 12 oder 24 sein!\n")
  }

  # Grafikfenster vorbereiten und Umriss einzeichnen
  dev.new()                          # Neues Grafikfenster öffnen
  par(pty = "s", mar = rep(0.5, 4))  # Grafikränder verkleinern
  plot(circle(), type = "l", axes = FALSE, xlab = "", ylab = "",
    xlim = c(-1.1, 1.1), ylim = c(-1.1, 1.1))

  ##** Segmente vorbereiten: Bereite 120 Haeckchen vor
  ##** 12 oder 24 fuer die Stunden und 60 fuer die Minuten.
  ##** 120 kann durch 24 und 60 geteilt werden.
  p1 <- circle(prec = 120)
  p2 <- circle(prec = 120, radius = 0.95)

  ##** Die Stunden und damit automatisch auch alle 5 Minuten werden
  ##** deutlich gekennzeichnet und verbunden.
  ##** k ist eine Hilfsvariable, die uns hilft zu beurteilen, wie viele
  ##** Haeckchen wir ueberspringen muessen um alle Stunden zu verbinden.
  ##** Beim 12-Stundenformat ist jedes 10. Haekchen relevant, beim
  ##** 24-Stundenformat ist jedes 5. Haekchen relevant.
  k <- ifelse(format == 12, 2, 1)
  bool.h <- rep(rep(c(TRUE, FALSE), times = c(1, 5 * k - 1)), length = 120)
  seg <- p1[bool.h, ]

  ##** Die Segmente abhaengig vom Format einzeichnen
  ##** ind markiert das Ende der ersten Haelfte der Uhr, damit ist es
  ##** leichter fuer uns, gegenueberliegende Enden zu finden.
  ind <- (nrow(seg) - 1) / 2
  segments(seg[1:ind, 1], seg[1:ind, 2],
    seg[(ind + 1):(2 * ind), 1], seg[(ind + 1):(2 * ind), 2], col = "grey")

  ##** Haekchen für jede Minute einzeichnen
  ##** Da wir jetzt 120 statt 60 Stellen haben, selektieren wir jede zweite.
  p1.min <- p1[c(TRUE, FALSE), ]
  p2.min <- p2[c(TRUE, FALSE), ]
  segments(p1.min[, 1], p1.min[, 2], p2.min[, 1], p2.min[, 2],
    lwd = 2 * bool.h + 2, col = c(2, 4)[bool.h + 1])

  # Systemzeit abfragen und in Winkel umrechnen
  time <- as.POSIXlt(Sys.time())    # Uhrzeit als Liste time

  ##** Bei der Stunde muessen wir wieder format beruecksichtigen.
  stunde <- -(time$hour %% format / format + time$min / 60 / format) *
    2 * pi + pi / 2
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
  ##** prec und Beschriftungen orientiert sich jetzt an format.
  temp <- circle(prec = format, radius = 1.1)

  if (format == 24) {
    w <- temp[c(7:1, 24:8), ]
  }
  else {
    w <- temp[c(4:1, 12:5), ]
  }
  text <- c(format, 1:(format - 1))

  # Rotiere die Stundenzahlen mit srt (String RoTation)
  ##** by ist jetzt von format abhaengig.
  srt <- seq(360, 1, by = -360 / format)
  for (i in 1:length(srt)) {
    text(w[i, 1], w[i, 2], text[i], srt = srt[i])
  }
}

# Teste unsere Funktion
uhr(format = 12)
uhr(format = 24)

