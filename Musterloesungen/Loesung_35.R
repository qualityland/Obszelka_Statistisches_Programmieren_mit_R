### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 35
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


### Parameterkonstellation erstellen
shape <- c(2, 5, 10)
rate = c(1, 1, 1)

# x- und y-Werte definieren
# x-Werte: Den Wert fuer to bestimmen wir sinnvoll per Hand. Man kann einen
#   guten Wert auch automatisiert finden: Dazu muessen wir uns fuer alle
#   Parameterkonstellationen bererchnen, ab welchem Wert die Verteilungs-
#   funktion einen vorgegebenen Wert (etwa 0.99) ueberschreiten. Das
#   ueberlassen wir dir als Uebung ;-)
# y-Werte: Wir erstellen eine Matrix mit 3 Spalten: eine Spalte fuer jede
#   Parameterkonstellation.
x <- seq(from = 0, to = 20, length = 201)
Y <- sapply(1:length(shape), function(i)
  dgamma(x, shape[i], rate[i]))

# Dichtefunktionen zeichnen
# Wir stellen zwei moegliche Varianten vor. In beiden Varianten bereiten
# wir zunaechst die Plotregion vor (type = "n"), dann zeichnen wir das
# Gitternetz ein. Schlussendlich zeichnen wir die Dichtefunktion ein.

# Variante 1: mit matplot() und matlines()
matplot(x, Y, type = "n", xlab = "x", ylab = "Dichte",
  main = "Dichtefunktion der Gammaverteilung")
grid(lty = 1, col = "darkgrey")
matlines(x, Y, type = "l", lty = 1, col = 1:3)

# Variante 2: mit plot() und lines()
plot(range(x), range(Y), type = "n", xlab = "x", ylab = "Dichte",
  main = "Dichtefunktion der Gammaverteilung")
grid(lty = 1, col = "darkgrey")

for (j in 1:ncol(Y)) {
  lines(x, Y[, j], col = j)
}

# Legende einzeichnen
# Wir zeichnen die Legende rechts oben.
legend(x = max(x), y = max(Y), xjust = 1, yjust = 1,
  legend = paste0("shape = ", shape, ", rate = ", rate),
  lwd = 1, col = 1:3, bg = "white")



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Folgende Idee bzw. folgendes Vorgehen
# 0.) Ziehe 50 standardnormalverteilte Zufallszahlen
# 1.) Berechne das Histogramm und speichere die Rueckgabe
# 2.) Bestimme den Bereich fuer die x-Achse
# 3.) Berechne die Dichte fuer diese x-Werte.
# 4.) Zeichne das Histogramm erneut. Berechne aus den Rueckgaben von 1.)
#     und den Werten aus 3.) gute Werte fuer ylim.
# 5.) Faerbe die hoechsten Balken ein.
# 6.) Zeichne die Dichte ein.


# 0.) Ziehe 50 standardnormalverteilte Zufallszahlen
x <- rnorm(50)

# 1.) Berechne das Histogramm und speichere die Rueckgabe
info <- hist(x, freq = FALSE)
info

# 2.) Bestimme den Bereich fuer die x-Achse

# Variante 1: mit par()$usr. Nachteil: Linie ragt horizontal ueber die
# Balken hinaus.
tmp <- par()$usr
xx <- seq(tmp[1], tmp[2], length = 201)

# Variante 2: ueber die Listenkomponente breaks von info.
tmp <- range(info$breaks)
xx <- seq(tmp[1], tmp[length(tmp)], length = 201)

# 3.) Berechne die Dichte fuer diese x-Werte.
yy <- dnorm(xx)

# 4.) Zeichne das Histogramm erneut. Berechne aus den Rueckgaben von 1.)
#     und den Werten aus 3.) gute Werte fuer ylim.
ylim <- c(0, max(info$density, yy))
hist(x, freq = FALSE, ylim = ylim)

# 5.) Faerbe die hoechsten Balken ein.
ind.max <- which(info$density == max(info$density))
ind.max

