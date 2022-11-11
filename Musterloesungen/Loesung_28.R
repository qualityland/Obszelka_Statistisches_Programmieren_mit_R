### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 28
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


### a)

# +3 -1 +3 -1 +3 -1 ...


### b)

n <- 20

res <- rep(3, n)

for (i in 2:length(res)) {
  if (i %% 2 == 0) {
    # i ist gerade => -1 rechnen
    res[i] <- res[i - 1] - 1
  }
  else {
    # i ist ungerade => +3 rechnen
    res[i] <- res[i - 1] + 3
  }
}

res


### c)

# Ja, sogar auf sehr viele Arten. Schauen wir uns ein paar Varianten an.

# 1.) cumsum() auf die Aenderungsregel anwenden
x <- rep(c(3, -1), length = n)
cumsum(x)


# 2.) Sequenz 2, 3, 4, ... erzeugen und mittels Recycling korrigieren
x <- seq(2, by = 1, length = n)
x + c(1, -1)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Beispielvektor
x <- c(-3, -1, 1, 4, -3, 4)
x


### a)

# In der Schleife wird res immer dann um 1 erhoeht, wenn der i. Eintrag
# von x groesser als der i-1. Eintrag ist. Wir zaehlen also, wie oft auf
# einen Eintrag ein groesserer folgt.

res <- 0

for (i in 2:length(x)) {
  res <- res + (x[i] > x[i - 1])
}

res


# Alternative ohne Schleifen

sum(diff(x) > 0)


### b)

# Falls ein Eintrag groesser als 0 ist, passiert nichts. Andernfalls wird
# res durch den i. Eintrag ueberschrieben, wenn der i. Eintrag groesser
# res ist. Wir bestimmen also die groesste Zahl <= 0 aus x. Gibt es keine
# Zahl <= 0, so wird -Inf zurueckgegeben.

res <- -Inf

for (i in 1:length(x)) {
  if (x[i] > 0) {
    next()
  }
  if (x[i] > res) {
    res <- x[i]
  }
}

res


# Alternative ohne Schleifen

max(-Inf, x[x <= 0])


### c)

# Die Schleife weist dem i. Eintrag von res die Summe des i-1. Eintrags
# von res und dem i. Eintrag von x zu. Wir bestimmen also die kumulierte
# Summe von x.

res <- rep(x[1], length(x))

for (i in 2:length(x)) {
  res[i] <- res[i - 1] + x[i]
}

res


# Alternative ohne Schleifen

cumsum(x)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


### a)

# Gehen wir die Schleife durch
# Beginn: res = 1  2  3  4
# j = 2 : res = 1 10  3  4 (else-Block wird ausgefuehrt)
# j = 3 : res = 1 10 10  4 (if-Block wird ausgefuehrt)
# j = 4 : res = 1 10 10 25 (else-Block wird ausgefuehrt)
# Also:
# > res
# [1]  1 10 10 25

res <- 1:4
for (j in 2:4) {
  if (j == 3)
    res[j] <- res[j - 1]
  else
    res[j] <- sum(res)
}

res


### b)

# Der Code ist derselbe wie in a). Lediglich res wird anders initialisiert.
# Gehen wir die Schleife durch
# Beginn: res = 1
# j = 2 : res = 1 1      (else-Block wird ausgefuehrt)
# j = 3 : res = 1 1 1    (if-Block wird ausgefuehrt)
# j = 4 : res = 1 1 1 3  (else-Block wird ausgefuehrt)
# Also:
# > res
# [1] 1 1 1 3

res <- 1
for (j in 2:4) {
  if (j == 3)
    res[j] <- res[j - 1]
  else
    res[j] <- sum(res)
}

res



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Zufall einfrieren
RNGversion("4.0.2")
set.seed(123)


### a)

# Da wir die Anzahl der Schleifendurchlaeufe nicht kennen, nehmen wir eine
# while-Schleife. Die Schleife laeuft solange, bis summe erstmals > 20 ist.
# Solange summe <= 20 ist, erhoehen wir die Anzahl der Wuerfelwuerfe und
# addieren einen Wuerfelwurf zu summe hinzu.

summe <- 0           # Aktuelle Augensumme
anza <- 0            # Anzahl der Wuerfe

while (summe <= 20) {
  anza <- anza + 1
  summe <- summe + sample(1:6, size = 1)
}

summe
anza


### b)

# Wir modifizieren die Schleife, damit sie der Anforderung genuegt.

summe <- 0           # Aktuelle Augensumme
anzb <- 0            # Anzahl der Wuerfe

while (summe <= 20) {
  anzb <- anzb + 1
  summe <- summe + sample(1:6, size = 1)

  # Falls die Augensumme gerade ist, ziehe 1 ab.
  if (summe %% 2 == 0) {
    summe <- summe - 1
  }
}

