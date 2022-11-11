### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 15
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


Z <- cbind(c(3, 4, 2, 1), c(1, 2))
Z
# Hier wird c(1, 2) einem Recycling zugefuehrt.


Z <- Z[order(Z[, 1]), ]
Z
# Hier werden die Zeilen von Z aufsteigend nach der ersten Spalte geordnet.


Z <- Z * c(-1, 1)
Z
# Hier wird c(-1, 1) ebenfalls einem Recycling zugefuehrt und anschliessend
# wird Z spaltenweise mit diesem Vektor multipliziert. Effektiv wird hier
# jede ungerade Zeile mit -1 und jede gerade Zeile mit +1 multipliziert.


Z <- rbind(Z, colSums(Z))
Z <- cbind(Z, Z[, 1] + Z[, 2])
Z
# Zunaechst werden die Spaltensummen als Zeile angehaengt. Anschliessend
# wird die elementweise Summe der ersten beiden Spalten als Spalte
# angehaengt.



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


> # Daten laden
> # Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
objekte <- load("Minigolf_Matrizen.RData")
objekte

Schlaege


# Der Code liefert eine 2-spaltige Matrix mit Zeilen- und Spaltenindizes
# jener Elemente, welche die Bedingung erfuellen. Hier alle Elemente von
# Schlaege, die >= 5 sind.
which(Schlaege >= 5, arr.ind = TRUE)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


Pkt <- matrix(c(43, 45, 17, NA, 13, 32, NA, NA, 49, 15),
  ncol = 2, byrow = TRUE)
Pkt

# Anzahl Zeilen / Spalten bestimmen
n <- nrow(Pkt)
k <- ncol(Pkt)


### a)

rownames(Pkt) <- paste0("Stud", 1:n)
colnames(Pkt) <- paste0("T", 1:k)
Pkt


### b)

colSums(is.na(Pkt))


### c)

res <- colMeans(Pkt, na.rm = TRUE)
res

names(res)[res == max(res)]


### d)

# Wir erstellen eine neue Matrix, die nur Zeilen ohne NAs enthaelt.
# drop = FALSE sichert uns fuer den Fall ab, dass weniger als zwei Zeilen
# uebrig bleiben.
Pkt.ohneNA <- Pkt[rowSums(is.na(Pkt)) == 0, , drop = FALSE]
Pkt.ohneNA

res <- colMeans(Pkt.ohneNA)
res

names(res)[res == max(res)]


### e)

Pkt[is.na(Pkt)] <- 0
Pkt


### f)

# Wir zaehlen zunaechst in jeder Zeile, wie viele Tests mit mindestens 40
# Punkten abgeschlossen wurden. Wenn auf jeden Test mindestens 40 Punkte
# erzielt wurden, so muss diese Anzahl gleich k sein.
bool <- rowSums(Pkt >= 40) == k
bool

rownames(Pkt)[bool]


### g)

Pkt[order(rowSums(Pkt), decreasing = TRUE), , drop = FALSE]


### h)

# Bestanden, wenn mind. die Haelfte der erreichbaren Punkte erzielt wurde.
pkt.best <- k * 50 / 2
pkt.best

# Bestimme den Prozentwert
mean(rowSums(Pkt) >= pkt.best) * 100



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


### a)

# Existierender nicht funktionierender Code
S <- matrix(0, ncol = 8, nrow = 8)
S <- (col(S) + row(S) %% 2 == 0) + 1
S

# Korrektur: Wir hangeln uns schrittweise zur Loesung empor.
col(S) + row(S)
(col(S) + row(S)) %% 2  # Beachte Klammersetzung!
(col(S) + row(S)) %% 2 + 1

# Also unterm Strich
S <- matrix(0, ncol = 8, nrow = 8)
S <- (col(S) + row(S)) %% 2 + 1
S


### b)

