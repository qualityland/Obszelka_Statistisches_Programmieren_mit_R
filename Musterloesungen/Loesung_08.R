### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 8
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Testvektor
x <- c(2, 8, 5, 1)

# Kumulierte Mittelwerte berechnen
cumsum(x) / (1:length(x))



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


### a)

# Beispielvektor
x <- c(1, 2, 3, 4, 5)

# ifelse() ist unnoetiger Ballast in diesem Fall.
# Beachte, dass yes = FALSE und no = TRUE ist, daher muessen wir die
# Wahrheitsbelegung umdrehen.
ifelse(x %% 2 != 0, FALSE, TRUE)
x %% 2 == 0


### b)

# Beispielvektor
x <- c(-1.9, 0.1, 1.9, 4.5)

ifelse(x > 0, floor(x), ceiling(x))
trunc(x)


### c)

# Beispielvektor
x <- c(1, 4, 5, 2, 6)

x[-1] - x[-length(x)]
diff(x)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


### a)

# Wir praesentieren zwei Varianten
punkte <- c(100, 80, 60, 50, 45, 40, 36, 32, 29, 26, 24,
  seq(22, 16, by = -2), 15:1)
punkte

temp <- rep(c(1, 2, 3, 4, 5, 10, 20), times = c(16, 5, 2, 2, 2, 1, 2))
punkte <- rev(cumsum(temp))
punkte

length(punkte)


### b)

# Elegant mit cumsum() loesbar
cumsum(punkte) / sum(punkte)


### Platzierungen
platz <- c(6, 10, 26, 5, 7, 5, 14, 8)
platz


### c)

# Wir selektieren die Punkte, die zu den erreichten Plaetzen passen und
# bilden die Summe.
sum(punkte[platz])


### d)

# Wir bilden die kumulierte Summe der Punkte, erfragen die Indizes, bei
# denen diese kumulierte Summe >= 200 ist und picken den ersten heraus.
which(cumsum(punkte[platz]) >= 200)[1]


### e)

# Mit diff() kein Problem.
# Dabei ist es egal, ob wir zaehlen, wie oft die folgende Platzierung
# niedriger war oder ob wir zaehlen, wie oft die folgende Punkteausbeute
# hoeher war.
sum(diff(platz) < 0)
sum(diff(punkte[platz]) > 0)


### f)

# Wir sortieren den Vektor aufsteigend. Die ersten beiden Eintraege
# enthalten die beiden schlechtesten Platzierungen, diese werden vor der
# Summenbildung entfernt.
punkte.sort <- sort(punkte[platz])
punkte.sort

sum(punkte.sort[-(1:2)])

# Hinweis: Sollten NAs vorkommen und wir ein NA als das schlechtest
# moegliche Ergebnis auffassen, so muessen wir bei der Sortierung mit
# sort() den Parameter na.last = FALSE setzen und ggf. in sum() na.rm =
# TRUE einbauen.



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


umsatz <- c(300, 150, 700, 400)


### a)

bonus <- (umsatz >= 300) * 50
bonus

# Auch OK:
bonus <- ifelse(umsatz >= 300, 50, 0)
bonus


### b)

bonus <- (umsatz >= 300) * 0.1 * umsatz
bonus

# Auch OK:
bonus <- ifelse(umsatz >= 300, 0.1 * umsatz, 0)
bonus


### c)

# Wenn 10% des Umsatzes den Wert 20 unterschreitet, so soll dieser Wert
# auf 20 gehoben werden. Mit pmax() koennen wir das gleichzeitig fuer
# alle Kunden umsetzen.
bonus <- pmax(0.1 * umsatz, 20)
bonus


### d)

# Ausgehend von c) stuelpen wir noch ein pmin() darueber.
bonus <- pmin(pmax(0.1 * umsatz, 20), 50)
bonus



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


# Die Schlagzahlen der beiden Spieler nach 6 Bahnen
schlaege1 <- c(2, 3, 2, 4, 7, 3)
schlaege2 <- c(1, 3, 3, 6, 4, 2)

schlaege1
schlaege2


### a)

# Mit ifelse()
ifelse(schlaege1 > schlaege2, -1, ifelse(schlaege1 < schlaege2, 1, 0))


### b)

# Ohne ifelse(): Wir bestimmen das Vorzeichen der Schlagdifferenzen.
sign(schlaege2 - schlaege1)



### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


x <- c(-1, 1, 2, 2, -2)

# Fehlerhafter Code
which(diff(x) >= 0)

# Korrektur: Erstens brauchen wir > statt >= und zweitens wird bei diff()
# der Vektor um ein Element verkuerzt, daher addieren wir 1 zu den Indizes
# hinzu.
which(diff(x) > 0) + 1



### -----------------------------------------------------------------------
### Beispiel 7
### -----------------------------------------------------------------------


n <- 12
p <- 1/3
alpha <- 0.05


### a)

k <- 0:n
cumsum(choose(n, k) * p^k * (1 - p)^(n - k))

# Allgemein brauchen wir oft nur dort, wo wir sum() verwenden wuerden,
# ein cumsum() zu schreiben, um derartige Aufgaben zu bewaeltigen.

# Kontrolle
pbinom(k, size = n, prob = p)


### b)

# Die Summe lauft jeweils von k bis n (im Gegensatz zu a), wo die Summe
# von 0 bis k gelaufen ist). Das heisst, fuer k = n brauchen wir das n.
# Summenglied, für k = n - 1 das n. und n-1. Summenglied etc.
# Wenn wir kumulieren wollen, dann muessen wir also bei k = n starten und
# bis k = 0 gehen, also das ganze von hinten nach vorne angehen.

# Dazu drehen wir im ersten Schritt k um.
k <- rev(0:n)

# Jetzt berechnen wir die Folgenglieder fuer k = n, k = n - 1, ..., k = 0
# und bilden die kumulierte Summe. Das Ergebnis bildet P(X >= k) ab bei
# k = n beginnend. Damit es bei k = 0 beginnt, drehen wir das Ergebnis von
# cumsum() erneut um.
temp <- rev(cumsum(choose(n, k) * p^k * (1 - p)^(n - k)))

# temp enthaelt also P(X >= k) fuer k = 0, 1, ..., n
# Mit which() erfragen wir die Indizes, welche temp < alpha erfuellen:
which(temp < alpha)

# Jetzt faengt aber k bei 0 an (und nicht bei 1)! Das heisst, wir muessen
# von jedem Index den Wert 1 abziehen, um den entsprechenden Wert fuer k
# zu erhalten. Abschliessend wollen wir den kleinsten Wert fuer k haben,
# der die Bedingung erfuellt. Das fuehrt uns zum grande Finale.
which(temp < alpha)[1] - 1

# P(X >= 8) ist also erstmals kleiner als 0.05


# Alternative mit dbinom() mit der analogen Idee des zweimaligen Umdrehens:
rev(cumsum(rev(dbinom(0:n, size = n, prob = p))))
temp