# ind.max enthaelt die Indizes jener Stellen von info$density, die maximal
# sind. Die zu jedem Balken gehoerigen x-Werte erhalten wir aus den
# breaks. Die breaks haben demgemaess ein Element mehr.
for (i in ind.max) {
  xi <- info$breaks[c(i, i+1)]
  yi <- c(0, info$density[i])

  rect(xi[1], yi[1], xi[2], yi[2], col = "lightblue")
}

# 6.) Zeichne die Dichte ein.
lines(xx, yy, col = 2)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


### Wahlergebnisse einlesen und aufbereiten

# Ggf. Arbeitsverzeichnis wechseln
# setwd(...)
wahl <- read.table("NRWahlen.txt", na.string = ".",
  dec = ",", header = TRUE, skip = 5, encoding = "UTF-8")

# Nicht angetretene Parteien in Sonstige stecken
tail(wahl, n = 3)

temp <- is.na(wahl[c(nrow(wahl) - 1, nrow(wahl)), ])
bool.na <- colSums(temp) == 2
which(bool.na)

# Sonstige updaten und nicht angetretene Parteien entfernen
temp <- wahl[c(names(which(bool.na)), "Sonstige")]
wahl$Sonstige <- rowSums(temp, na.rm = TRUE)
wahl[bool.na] <- list(NULL)
tail(wahl, n = 3)


### Grafik zeichnen

# Modifikationen gegenueber dem im Buch praesentierten Code sind mit ##** 
# markiert.

# Neues Fenster mit 8 inches Breite und 6 inches Höhe
dev.new(width = 8, height = 6)

# Plot vorbereiten: Dimension und Beschriftungen
##** ylim wird auf c(0, 65) gesetzt.
ylim <- c(0, 65)
matplot(wahl$Wahljahr, wahl[-1], type = "n", axes = FALSE,
  xlab = "Wahljahr", ylab = "Prozent der gültigen Stimmen", ylim = ylim,
  main = "Nationalratswahlen in Österreich")

# Gitternetz einzeichnen
abline(v = wahl$Wahljahr, col = "grey") # Vertikale Linien
abline(h = seq(0, 55, by = 5), col = "grey") # Horizontale Linien
abline(h = 50, col = "grey", lwd = 3) # Absolute Mehrheit

# Parteifarben definieren und Ergebnisverläufe einzeichnen
parteifarben <- c(SPÖ = "red", ÖVP = "black", FPÖ = "blue", KPÖ = "brown",
  Grüne = "chartreuse4", BZÖ = "orange", FRANK = "gray40",
  NEOS = "deeppink2", PILZ = "chartreuse", Sonstige = "gray80")
matlines(wahl$Wahljahr, wahl[-1], lty = 1, type = "b", pch = 1,
  col = parteifarben[names(wahl)[-1]], lwd = 1)

##** Achsen einzeichnen
##** Die y-Achse muss adaptiert werden.
box()
axis(1, at = wahl$Wahljahr, las = 2, cex.axis = 0.8)
axis(2, at = seq(0, max(ylim), by = 5), las = 2)

##** Legende einzeichnen
##** Modifikationen:
# Wir wählen als Position "top" (oben mittig). Damit die Legende nicht am
# Rand klebt, setzen wir inset = 0.02.
# ncol setzen wir auf 5, womit 5 Spalten gezeichnet werden.
legend("top", inset = 0.02, legend = names(wahl)[-1],
  col = parteifarben[names(wahl)[-1]], lwd = 2, ncol = 5, bg = "white")



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


### Daten eingeben
umfrage <- c("Sehr gefaehrlich" = 3, "Gefaehrlich" = 10,
  "Teils/teils" = 6, "Wenig Gefaehrlich" = 2, "Ungefaehrlich" = 4)
umfrage


### a)

# Erster Versuch
barplot(umfrage, main = "Gefaehrlichkeit von Genfood")

# Nicht alle Kategorien werden aus Platzgruenden angezeigt.
# Wir betrachten zwei Varianten zur Loesung des Problems.


