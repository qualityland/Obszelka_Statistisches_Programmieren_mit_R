### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 03: Vektoren und logische Abfragen
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 3.1  Vektoren generieren
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 3.1.1  Elemente zu Vektoren verketten -- c()


# Erstelle den Vektor mit den Kartenwerten des gemischten Stapels
stapel <- c(4, 7, 6, 2, 3, 5)
stapel


### -------------------------------------------------------------------------
### 3.1.2  Indizierung und Länge eines Vektors -- length()


# Zähle die Anzahl der Karten des Stapels 
# Bestimme die Anzahl der Elemente des Vektors stapel
length(stapel)


### -------------------------------------------------------------------------
### 3.1.3  Einfache Sequenzen -- ":"


# Einfache Sequenzen generieren
1:6

# Funktioniert auch in die andere Richtung
6:1

# Funktioniert auch mit negativen Einträgen - beachte die Klammern!
-2:3
-(2:3)

# Geht auch mit Dezimalzahlen
1.5:6.5

# Unvollständige Sequenz
1:4.5


# Generiere einen Indexvektor für die Variable stapel
1:length(stapel)



### -------------------------------------------------------------------------
### 3.2  Elemente selektieren: Subsetting -- "[ ]"
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 3.2.1  Subsetting mit Indizes und Indizes ausschliessen -- "-"


# Der Kartenstapel
stapel

# Schaue die oberste Karte des Kartenstapels an
# Selektiere das 1. Element von stapel
stapel[1]

# Schaue die 2. und 4. Karte des Kartenstapels an
# Selektiere das 2. und 4. Element von stapel
stapel[c(2, 4)]

# Falsche Syntax beim Zugriff auf Elemente eines Vektors
stapel[2, 4]

# Schaue die oberste und unterste Karte des Stapels an
# Selektiere das 1. und letzte Element von stapel
stapel[c(1, length(stapel))]


# Betrachte die 3. bis 5. Karte des Stapels
stapel[3:5]
stapel

# Speichere die gewünschten Elemente auf temp ab
temp <- stapel[3:5]
temp

# Verschachtelter Zugriff
stapel[3:5][1]

# Ersetze stapel[3:5] durch temp
temp[1]


# Indizes zwischenspeichern
ind <- 3:5
ind

# Gewünschte Elemente extrahieren
stapel[ind]


# Zugriff auf nicht existierende Einträge
stapel[c(2, 9, 2)]


### Einträge ausschliessen

stapel

# Selektiere alle Elemente ausser dem 3. bis 5. - beachte die Klammern!
stapel[-(3:5)]

# Selektiere alle Elemente ausser dem 1. sowie 3. bis 5. Element
stapel[-c(1, 3:5)]


# Verteile die Karten auf zwei Spieler
stapel

# Indizes jener Karten, die für Spieler 1 bestimmt sind.
ind <- c(1, 3, 5)
ind

# Hand des 1. Spielers
hand1 <- stapel[ind]
hand1

# Hand des 2. Spielers
hand2 <- stapel[-ind]
hand2


### -------------------------------------------------------------------------
### 3.2.2  Subsetting mit Wahrheitswerten -- TRUE und FALSE, "!"


# Verteile die Karten auf zwei Spieler
stapel

# Selektiere jedes zweite Element (beginnend beim ersten)
bool1 <- c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)
bool1
hand1 <- stapel[bool1]
hand1

# Karten für den 2. Spieler: jene Karten, die Spieler 1 nicht bekommt
!bool1
hand2 <- stapel[!bool1]
hand2



### -------------------------------------------------------------------------
### 3.3  Recycling
### -------------------------------------------------------------------------


stapel

# Selektiere jedes zweite Element aus stapel (beginnend beim ersten)
stapel[c(TRUE, FALSE)]

# Interne Entsprechung
stapel[c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)]


stapel

# Selektiere jedes vierte Element (beginnend beim ersten)
stapel[c(TRUE, FALSE, FALSE, FALSE)]

# Interne Entsprechung
stapel[c(TRUE, FALSE, FALSE, FALSE, TRUE, FALSE)]


# Recycling bei arithmetischen Rechenoperationen
y <- 1:4 * c(-1, 1)  # 2 ist ein Teiler von 4 => vollständiges Recycling
y

