### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 24
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


### a)

n <- 50
alter <- runif(n, min = 18, max = 80)
iq <- rnorm(n, mean = 100, sd = 15)

alter
iq


### b)

# Wir verwenden cut(). Standardmaessig werden rechtsabgeschlossene
# Intervalle verwendet. Als Extreme empfehlen wir -Inf und Inf. Die
# Variablen sind ordinalskaliert, was wir mit ordered = TRUE einstellen.

# Alter kategorisieren
alter.cut <- cut(alter, breaks = c(-Inf, 30, 65, Inf),
  labels = c("jung", "mittel", "weise"), ordered = TRUE)
alter.cut

# IQ kategorisieren
iq.cut <- cut(iq, breaks = c(-Inf, 85, 115, Inf),
  labels = c("gering", "mittel", "hoch"), ordered = TRUE)
iq.cut


### c)

tab <- table(alter.cut, iq.cut)
tab

# Anzahl der leeren Zellen
sum(tab == 0)


### d)

# Das Zusammenfassen geht ueber die Levels.
levels(alter.cut)[levels(alter.cut) %in% c("jung", "mittel")] <- 
  "Erwerbstaetiger"
levels(alter.cut)[levels(alter.cut) == "weise"] <- "Pensionist"

alter.cut


### e)

tab2 <- table(alter.cut, iq.cut)
tab2

# Pruefung
sum(tab2["Erwerbstaetiger", ]) == sum(tab[c("jung", "mittel"), ])



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


x <- c("A", "B", "C")
faktor <- factor(x, levels = c("B", "C", "A"), labels = c(4, 2, 6))


### a)

# levels enthaelt die Auspraegungen von x, die als Kategorie im Faktor
# aufgenommen werden und deren Reihenfolge. labels enthaelt die
# Beschriftungen, die den Kategorien zugewiesen werden sollen. So wird
# folgende Zuordnung vorgenommen:
# .) "B" bekommt die Beschriftung 4.
# .) "C" bekommt die Beschriftung 2.
# .) "A" bekommt die Beschriftung 6.
faktor


### b)

# 1. Code: Es werden die Codierungen (immer von 1 bis Anzahl der Levels)
# erzeugt. Also 3 1 2
as.numeric(faktor)

# 2. Code: Die Levels sind vom Mode "character", daher kommt eine
# Fehlermeldung heraus.
levels(faktor) * 4
mode(levels(faktor))

# 3. Code: Ein Faktor wird intern als Codierungsvektor verwaltet,
# enthaelt also die Eintraege, die von 1 bis Anzahl der Kategorien laufen.
# Aequivalent zum Code ist daher faktor[as.numeric(faktor)]. Es wird also
# aus Faktor erst der 3. Eintrag (2), dann der 1. Eintrag (6) und
# schliesslich der 2. Eintrag (4) selektiert.
faktor[faktor]
faktor[as.numeric(faktor)]


### c)

faktor1 <- factor(faktor, ordered = TRUE)
faktor1

# Achtung: Folgender Code funktioniert nicht, da er die Kategorien des
# Faktors umsortiert!
# levels(faktor1) <- sort(as.numeric(levels(faktor1)))
# faktor1

# Besser ist eine neuerliche Faktorbildung, wobei wir levels korrekt
# und automatisiert definieren.
faktor1 <- factor(faktor1, levels = sort(as.numeric(levels(faktor1))),
  ordered = TRUE)
faktor1

# Die Umwandlung as.numeric() hat hier den Sinn, dass die Zahlen nicht
# alphabetisch sortiert werden. Sonst wuerde etwa "10" zwischen "1" und
# "2" einsortiert werden.



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


noten <- c(4, 5, NA, 3, 1, 3, NA, 3)
noten.faktor <- factor(noten, ordered = TRUE)
noten.faktor


### a)

# Funktioniert fuer noten und noten.faktor voellig gleich, da noten.faktor
# ordinalskaliert ist.
sum(noten.faktor <= 4, na.rm = TRUE)
sum(noten <= 4, na.rm = TRUE)


### b)

# Neuerliche Faktorbildung mit allen 5 Noten. Entweder aus noten oder
# noten.faktor heraus.
noten.faktor.voll <- factor(noten, levels = 1:5, ordered = TRUE)
noten.faktor.voll

tab.voll <- table(noten.faktor.voll)
tab.voll


### c)

# Hier gibt es sehr viele Moeglichkeiten
sum(tab.voll[as.character(1:4)])
sum(tab.voll[names(tab.voll) %in% 1:4])
# uvm.


### d)

# exclude = NULL in table() fuehrt zum Ziel.
tab.voll.na <- table(noten.faktor.voll, exclude = NULL)
tab.voll.na

# Alternativ koennen wir NAs als eigene Kategorie des Faktors definieren
# und eine Haeufigkeitstabelle erstellen. Wenn wir davon ausgehen, dass
# fehlende Werte von der Beurteilung wie 5er mit 0 Punkten gewertet werden,
# dann bleibt der ordinalskalierte Character der Variable erhalten, auch
# wenn wir fehlende Werte als Kategorie inkludieren.
noten.faktor.voll.NA <- factor(noten.faktor.voll, levels = c(1:5, NA), 
  exclude = NULL)
noten.faktor.voll.NA

table(noten.faktor.voll.NA)


### e)

# Eine Moeglichkeit von vielen:
anz.best <- sum(tab.voll.na[as.character(1:4)])
anz.nichtBest <- sum(tab.voll.na) - anz.best

tab <- c(Bestanden = anz.best, Durchgefallen = anz.nichtBest)
tab

# Hier haben wir anz.nichtBest als Differenz berechnet. Alternativ koennen
# wir auch diese Anzahl direkt aus der Haeufigkeitstabelle berechnen.
# Dazu brauchen wir fuer NA eine Abfrage mittels is.na().
bool <- names(tab.voll.na) == "5" | is.na(names(tab.voll.na))
anz.nichtBest <- sum(tab.voll.na[bool])
anz.nichtBest