### Variante 1: cex.names + Zeilenumbrueche in den Variablennamen

labels <- c("Sehr\ngefaehrlich", "Gefaehrlich", "Teils/\nteils",
  "Wenig\ngefaehrlich", "Ungefaehrlich")

# Wir koennen die labels als neue Beschriftungen des Vektors umfrage
# einsetzen oder wir verwenden den Parameter names.arg von barplot().
barplot(umfrage, main = "Gefaehrlichkeit von Genfood",
  cex.names = 0.8, names.arg = labels)


### Variante 2: Zwei separate x-Achsen erstellen

# Bestimme die Mittelpunkte der Balken
info <- barplot(umfrage, main = "Gefaehrlichkeit von Genfood")
info

# 1.) Erstelle ein Balkendiagramm ohne Beschriftungen
barplot(umfrage, main = "Gefaehrlichkeit von Genfood", names.arg = "")

# 2.) Zwei Achsen zeichnen. Jede zweite Kategorie wird dabei tiefer
# gesetzt. Dazu verwenden wir den Adjustierungsparameter padj; mit negativen
# Werten ruecken wir die Labels naeher an die Grafik heran, mit positiven
# Werten schieben wir die Labels von der Grafik weg. Mit tick = FALSE
# deaktivieren wir die Achsenlinien.
axis(1, at = info[c(TRUE, FALSE)], names(umfrage)[c(TRUE, FALSE)],
  tick = FALSE, padj = -1)
axis(1, at = info[c(FALSE, TRUE)], names(umfrage)[c(FALSE, TRUE)],
  tick = FALSE, padj = 1)


### b)

# Umfrage in eine einspaltige Matrix umwandeln
umfrage <- t(t(umfrage))
umfrage

# Erster Versuch: Schaut noch nicht so toll aus :-)
barplot(umfrage, main = "Gefaehrlichkeit von Genfood")

# Wir lassen uns von den Codes des Kapitels inspirieren.

# Eigene Farbpalette definieren:
# Von Blau (Sehr gefaehrlich) über Weiss (Teils/teils) bis Rot
# (Ungefaehrlich)
palette.fun <- colorRampPalette(c("blue", "white", "red"))

# Grafik zeichnen
# Mit xlim schaffen wir rechts Platz fuer die Legende. Diesen Wert finden
# wir hier am einfachsten per Hand, eine automatisierte Loesung ist zwar
# moeglich, aber etwas kompliziert.
barplot(umfrage, main = "Gefaehrlichkeit von Genfood",
  col = palette.fun(nrow(umfrage)), legend.text = rownames(umfrage),
  xlim = c(0, 3))


# Hinweis: Wirklich sinnvoll sind gestapelte Balkendiagramme dann, wenn
# wir mindestens zwei Gruppen miteinander vergleichen.



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


### Anmerkungen zu Beginn

# Wir besprechen mehrere Varianten. In a) schreiben wir eine Funktion, die
# uns die Folgenglieder berechnet und zurueckgibt. Dabei legen wir Wert
# darauf, die Anzahl der Iterationen moeglichst klein zu halten. Sofern
# n >> T, ist eine Schleife ueber die Zeitschritte effizient. Loesungen,
# die darauf abzielen, ueber die Anzahl der Durchlaeufe zu iterieren, sind
# dann nicht effizient. Folgende Idee (schematisch aufgeschrieben) ist daher
# nicht empfehlenswert.

# n <- 10^6
# T <- 100
# res <- matrix(0, nrow = n, ncol = T+1)
# for (i in 1:n) {
#   res[i, ] <- cumsum(c(0, rnorm(n = T)))
# }
# res

# Waere hingegen T >> n, so aendert sich die Situation.


### a)

