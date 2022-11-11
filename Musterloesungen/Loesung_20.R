### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 20
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


geschlecht <- c("w", "m", NA, "m", "w", "w", "w", "m", "m", "m")
groesse <- c(176, 181, 181, 183, 163, 157, 164, 166, 176, 184)
gewicht <- c(65, 92, 65, 93, 49, 47, NA, 50, 62, 84)


### a)

# Als Variablennamen werden standardmaessig die Namen der Objekte genommen.
# Diese sind schon sinnvoll.
daten <- data.frame(geschlecht, groesse, gewicht)
daten

# Eine Matrix kann nur einen Mode haben. In dem Fall wuerde wegen
# geschlecht eine character-Matrix entstehen, was für groesse und gewicht
# ungeeignet ist.


### b)

# Beachte, dass die Daten alle plausibel sind und wir daher keine
# Bereinigungen durchfuehren muessen, was in der Praxis sehr oft nicht
# der Fall ist.
bmi <- daten$gewicht / (daten$groesse / 100)^2
daten$bmi <- bmi

daten


### c)

daten[rowSums(is.na(daten)) == 0, ]


### d)

# Tabelle initialisieren
tab.na <- rep(0, 2)
names(tab.na) <- c("m", "w")
tab.na

tab.na["m"] <- sum(is.na(daten$gewicht)[daten$geschlecht == "m"],
  na.rm = TRUE)
tab.na["w"] <- sum(is.na(daten$gewicht)[daten$geschlecht == "w"],
  na.rm = TRUE)

tab.na


# Spaeter lernen wir eine deutlich bessere flexiblere Moeglichkeit kennen:
tapply(is.na(daten$gewicht), daten$geschlecht, sum)

# Bzw. via table():
tab.na <- table(is.na(daten$gewicht), daten$geschlecht)
tab.na

tab.na["TRUE", ]


### e)

# Um jede numerische Spalte zu bestimmen, wenden wir zunaechst is.numeric()
# auf jede Spalte an.
bool.numeric <- sapply(daten, is.numeric)
bool.numeric

# Diese Spalten selektieren wir und berechnen Minimum und Maximum
daten.range <- sapply(daten[bool.numeric], range, na.rm = TRUE)
daten.range

# Spannweite berechnen: Zwei Varianten
daten.range[2, ] - daten.range[1, ]
apply(daten.range, 2, diff)


### f)

daten[order(daten$gewicht, decreasing = TRUE), ]


### g)

daten[c("groesse", "gewicht")] <- list(NULL)
daten

# Auch moeglich:
daten[!names(daten) %in% c("groesse", "gewicht")]



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
# setwd(...)
load("Test.RData")

test


### a)

test.pkt <- test[c("Pkt1", "Pkt2", "Pkt")]
test.pkt

# Bei jedem Test
colSums(test.pkt >= 20 & test.pkt <= 29, na.rm = TRUE)

# Insgesamt
sum(test.pkt >= 20 & test.pkt <= 29, na.rm = TRUE)


### b)

# Beim Kapitel Regular Expressions lernen wir die Funktionsweise des
# folgenden Codes.
bool.test <- grepl("Pkt[0-9]+", names(test))
bool.test

# Minima bestimmen: apply() wandelt das Dataframe in eine Matrix um. Da
# wir nur Testspalten selektieren, entsteht dabei eine numerische Matrix.
apply(test[bool.test], 1, min)

