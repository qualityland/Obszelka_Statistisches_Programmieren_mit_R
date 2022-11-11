### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 14: Konstante
### -------------------------------------------------------------------------


x <- c(1:4, NA)
x == NA


pkt <- c(11, 38, NA, 24, 24, 31, 19, 35, NA, 22)
pkt



### -------------------------------------------------------------------------
### 14.1  Eingebaute Konstante -- Constants
### -------------------------------------------------------------------------


LETTERS     # Alle Grossbuchstaben
letters     # Alle Kleinbuchstaben
pi          # Die Kreiszahl pi


### -------------------------------------------------------------------------
### 14.1.1  Konstante zurückgewinnen -- rm(Konstante)


pi          # Die Zahl pi, wie sie sein sollte.

# pi überschreiben
pi <- "pi ist im Moment leider nicht erreichbar!"
pi          # Die Zahl pi, wie sie NICHT sein sollte.

# pi zurückgewinnen
rm(pi)
pi          # Jetzt haben wir pi wieder!

rm(pi)
pi          # pi ist immer noch da!


### -------------------------------------------------------------------------
### 14.1.2  TRUE und FALSE


T           # T enthält die eingebaute Konstante TRUE.

# Überschreibe T
T <- FALSE
T           # (!!!)

# Erstelle den Kartenstapel und mische die Karten
karten <- 1:6 
stapel <- sample(karten)
stapel

# Verteile die Karten auf zwei Spieler
bool.1 <- c(T, F)
bool.1

# Karten von Spieler 1
hand.spieler1 <- stapel[bool.1]
hand.spieler1

# Karten von Spieler 2
hand.spieler2 <- stapel[!bool.1]
hand.spieler2


TRUE <- FALSE



### -------------------------------------------------------------------------
### 14.2  Das NULL-Objekt -- NULL
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 14.2.1  Beschriftungen löschen -- names() <- NULL


# Momentane Beschriftung erfragen
names(pkt)

# Beschriftungen zuweisen
names(pkt) <- paste0("Nr", 1:length(pkt))
pkt

# Beschriftung löschen
names(pkt) <- NULL
pkt


### -------------------------------------------------------------------------
### 14.2.2  Abfrage auf NULL -- is.null()


names(pkt) != NULL

# Abfrage auf Null
is.null(names(pkt))

# Existieren Beschriftungen?
!is.null(names(pkt))



### -------------------------------------------------------------------------
### 14.3  Fehlende Werte -- NA
### -------------------------------------------------------------------------


pkt
sort(pkt)

# Bestimme die Differenz der Längen beider Vektoren
length(pkt) - length(sort(pkt))


### -------------------------------------------------------------------------
### 14.3.1  Auf Gleichheit mit NA abfragen -- is.na()


pkt
pkt == NA          # schaut wild aus ;-)

is.na(pkt)         # TRUE, falls der Eintrag NA ist, FALSE sonst
sum(is.na(pkt))    # so gehts!


is.na("NA")
is.na(NA)
"NA" == NA


### -------------------------------------------------------------------------
### 14.3.2  Berechnung von Masszahlen, unbedingter Fall


# Elemente ungleich NA selektieren
pkt.valid <- pkt[!is.na(pkt)]
pkt.valid

# Mittelwert der gültigen Punkte
mean(pkt.valid)

# Quantile der gültigen Punkte
quantile(pkt.valid)


### -------------------------------------------------------------------------
### 14.3.3  Umgang mit fehlenden Werten in Funktionen


mean(pkt, na.rm = TRUE)      # Fehlende Werte nicht berücksichtigen

sort(pkt, na.last = NA)      # Fehlende Werte entfernen (Standard)
sort(pkt, na.last = TRUE)    # Fehlende Werte hinten anhängen
sort(pkt, na.last = FALSE)   # Fehlende Werte vorne aufschreiben


# Punkte in eine Note umrechnen
pkt
note <- pmin(pmax(ceiling(8 - pkt / 40 * 8), 1), 5)
note


# Nichts exkludieren
table(note, exclude = NULL)   

# NA wird exkludiert
table(note, exclude = NA)     

# NAs immer anzeigen
table(note, useNA = "always") 

# Wenn es NAs gibt, mitnehmen
table(note, useNA = "ifany") 


### -------------------------------------------------------------------------
### 14.3.4  Berechnung von Masszahlen, bedingter Fall -- subset()


pkt

sum(pkt >= 20, na.rm = TRUE)           # 1.)
mean(pkt, na.rm = TRUE)                # 2.)
mean(pkt[pkt >= 20 & !is.na(pkt)])     # 3.) Möglichkeit 1

pkt.valid <- pkt[!is.na(pkt)]
mean(pkt.valid[pkt.valid >= 20])       # 3.) Möglichkeit 2

mean(subset(pkt, subset = pkt >= 20))  # 3.) Möglichkeit 3


### -------------------------------------------------------------------------
### 14.3.5  Logische Werte und NA


pkt
pkt >= 20     # NA bleibt NA
!is.na(pkt)
pkt >= 20 & !is.na(pkt)


# NA mit Und-Verknüpfung
TRUE & NA   # NA
FALSE & NA  # FALSE

# NA mit Oder-Verknüpfung
TRUE | NA   # TRUE
FALSE | NA  # NA



### -------------------------------------------------------------------------
### 14.4  Unendlichkeit -- Inf, is.finite(), is.infinite()
### -------------------------------------------------------------------------


# Parameter
n <- 8 * 10^6          # Grösse der Grundgesamtheit
k <- 100               # Grösse der Stichprobe
choose(n = n, k = k)   # Anzahl der Stichproben


Inf * 5
Inf + 2
-Inf - 55
Inf - 2
Inf / 2

1 / 0
-1 / 0
1 / Inf
-1 / Inf
Inf / Inf


z <- c(-Inf, -7, 0, Inf)
z

# Abfrage auf Gleichheit mit Inf
z == Inf
z %in% c(-Inf, Inf)
abs(z) == Inf
is.infinite(z)
!is.finite(z)


x <- c(NA, NaN, Inf, -Inf, 0)
x

# Studiere is.finite()
is.finite(x)

# Studiere !is.infinite()
!is.infinite(x)



### -------------------------------------------------------------------------
### 14.5  Not A Number -- NaN, is.nan()
### -------------------------------------------------------------------------


x <- c(0 / 0, 2 - Inf, Inf - Inf, 3 / -Inf, NA, sqrt(-2))
x


# Abfrage auf Gleichheit mit NaN
is.nan(x)

# Abfrage auf Gleichheit mit NA oder NaN
is.na(x)               # TRUE, falls NA oder NaN

# Explizite Abfrage auf Gleichheit mit NA
is.na(x) & !is.nan(x)  # TRUE, falls NA und nicht NaN



### -------------------------------------------------------------------------
### 14.6  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 14.6.4  Übungen


geschlecht <- c("w", "w", "m", "m", "w", "w", "m", "m")
groesse <- c(163, 171, 192, 183, 0, 172, 208, 182)
gewicht <- c(NA, 60, Inf, 88, 0, -3, 878, 78)