prozess <- function(n = 10^6, T = 100) {
  # Berechnet n Folgen der folgenden Bauart:
  # f(t) = f(t - 1) + xt  fuer t > 0, wobei xt ~ N(0, 1)
  # f(0) = 0
  # Erstellt eine Grafik, die den Quantilsverlauf darstellt.
  # Gibt eine n x (T + 1) Matrix mit den Zustaenden von jedem
  # Zeitpunkt zurueck.
  # n ... Anzahl der simulierten Folgen (Trajektorien)
  # T ... Anzahl der Zeitschritte

  # Schritt 1: Startwert 0 festlegen und T Zufallszahlen pro Trajektorie
  X <- cbind(0, matrix(rnorm(n * T), ncol = T))

  # Schritt 2: Kumulieren: Besonders effizient, falls n >> T gilt.
  for (j in 2:(T+1)) {
    X[, j] <- X[, j-1] + X[, j]
  }

  return(X)
}

# Testaufruf der Funktion
res <- prozess(n = 10, T = 5)
res


### b)

berechneQuantile <- function(X) {
  # Berechnet fuer eine Matrix X spaltenweise die 0%, 10%, ..., 100%-
  # Quantile.
  # Gibt eine 11 x ncol(X)-Matrix zurueck.

  # Schritt 1: Quantilsmatrix vorbereiten
  Q <- matrix(nrow = 11, ncol = ncol(X))

  # Quantile spaltenweise berechnen
  prob <- seq(0, 1, by = 0.1)
  for (j in 1:ncol(Q)) {
    Q[, j] <- quantile(X[, j], prob = prob)
  }

  # Zeilennamen fuer Q definieren
  rownames(Q) <- paste0(round(100 * prob, 3), "%")

  # Quantile zurueckgeben
  return(Q)
}

# Testaufruf der Funktion
berechneQuantile(res)


### Eine allgemein programmierte Variante

# Vier Modifikationen im Simulationsprozess werden vorgenommen:

# 1.) Die Anzahl der Quantile ist flexibel einstellbar.
#     In folgender Variante ist die Anzahl der Quantile frei einstellbar.
#     Das heisst, wir koennen mit dem Parameter anz.quantil etwa auch nur
#     die Quartile bestimmen (0%, 25%, 50%, 75%, 100%). Mit anz.quantil = 5
#     ist das moeglich.
# 2.) Es werden nur noch die Quantile zurueckgegeben.
#     Die Simulation wird derart umgebaut, dass nicht mehr alle Werte der
#     Matrix X als Ganzes simuliert werden, sondern immer nur einzelne
#     Zeitschritte verarbeitet werden. Anstatt also n x (T+1) Werte
#     zu verwalten, verwalten wir nur noch n Werte. Dadurch wird weniger
#     Arbeitsspeicher gebraucht. Nachteil: Die originalen Folgenwerte
#     koennen im Nachhinein nicht rekonstruiert werden. Wenn wir nur die
#     Quantile brauchen, so stoert uns das aber nicht.
# 3.) Einbau eines Seeds
#     Damit koennen wir Ergebnisse reproduzieren.
# 4.) Rueckgabe wird um Simulationsinfo erweitert.
#     Wir geben neben den Quantilen auch die Werte fuer n, T, anz.quantil
#     und seed zurueck, damit spaeter die Plotfunktion darauf zugreifen kann.