summe
anzb


### c)

n <- 10000           # Anzahl der Simulationen


# Zunaechst die Loesung mit einer zusaetzlichen for-Schleife.

# Grundsaetzlich uebernehmen wir den Code von oben, wobei wir eine
# for-Schleife ueberstuelpen (die Schleifenvariable nennen wir etwa i
# und laeuft von 1 bis n) und jeweils die i. Kompoente der Vektoren 
# ansprechen.

# a)

summe <- rep(0, n)   # Aktuelle Augensummen der n Simulationen
anza <- rep(0, n)    # Anzahl der Wuerfe der n Simulationen

for (i in 1:n) {
  while (summe[i] <= 20) {
    anza[i] <- anza[i] + 1
    summe[i] <- summe[i] + sample(1:6, size = 1)
  }
}

# b)

summe <- rep(0, n)   # Aktuelle Augensummen der n Simulationen
anzb <- rep(0, n)    # Anzahl der Wuerfe der n Simulationen

for (i in 1:n) {
  while (summe[i] <= 20) {
    anzb[i] <- anzb[i] + 1
    summe[i] <- summe[i] + sample(1:6, size = 1)

    # Falls die Augensumme gerade ist, ziehe 1 ab.
    if (summe[i] %% 2 == 0) {
      summe[i] <- summe[i] - 1
    }
  }
}

# Ergebnisse vergleichen
mean(anza)
mean(anzb)

summary(anza)
summary(anzb)


# Jetzt eine schnellere Variante ohne weitere Schleife

# Die Idee: Wir lassen die while-Schleifen so lange laufen, bis alle
# Augensummen >= 20 sind. Das heisst, wir simulieren alle n Durchgaenge
# gleichzeitig. Bei jenen Durchgaengen, die schon fertig sind, zaehlen
# wir das entsprechende anz nicht mehr hoch.

# a)

summe <- rep(0, n)   # Aktuelle Augensumme
anza <- rep(0, n)    # Anzahl der Wuerfe

while (any(summe <= 20)) {
  # anza nur hochzaehlen, wenn die summe <= 20 ist.
  anza <- anza + (summe <= 20)

  # Fuer jeden Durchgang eine Zahl wuerfeln und dazuaddieren, wenn noetig
  summe <- summe + sample(1:6, size = n, replace = TRUE) * (summe <= 20)
}

# b)

summe <- rep(0, n)   # Aktuelle Augensumme
anzb <- rep(0, n)    # Anzahl der Wuerfe

while (any(summe <= 20)) {
  # anzb nur hochzaehlen, wenn die summe <= 20 ist.
  anzb <- anzb + (summe <= 20)

  # Fuer jeden Durchgang eine Zahl wuerfeln und dazuaddieren, wenn noetig
  summe <- summe + sample(1:6, size = n, replace = TRUE) * (summe <= 20)

  # Falls die Augensumme gerade ist, ziehe 1 ab. Vektorwertige Loesung :-)
  summe <- summe - (summe %% 2 == 0 & summe <= 20)
}

# Vergleich
mean(anza)
mean(anzb)

summary(anza)
summary(anzb)


# Schleifen sind in R langsam, wenn wir viele Iterationen benoetigen.
# Dazu spaeter mehr beim Thema Effizienz!



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


# Beispielvektor mit Felix2902, der am 29.02. geboren wurde
gebtag <- c(Daniel = "07.07.1986", Andreas = "12.09.1973",
  Neujahr98 = "01.01.1998", Felix2902 = "29.02.1996")
gebtag

gebtag.Date <- as.Date(gebtag, format = "%d.%m.%Y")
gebtag.Date


# Es wird auf eine while-Schleife hinauslaufen, die wir solange durchlaufen,
# bis wir fuer jeden den naechsten Samstag gefunden haben.

# Zunaechst bestimmen wir, wann der naechste Geburtstag stattfindet. Dazu
# lassen wir uns vom Code im Datumskapitel inspirieren.


### Bestimme den naechsten Geburtstag
# (Code aus dem Datumskapitel uebernommen)

# Heutiges Datum abfragen
date <- Sys.Date()
date

# Geburtsjahre und heutiges Jahr extrahieren
geb.jahr <- as.numeric(format(gebtag.Date, format = "%Y"))
heute.jahr <- as.numeric(format(date, format = "%Y"))

geb.jahr
heute.jahr

# Die Geburtstage von uns in diesem Jahr generieren
geb.heuer <- paste0(format(gebtag.Date, format = "%d.%m."), heute.jahr)
geb.heuer <- as.Date(geb.heuer, format = "%d.%m.%Y")
geb.heuer