y <- 1:5 * c(-1, 1)  # 2 ist kein Teiler von 5 => unvollständiges Recycling
y


stapel

# Verteile die Karten an 2 Spieler
# Spieler 1 bekommt jede zweite Karte (beginnend bei der ersten).
# Spieler 2 erhält alle anderen Karten.
bool1 <- c(TRUE, FALSE)

# Karten des 1. Spielers
hand1 <- stapel[bool1]
hand1

# Karten des 2. Spielers
hand2 <- stapel[!bool1]
hand2



### -------------------------------------------------------------------------
### 3.4  Logische Bedingungen und Operatoren
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 3.4.1  Elemente vergleichen -- "==", "!", "!=", "<", "<=", ">", ">="


stapel

# 1.) Sind die Werte gleich 5?
stapel == 5

# 2.) Sind die Werte grösser als 5?
stapel > 5

# 3.) Sind die Werte ungleich 5?
stapel != 5


# Selektiere alle Elemente >= 5
stapel[stapel >= 5]

# Selektiere alle Elemente, die nicht kleiner als 5 sind
stapel[!(stapel < 5)]   # mit Klammern

# Selektiere alle Elemente, die nicht kleiner als 5 sind
stapel[! stapel < 5]    # ohne Klammern


# Selektiere alle negativen Zahlen
stapel[stapel < 0]      # Ergebnis ist ein leerer (numerischer) Vektor

# Ein leerer Vektor hat Länge 0.
length(stapel[stapel < 0])

# Ist obiger Vektor leer?
length(stapel[stapel < 0]) == 0


### -------------------------------------------------------------------------
### 3.4.2  Bedingungen verknüpfen -- "&", "|"


# Verhalten der Und-Verknüpfung
TRUE & TRUE
TRUE & FALSE
FALSE & FALSE

# Verhalten der Oder-Verknüpfung
TRUE | TRUE
TRUE | FALSE
FALSE | FALSE


stapel

stapel > 2
stapel <= 5
stapel > 2 & stapel <= 5

# Selektiere alle Elemente > 2 und <= 5
stapel[stapel > 2 & stapel <= 5]


stapel

stapel < 4
stapel > 5
stapel < 4 | stapel > 5

# Selektiere alle Elemente < 4 oder > 5
stapel[stapel < 4 | stapel > 5]



### -------------------------------------------------------------------------
### 3.5  Rechnen mit Wahrheitswerten
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 3.5.1  Absolute und relative Häufigkeiten -- sum(), mean()


# Karten des 1. Spielers
hand1
hand1 >= 5

# Anzahl der Karten >= 5
sum(hand1 >= 5)

# Karten des 2. Spielers
hand2
hand2 >= 5

# Anzahl der Karten >= 5
sum(hand2 >= 5)


# Rechnen mit Wahrheitswerten
# entspricht 1 + 0 + 1
TRUE + FALSE + TRUE

# entspricht 2 * 1 + 1 * 0
2 * TRUE + 1 * FALSE


stapel

# Bestimme den Anteil der Karten im Stapel mit einem Wert >= 5
mean(stapel >= 5)

# Anzahl Karten >= 5 von Spieler 1
sum(hand1 >= 5)

# Anzahl Karten >= 5 von Spieler 2
sum(hand2 >= 5)


# Hat Spieler 1 mehr Karten mit einem Wert >= 5 bekommen als Spieler 2?
sum(hand1 >= 5) > sum(hand2 >= 5)


### -------------------------------------------------------------------------
### 3.5.2  Indexwerte bestimmen -- which()


# Die wievielte Karte im Stapel ist die 7?
stapel
1:length(stapel)

stapel == 7

# Ermittle den Index des Eintrags mit dem Wert 7
index <- (1:length(stapel))[stapel == 7]
index

# Ermittle den Index des Eintrags mit dem Wert 7 - mit which()
which(stapel == 7)


stapel

# 1.)
# Alle Indizes jener Elemente, die >= 5 sind
which(stapel >= 5)

# 2.)
# Erster Index eines Elements, das >= 5 ist
ind1 <- which(stapel >= 5)[1]
ind1

# Welchen Wert hat dieses Element?
stapel[ind1]


# Kein Element < 0 => leerer Vektor
which(stapel < 0)

# Zugriff auf nicht existierendes Element => NA
which(stapel < 0)[1]