# Eine Moeglichkeit: Wir erstellen zwei Vektoren, welche 1 2 1 2 ... (fuer
# ungerade Spalten) sowie 2 1 2 1 ... (fuer gerade Spalten) enthalten und
# replizieren beide Vektoren 4 Mal.
temp1 <- rep(1:2, times = 4)
temp2 <- rev(temp1)

elems <- rep(c(temp1, temp2), times = 4)
elems

# Jetzt befuellen wir eine Matrix mit den soeben gewonnen Elementen.
matrix(elems, ncol = 8)


### c)

colnames(S) <- LETTERS[1:8]  # Auch LETTERS[LETTERS <= "H"] moeglich
rownames(S) <- 8:1
S


### Spielerei für Interessierte
# Stelle ein schwarzes Feld durch B (Black) dar und ein weisses Feld soll
# leer bleiben.

S[S == 1] <- ""
S[S == 2] <- "B"
S

# Schoene Ausgabe mit quote = FALSE
print(S, quote = FALSE)



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


n <- 3    # Anzahl der Tipps
k <- 9   # Anzahl der Zahlen der Lotterie


### Die Tipperstellung

# Die Kunst bei dieser Aufgabe ist es, durch geschickte Mehrfachsortierung
# das gewuenschte Ergebnis zu erreichen. Wir machen einmal Folgendes 
# (um die Idee besser nachvollziehen zu koennen, setze oben k = 9):
zahlen <- rep(1:k, times = n)
id.tipp <- rep(1:n, each = k)
id.rand <- sample(1:(n*k))

zahlen
id.tipp
id.rand

# zahlen enthaelt alle Lottozahlen, und zwar n Mal. Wir koennen die Zahlen
# mischen, indem wir jeder Zahl eine eindeutige Zufallszahl zwischen 1 und
# n*k zuordnen (in sample(1:(n*k)) und sie anschliessend gemaess dieser
# Zufallszahlen sortieren.
# Das Problem waere aber, dass dann in einem Tipp eine Zahl doppelt
# vorkommen koennte. Um das zu unterbinden, erzeugen wir id.tipp, das jeder
# Zahl den entsprechenden Tipp zuordnet, fuer die sie infrage kommt.
# Wenn wir jetzt die Zahlen zuerst nach id.tipp und dann nach id.rand
# sortieren, dann bekommen wir lauter Sequenzen der Laenge 45 mit gemischten
# Lottozahlen von 1 bis 45.

zahlen <- zahlen[order(id.tipp, id.rand)]
zahlen

# Jetzt ordnen wir diese Lottozahlen zeilenweise in eine Matrix ein.
Tipp <- matrix(zahlen, nrow = n, byrow = TRUE)
Tipp

# Jede Zeile enthaelt jetzt eine Permutation der Zahlen von 1 bis 45. Um
# gueltige Tipps zu bekommen, selektieren wir jetzt noch die ersten 6
# Spalten (bzw. beliebige 6 Spalten).
Tipp <- Tipp[, 1:6]
rownames(Tipp) <- paste0("Tipp", 1:n)
Tipp

# Voilà :-)


### Sortierung

# Um die Zahlen der Tipps zu sortieren, gehen wir aehnlich vor.
# Wir entnehmen die Zahlen aus Tipp (spaltenweise) und ordnen ihnen den 
# Index des Tipps zu (id.tipp.sort)
tipp.vektor <- as.vector(Tipp)
id.tipp.sort <- rep(1:n, times = 6)
tipp.vektor
id.tipp.sort

# Jetzt sortieren wir die Zahlen von tipp.vektor zuerst nach der Tipp-Id
# und dann nach den Zahlen selbst. Dadurch bleiben die 6er-Bloecke erhalten
# bzw. sortieren wir jeden 6er-Block aufsteigend.
tipp.vektor <- tipp.vektor[order(id.tipp.sort, tipp.vektor)]
tipp.vektor

# Jetzt bauen wir uns wieder eine Matrix zusammen, fertig :-)
Tipp <- matrix(tipp.vektor, nrow = n, byrow = TRUE)
rownames(Tipp) <- paste0("Tipp", 1:n)
Tipp