# Korrektur für Geburtstage in Schaltjahren
bool.na <- is.na(geb.heuer)
geb.heuer[bool.na] <- as.Date(paste0("01.03.", heute.jahr),
  format = "%d.%m.%Y")
geb.heuer

# Heuer schon Geburtstag gehabt?
geb.heuer < date

# Jahr des naechsten Geburtstages bestimmen
jahr <- heute.jahr + (geb.heuer < date)
jahr

# Naechsten Geburtstag ermitteln (basierend auf gebtag.Date!)
geb.next <- paste0(format(gebtag.Date, format = "%d.%m."), jahr)
geb.next <- as.Date(geb.next, format = "%d.%m.%Y")
names(geb.next) <- names(gebtag.Date)
geb.next

# Reparatur für Schaltjahre
date0103 <- as.Date(paste0(heute.jahr, "-03-01"))
date >= date0103 # Hat heuer der 01.03. schon stattgefunden?

kandidatenjahre <- heute.jahr + (date >= date0103) + 0:7
kandidatenjahre

# Kandidatendatumswerte generieren
date2902 <- as.Date(paste0("29.02.", kandidatenjahre), format = "%d.%m.%Y")
date2902

# Naechsten 29.02. extrahieren ...
date2902.next <- date2902[!is.na(date2902)][1]
date2902.next

# ... und NA-Werte damit ersetzen
geb.next[is.na(geb.next)] <- date2902.next
geb.next


### Jetzt bestimmen wir, wann wir das naechste Mal an einem Samstag
# Geburtstag haben. Dabei erhoehen wir in einer while-Schleife solange
# das Jahr, bis wir fuer alle Geburtstage fuendig werden.

# geb.next kopieren
geb.sa <- geb.next

while (TRUE) {
  # Wo haben wir bereits den naechsten Samstag gefunden?
  bool.sa <- format(geb.sa, format = "%u") == 6

  if (all(bool.sa)) {
    # Haben fuer alle Geburtstage den naechsten Samstag gefunden => Abbruch
    break
  }

  # Muessen noch bei mindestens einem Datumswert weiterschauen
  datum.temp <- geb.sa[!bool.sa]

  # Jahre extrahieren
  jahr <- as.numeric(format(datum.temp, format = "%Y"))

  # Jahr um 1 hochzaehlen
  datum.temp <- as.Date(paste0(jahr + 1, "-", format(datum.temp, "%m-%d")))

  # Jahr fuer Schaltjahre korrigieren
  if (any(is.na(datum.temp))) {
    bool.na <- is.na(datum.temp)
    datum.temp[bool.na] <- as.Date(paste0(jahr[bool.na] + 4, "-02-29"))
  }

  # Falls wir auch in 4 Jahren kein Schaltjahr haben, so spaetestens in
  # 8 Jahren
  if (any(is.na(datum.temp))) {
    bool.na <- is.na(datum.temp)
    datum.temp[bool.na] <- as.Date(paste0(jahr[bool.na] + 8, "-02-29"))
  }

  # Naechsten Geburtstagskandidaten zurueckschreiben.
  geb.sa[!bool.sa] <- datum.temp
}

names(geb.sa) <- names(gebtag)
geb.sa

# Kontrolle
weekdays(geb.sa)



### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


# Wir ersetzen im Code den ifelse()-Teil durch ein if / else.


# Koeffizienten definieren
a <- 0.5
b <- -3
c <- 6.5

# Loesungen bestimmen gemaess der Formel
# (-b +/- sqrt(b^2 - 4*a*c)) / (2 * a)
# Wenn b^2 - 4*a*c >= 0 ist, dann gibt es eine reellwertige Loesung,
# andernfalls nicht. Genau da setzen wir an mit unserer Fallunterscheidung.

temp <- b^2 - 4*a*c
temp

# Gibt es eine reellwertige Loesung?
bool.reell <- b^2 - 4*a*c >= 0
bool.reell

# Jetzt die Modifikation
if (bool.reell) {
  # Reellwertige Loesung bestimmen
  res <- (-b + c(-1, 1) * sqrt(temp)) / (2 * a)
} else {
  # Komplexwertige Loesung bestimmen
  res <- (-b + c(-1, 1) * sqrt(abs(temp)) * 1i) / (2 * a)
}

# Bei der komplexwertigen Loesung machen wir dabei Folgendes: sei x > 0:
# sqrt(-x) = sqrt(abs(x)) * 1i

res


# Beachte: Die Variante mit if / else ist besser als jene mit ifelse().
# Denn bei ifelse() muessen wir sowohl die reellwertige als auch die
# komplexwertige Loesung berechnen. Bei if / else berechnen wir nur die
# relevante Loesung, also entweder die reellwertige oder die komplexwertige
# Loesung. Wir ersparen uns also eine unnoetige Formelauswertung.
