### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 12
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


ngeschwister <- c(0, 1, 0, 1, 6, 5, 2, 0)
tab.geschwister <- table(ngeschwister)
tab.geschwister


### a)

# Nein. Hier werden Tabelleneintraege mit Haeufigkeiten zwischen 1 und 5
# selektiert.
tab.geschwister[tab.geschwister %in% 1:5]

# Ja. Vor der Selektion wird 1:5 implizit in einen character-Vektor
# umkonvertiert.
tab.geschwister[names(tab.geschwister) %in% 1:5]

# Ja. Im Unterschied zum vorherigen Code erfolgt die Umwandlung explizit.
tab.geschwister[names(tab.geschwister) %in% as.character(1:5)]

# Nein. Es werden (ungeachtet der Beschriftungen) die ersten 5 Eintraege
# der Tabelle selektiert.
tab.geschwister[1:5]

# Ja. Durch die Umwandlung in einen character-Vektor werden die Eintraege
# mit den Beschriftungen "1" bis "5" selektiert. Im Unterschied zu den
# anderen funktionierenden Codes werden nicht vorhandene Eintraege mit NA
# markiert (hier "3" und "4").
tab.geschwister[as.character(1:5)]


### b)

# Wir schauen uns an, was passiert, wenn jemand 12 Geschwister hat.
ngeschwister <- c(ngeschwister, 12)
tab.geschwister = table(ngeschwister)
tab.geschwister

# Jetzt funktioniert die Sortierung nicht mehr korrekt:
tab.geschwister[sort(names(tab.geschwister), decreasing = TRUE)]

# Der Grund: Beschriftungen (names) sind immer vom Mode character. Das
# heisst, die Beschriftungen werden *alphabetisch* sortiert. Demnach reiht
# sich 12 zwischen 1 und 2 ein.

# Die implizite Annahme ist also, dass alle befragten Personen hoechstens
# 9 Geschwister haben. Um diese Annahme aufzuloesen, koennen wir die
# Beschriftungen vor dem Sortieren in einen numerischen Vektor umwandeln
# und nach dem Sortieren wieder in einen Stringvektor zuruckkonvertieren.

temp <- sort(as.numeric(names(tab.geschwister)), decreasing = TRUE)
temp

tab.geschwister[as.character(temp)]


### c)

# Wir belassen denjenigen mit 12 Geschwistern einfach mal in der Tabelle.
tab.geschwister

# Eine Moeglichkeit: Wir selektieren die Anzahl der Einzelkinder und jene
# der Nicht-Einzelkinder ...
n.einzel <- sum(tab.geschwister["0"], na.rm = TRUE)
n.geschw <- sum(tab.geschwister[names(tab.geschwister) != "0"], na.rm = TRUE)

n.einzel
n.geschw

# ... und erstellen daraus einen beschrifteten Vektor.
c(Einzelkind = n.einzel, Geschwisterkind = n.geschw)

# Die Summenbildung auch bei Einzelkindern ermoeglicht es uns den Fall
# abzudecken, dass es keine Einzelkinder gibt. In dem Fall wird die
# Haeufigkeit 0 angegeben, wie folgender einfacher Code zeigt.
sum(NA, na.rm = TRUE)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


alter <- c(Max = 31, Alex = 37, Christian = 26)
alter


### a)

# Zwei Varianten
names(sort(alter))
names(alter)[order(alter)]


### b)

# Zwei Varianten
alter[order(names(alter))]
alter[sort(names(alter))]



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


noten <- c(3, 2, 4, 4, 2, 4, 5, 3) # Die einzelnen Noten
tab.note <- table(noten) # Häufigkeitstabelle der Noten
tab.note


### a)

# Die Summenbildung deckt den Fall ab, dass keiner die Note 5 bekommen hat.
sum(tab.note[names(tab.note) == "5"], na.rm = TRUE) / sum(tab.note)


### b)

# 1.) Leere beschriftete Tabelle vorbereiten
names <- 1:5
tab.note.voll <- rep(0, length(names))
names(tab.note.voll) <- names
tab.note.voll

# 2.) Haeufigkeiten uebernehmen
tab.note.voll[names(tab.note)] <- tab.note
tab.note.voll


### c)

names(tab.note.voll)[tab.note.voll <= 1]


### d)

names(tab.note.voll)[tab.note.voll == max(tab.note.voll)]

