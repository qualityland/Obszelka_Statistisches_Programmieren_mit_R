### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 26
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


### a)

# Wenn wir summary eintippen, sehen wir, dass UseMethod("summary")
# aufgerufen wird.
summary


### b)

methods(summary)


### c)

geschlecht <- factor(c(1, 2, 2, 1), labels = c("Mann", "Frau"))
alter <- c(23, 26, 19, 27)
geschlecht
alter

# geschlecht ist ein Faktor; es wird summary.factor() aufgerufen.
# Dabei wird eine Haeufigkeitstabelle erstellt.
summary(geschlecht)
summary.factor(geschlecht)

# alter ist ein numerischer Vektor; es wird summary.default() aufgerufen.
# Dabei werden diverse Quantile, Mittelwert, Anzahl der NAs ausgegeben.
summary(alter)
summary.default(alter)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Anzahl der Münzwürfe
k <- 50

# Münzwürfe simulieren
RNGversion("4.0.2")
set.seed(29)
wurf <- sample(c("Z", "K"), size = k, replace = TRUE)

wurf


### a)

# Wir ueberlegen uns mit einem einfachen Objekt die Idee:
#  KZKKKZKK : Soll (1 3 2) ergeben

# 1.) Abfrage auf Gleichheit mit "K"
#   TFTTTFTT
# 2.) Kumulierte Summe bilden
#   11234456
#   x   x  x
# Wir suchen nach den letzten Stellen einer TRUE-Sequenz (mit x markiert).
# Diese erkennen wir daran, dass die Differenz zur naechsten Stelle 0
# und die Differenz zum vorherigen Element +1 ist.
# Wir schieben vorne eine 0 und hinten das Maximum ein, damit wir beide
# Merkmale einfacher erfragen koennen.
# 3.) 0 bzw. Maximum vorne bzw. hinten anhaengen und differenzieren
# 0|11234456|6
#   10111011 0
# 4.) 
#   TFTTTFTT  # Differenz ohne letztes Element == 1
#   TFFFTFFT  # Differenz ohne erstes Element == 0
#   TFFFTFFT  # Und-Verknuepfung
# 5.) Wir selektieren die Werte der kumulierten Summe an den letzten Stellen
#     einer TRUE-Sequenz.
#   1   4  6
# 6.) Wenn wir diesem Vektor eine 0 voranstellen und die Differenz bilden,
#     so haben wir die Run Lengths berechnet
#   0|146
#     132     # Die Run Lengths

# Setzen wir diese Idee um!

# 1.)
bool.kopf <- wurf == "K"
bool.kopf

# 2.)
x <- cumsum(bool.kopf)
x

# 3.)
x.temp <- c(0, x, max(x))
x.temp

x.diff <- diff(x.temp)
x.diff

# 4.) und 5.)
ind <- x[x.diff[-length(x.diff)] == 1 & x.diff[-1] == 0]
ind

# 6.)
diff(c(0, ind))

# Pruefen wir unseren Code mit rle()!


### b)

# rle() ist unkompliziert in der Anwendung
res <- rle(wurf)
res

# Betrachten wir die interne Verwaltung:
unclass(res)

# Wir selektieren nun aus der Komponente lengths jene Werte, die in values
# mit "K" markiert sind.
res$lengths[res$values == "K"]



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


M <- matrix(1:12, ncol = 3)
M


### a)

attributes(M)

rownames(M) <- 1:nrow(M)
colnames(M) <- 1:ncol(M)
M

# Jetzt ist das Attribut "dimnames" sichtbar.
attributes(M)


### b)

M <- matrix(1:12, ncol = 3)
M

# Wir haengen der Attributsliste ein Element "dimnames" hinzu.
attributes(M)$dimnames <- list(1:nrow(M), 1:ncol(M))
M