# Zugriff auf Element(e) mit Index/Wahrheitswert NA
stapel[which(stapel < 0)[1]]


# Alle Elemente >= 5 selektieren: Ineffiziente Variante
stapel[which(stapel >= 5)]

# Alle Elemente >= 5 selektieren: Effiziente Variante
stapel[stapel >= 5]



### -------------------------------------------------------------------------
### 3.6  Ersetzen und Tauschen von Werten
### -------------------------------------------------------------------------


stapel

# Vertausche 1. und letztes Element - mit Fehler!
stapel.neu <- stapel[c(length(stapel), 2:(length(stapel - 1)), 1)]
stapel.neu


stapel

# Vertausche 1. und letztes Element - fehlerfrei
stapel.neu <- stapel[c(length(stapel), 2:(length(stapel) - 1), 1)]
stapel.neu


# Beispielvektor
x <- c(2, -5, 3, 4, -1)
x

# Verdopple in x alle positiven Einträge
x[x > 0] <- x[x > 0] * 2
x


x

# Ersetze alle negativen Werte von x durch 0
x[x < 0] <- 0
x


# Stapel kopieren
stapel.neu <- stapel
stapel.neu

# Vertausche 1. und letztes Element - mit Fehler
stapel.neu[1] <- stapel.neu[length(stapel.neu)]
stapel.neu[length(stapel.neu)] <- stapel.neu[1]

stapel.neu


# Vertausche 1. und letztes Element - fehlerfrei
stapel.neu[1] <- stapel[length(stapel)]
stapel.neu[length(stapel.neu)] <- stapel[1]
stapel.neu


stapel.neu <- stapel
stapel.neu

# Vertausche 1. und letztes Element - fehlerfrei
temp <- stapel.neu[1]
stapel.neu[1] <- stapel.neu[length(stapel.neu)]
stapel.neu[length(stapel.neu)] <- temp

stapel.neu



### -------------------------------------------------------------------------
### 3.7  Aus der guten Programmierpraxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 3.7.2  Programmierstil: Allgemein und automatisiert programmieren


stapel


# Ausbaufähige Variante

# Letzte Karte selektieren
stapel[6]

# Jede 2. Karte selektieren
stapel[c(1, 3, 5)]


# Allgemeine, automatisierte Variante

# Letzte Karte selektieren
stapel[length(stapel)]

# Jede 2. Karte selektieren
stapel[c(TRUE, FALSE)]


# Stapel verlängern
stapel <- c(stapel, 9, 8)
stapel


# Ausbaufähige Variante

# Letzte Karte selektieren
stapel[6]

# Jede 2. Karte selektieren
stapel[c(1, 3, 5)]


# Allgemeine, automatisierte Variante

# Letzte Karte selektieren
stapel[length(stapel)]

# Jede 2. Karte selektieren
stapel[c(TRUE, FALSE)]


# Stapel wieder zurücksetzen
stapel <- stapel[-c(length(stapel) - 1, length(stapel))]
stapel


# Ausbaufähige Variante

# Ermittle die Lösungen für die quadratische Gleichung
# 2 x^2 - 5 x + 3 = 0

# Ermittlung der Lösungen
x1 <- (-(-5) + sqrt((-5)^2 - 4 * 2 * 3)) / (2 * 2)
x2 <- (-(-5) - sqrt((-5)^2 - 4 * 2 * 3)) / (2 * 2)

# Anzeigen der Lösungen
x1
x2


# Allgemein programmierte Variante

# Ermittle die Lösungen für die quadratische Gleichung
# a x^2 + b x + c = 0

# Festlegen der Koeffizienten
a <- 2
b <- -5
c <- 3

# Ermittlung der Lösungen
x1 <- (-b + sqrt(b^2 - 4 * a * c)) / (2 * a)
x2 <- (-b - sqrt(b^2 - 4 * a * c)) / (2 * a)

# Anzeigen der Lösungen
x1
x2



### -------------------------------------------------------------------------
### 3.8  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 3.8.3  Übungen


stapel


# Beispielvektor
x <- 1:5
x

# Ansatz Nr. 1
x[1:length(x) - 2]

# Ansatz Nr. 2
x[-length(x):length(x) - 1]


alter <- c(16, 18, 19, 24, 28, 32, 32, 45)


# Hand von Spieler 1
hand1

# Hand von Spieler 2
hand2