prozess <- function(n = 10^6, T = 100, anz.quantil = 11, seed = NA) {
  # Berechnet n Folgen der folgenden Bauart:
  # f(t) = f(t - 1) + xt  fuer t > 0, wobei xt ~ N(0, 1)
  # f(0) = 0
  # Erstellt eine Grafik, die den Quantilsverlauf darstellt.
  # Gibt eine anz.quantil x (T + 1) Matrix mit den Quantilen von jedem
  # Zeitpunkt zurueck.
  # n ............. Anzahl der simulierten Folgen (Trajektorien)
  # T ............. Anzahl der Zeitschritte
  # anz.quantil ... Anzahl der Quantile, die fuer jeden Zeitpunkt
  #                 berechnet werden sollen.
  # seed .......... Wird ein Seed uebergeben, so wird dieser verwendet.

  # Seed verwenden, so angegeben
  if (!is.na(seed)) {
    set.seed(seed)
  }

  # Startwert 0 festlegen und Quantilsmatrix vorbereiten
  # x enthaelt stets den aktuellen Zustand der n simulierten Folgen.
  x <- rep(0, n)
  Q <- matrix(nrow = anz.quantil, ncol = T + 1)

  # Quantile zum Zeitpunkt 0 bestimmen
  prob <- seq(0, 1, length = anz.quantil)
  Q[, 1] <- quantile(x, prob = prob)

  # Kumulieren und Quantile in Einem bestimmen
  for (j in 2:(T + 1)) {
    x <- x + rnorm(n)
    Q[, j] <- quantile(x, prob = prob)
  }

  # Zeilennamen fuer Q definieren
  rownames(Q) <- paste0(round(100 * prob, 3), "%")

  # Liste erstellen und zurueckgeben
  liste <- list(Q = Q, n = n, T = T, anz.quantil = anz.quantil, seed = seed)
  return(liste)
}

# Testaufruf der Funktion

# Dezile bestimmen (default)
res <- prozess(n = 10, T = 5)
res

# Quartile bestimmen
res <- prozess(n = 10, T = 5, anz.quantil = 5)
res

# Reproduzierbarkeit pruefen
res <- prozess(n = 10, T = 5, anz.quantil = 5, seed = 123)
res

res <- prozess(n = 10, T = 5, anz.quantil = 5, seed = 123)
res$Q

# Berechne mit denselben Zahlen andere Quantile
res <- prozess(n = 10, T = 5, anz.quantil = 11, seed = 123)
res$Q

# Die 0%, 50% und 100% Quantile sind daher ident!


### c)

plot.prozess <- function(liste, colors) {
  # Erstellt eine Grafik, die den Verlauf der Quantile eines stochastischen
  # Prozesses visualisiert.
  # liste .... Eine Liste, wie sie von der flexiblen Funktion prozess()
  #            erzeugt wurde.
  # colors ... Farben, die bei den Quantilen verwendet werden sollen. Die
  #            uebergebenen Farben werden in colorRampPalette() verwendet.
  #            Default: hcl(c(240, 0, 360), c(80, 20, 80), c(40, 80, 40))

  # Informationen extrahieren
  # Anmerkung: Es kann sein, dass einige Objekte bereits maskiert sind.
  # Das ist allerdings hier unproblematisch, da am Ende liste wieder
  # mit detach() eingepackt wird.
  attach(liste)

  # Farbpalette definieren - eine Moeglichkeit von extrem vielen!
  if (missing(colors)) {
    colors <- hcl(c(240, 0, 360), c(80, 20, 80), c(40, 80, 40))
  }

  # colorRampPalette erzeugt eine Farbfunktion
  colfun <- colorRampPalette(colors = colors)

  # Extrahiere anz.quantil - 1 Farben
  col <- colfun(anz.quantil - 1)

  # Grafik vorbereiten (Tipp: type = "n")
  main <- paste("Laufende Quantile des Prozesses")

  # ylim berechnen: Wir platzieren hier die Legende ganz oben, das heisst,
  # wir lassen oben etwas Raum (15% mehr Platz einfuegen).
  ylim <- range(Q)
  ylim <- ylim + diff(ylim) * c(0, 0.15)

  plot(0, type = "n",
    xlim = c(0, T), ylim = ylim,
    xlab = "t", ylab = "f(t)", main = main)

  # Anzahl der Folgen:
  mtext(side = 3, paste(n, "Folgen"))

  # Die Polygone einzeichnen
  for (i in 1:(anz.quantil - 1)) {
    xx <- c(0:T, T:0)
    yy <- c(Q[i, ], rev(Q[i+1, ]))
    polygon(xx, yy, col = col[i], border = NA)
  }

  # Legende einzeichnen
  legtext <- paste0(rownames(Q)[-anz.quantil], " - ", rownames(Q)[-1])
  legend(0, max(ylim), legend = legtext, col = col, pch = 15, ncol = 5,
    bg = "white", cex = 0.8)

  # Informationen wieder einpacken
  detach(liste)
}

plot.prozess(res)

# Simulation mit mehr Zeitschritten und Laeufen
res <- prozess(n = 10^6, T = 100)
plot.prozess(res)
plot.prozess(res, colors = grey(c(0.2, 0.8, 0.2)))


### Zusatzaufgaben

# Die Legenden haben wir bereits eingebaut :-)

# Um die Simulation flexibel hinsichtlich der Verteilung zu gestalten,
# boete es sich an, einen Parameter (nenne ihn etwa stepfun) einzubauen,
# der den Namen der auszufuehrenden Funktion erhaelt (standardmaessig
# rnorm. Das Dreipunkteargument erhaelt die Aufgabe, zusaetzliche Parameter
# fuer stepfun aufzunehmen.
# Aenderungen gegenueber oben sind mit ##** markiert.

prozess <- function(n = 10^6, T = 100, anz.quantil = 11, seed = NA,
  stepfun = rnorm, ...) {
  # Berechnet n Folgen der folgenden Bauart:
  # f(t) = f(t - 1) + xt  fuer t > 0, wobei xt ~ N(0, 1)
  # f(0) = 0
  # Erstellt eine Grafik, die den Quantilsverlauf darstellt.
  # Gibt eine anz.quantil x (T + 1) Matrix mit den Quantilen von jedem
  # Zeitpunkt zurueck.
  # n ............. Anzahl der simulierten Folgen (Trajektorien)
  # T ............. Anzahl der Zeitschritte
  # anz.quantil ... Anzahl der Quantile, die fuer jeden Zeitpunkt
  #                 berechnet werden sollen.
  # seed .......... Wird ein Seed uebergeben, so wird dieser verwendet.
  # stepfun ....... Zufallszahlenfunktion. Der erste Parameter muss fuer die
  #                 Anzahl der zu simulierenden Zahlen stehen.
  # ... ........... Weitere Parameter, die der Funktion stepfun uebergeben
  #                 werden.

  # Seed verwenden, so angegeben
  if (!is.na(seed)) {
    set.seed(seed)
  }

##**
  # stepfun auf function pruefen
  if (!is.function(stepfun)) {
    stop("stepfun muss eine Zufallszahlenfunktion sein!\n")
  }

  # Startwert 0 festlegen und Quantilsmatrix vorbereiten
  # x enthaelt stets den aktuellen Zustand der n simulierten Folgen.
  x <- rep(0, n)
  Q <- matrix(nrow = anz.quantil, ncol = T + 1)

  # Quantile zum Zeitpunkt 0 bestimmen
  prob <- seq(0, 1, length = anz.quantil)
  Q[, 1] <- quantile(x, prob = prob)

  # Kumulieren und Quantile in Einem bestimmen
  for (j in 2:(T + 1)) {
##** Ersetze rnorm(n) durch stepfun(n, ...)
    x <- x + stepfun(n, ...)
    Q[, j] <- quantile(x, prob = prob)
  }

  # Zeilennamen fuer Q definieren
  rownames(Q) <- paste0(round(100 * prob, 3), "%")

  # Liste erstellen und zurueckgeben
  liste <- list(Q = Q, n = n, T = T, anz.quantil = anz.quantil, seed = seed)
  return(liste)
}

# Testaufruf der Funktion

# Dezile bestimmen (default), rnorm verwenden (default)
res <- prozess(n = 10^5, T = 100)
plot.prozess(res)

# Erwartungswert steuern: Im Mittel wird bei jedem Zeitschritt mean
# hinzuaddiert (nicht notwendigerweise 0).
res <- prozess(n = 10^5, T = 100, mean = 0.5)
plot.prozess(res)

# Gleichverteilung in [0, 1]
res <- prozess(n = 10^5, T = 100, stepfun = runif)
plot.prozess(res)

# Gleichverteilung in [-1, 1]
res <- prozess(n = 10^5, T = 100, stepfun = runif, min = -1, max = +1)
plot.prozess(res)

