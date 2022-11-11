### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 22
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Die Daten dieses Kapitels
# Ggf. Arbeitsverzeichnis wechseln oder Pfad angeben
objekte <- load("Pizza.RData")
objekte

pizza
pizza.liste
preise


# Schritt 1: Zusaten zusammenbauen
zutaten.string <- sapply(pizza.liste, paste, collapse = ", ")
zutaten.string

# Schritt 2: Preise zusammenbauen. Die Preise sollen alle mit zwei
# Nachkommastellen angegeben werden.
preise.string <- as.character(preise)
preise.string

# Ist ein Preis ganzzahlig, so hat diese Zahl kein Dezimalkomma.
# Dezimalzahlen wiederum haben allesamt nur eine Nachkommastelle. Das
# nuetzen wir in ifelse() aus.
nullen <- ifelse(!grepl("[.]", preise.string), ".00", "0")
preise.string <- paste0(preise.string, nullen)
preise.string

# Dezimalzeichen aendern und Euro anhaengen
preise.string <- paste(preise.string, "Euro")
preise.string <- sub("[.]", ",", preise.string)
preise.string

# Schritt 3: Alle Informationen zusammensetzen
paste0(namen, ": ", zutaten.string, ". ", preise.string)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


namen

# Letzten Buchstaben extrahieren ...
substring(namen, nchar(namen))

# ... und bestimmen, ob all diese Selbstlaute sind.
all(substring(namen, nchar(namen)) %in% c("a", "e", "i", "o", "u"))



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


# Beispielvektor
x <- c("Baumhaus", "Reihenhaus", "Stiege", "Stiegenhaus", "Stiegenbauer")
x


### a)

# Idee: Wir fragen ab, ob ein String mehr als 8 Zeichen hat. Falls ja, so
# muss er gekuerzt werden, falls nein, so passiert nichts.
x.kurz <- ifelse(nchar(x) > 8, paste0(substring(x, 1, 6), "~1"), x)
x.kurz


### b)

# Wir selektieren all jene Woerter, bei denen eine Kuerzung noetig war.
# Von diesen Woertern nehmen wir das 7. Zeichen und erfragen, ob dieser
# einer Tilde gleicht.
all(substring(x.kurz[nchar(x) > 8], 7, 7) == "~")



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


text <- c("R ist super. Mit R kann ich so viele tolle Dinge tun.",
  "Zeichenketten aufsplitten ist ein Beispiel.",
  "Vektoren umdrehen und das erste Element selektieren.")
text


### a)

# Zwei Woerter sind durch ein Leerzeichen getrennt. Wenn wir annehmen,
# dass jedes Element von text aus mindestens einem Wort besteht, koennen
# wir die Anzahl der Leerzeichen als Grundlage verwenden.

temp <- gregexpr(" ", text)
temp

# Zaehle Anzahl der Leerzeichen und addiere 1
sapply(lapply(temp, ">", 0), sum) + 1


# Eine weitere Variante: Mit strsplit() nach Leerzeichen splitten und
# die Anzahl der Elemente zaehlen.
lapply(text, strsplit, split = " ")

# strsplit() gibt immer eine Liste zurueck! Daher entsteht hier eine
# verschachtelte Liste: eine Liste mit 3 (= length(x)) Elementen, wobei
# jedes Element eine einelementige Liste mit den Woertern des
# entsprechenden Eintrags von text enthaelt.

# Wir muessen diese Sublisten zunaechst selektieren (mit "[["()).
lapply(lapply(text, strsplit, split = " "), "[[", 1)

# Wir haben jetzt eine Liste mit 3 (= length(x)) Elementen und jede
# Listenkomponente enthaelt die Vektoren mit den Woertern der
# entsprechenden Eintraege. Jetzt brauchen wir nur noch die Anzahl
# der Elemente bestimmen.
sapply(lapply(lapply(text, strsplit, split = " "), "[[", 1), length)


### b)

# Satzzeichen zaehlen nicht. Im Text kommen nur Punkte vor; wir loeschen
# daher alle Punkte aus text heraus.
text.buchstaben <- gsub("[.]", "", text)
text.buchstaben

# Eine allgemeinere Methode, um Satzzeichen zu loeschen, ist
# (vgl. Kapitel Regular Expressions)
gsub("[[:punct:]]", "", text)

# Wir splitten den satzzeichenlosen Text nach Leerzeichen auf, zaehlen
# dann die Anzahl der Buchstaben pro Wort und mitteln abschliessend.
text.split <- strsplit(text.buchstaben, split = " ")
text.split

lapply(text.split, nchar)
sapply(lapply(text.split, nchar), mean)


### c)

# Hier gibt es mehrere Varianten. Eine (von text.buchstaben ausgehende)
# ist folgende:
# 1.) Loesche alle Leerzeichen
# 2.) Wandle alle Buchstaben in Grossbuchstaben um
# 3.) Zerlege den Text in die Buchstaben und ordne die Buchstaben in
#     einem Vektor an.
# 4.) Erstelle eine lueckenlose Haeufigkeitstabelle

# 1.)
temp <- gsub(" ", "", text.buchstaben)
temp

# 2.)
temp <- toupper(temp)
temp

# 3.)
buchstaben <- unlist(strsplit(temp, split = ""))
buchstaben

# 4.)

# Leere Tabelle vorbereiten (mit allen Buchstaben)
tab.voll <- rep(0, length(LETTERS))
names(tab.voll) <- LETTERS
tab.voll

# Tabelle mit Haeufigkeiten befuellen
tab <- table(buchstaben)
tab

tab.voll[names(tab)] <- tab
tab.voll



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


dateien <- c("Version_2.1.txt", "Liste_2019.08.01.xlsx", "Run.R")
dateien


# Wir splitten zunaechst nach jedem Punkt. Beachte, dass der Punkt ein
# Sonderzeichen ist.
dateien.split <- strsplit(dateien, "[.]")
dateien.split

# Die Dateiendungen befinden sich jeweils an letzter Stelle. Wir koennen
# die einzelnen Vektoren umdrehen und das erste Element selektieren, um
# an die gewuenschten Dateiendungen zu kommen.
lapply(dateien.split, rev)
sapply(lapply(dateien.split, rev), "[", 1)



### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


# Beispielvektor
x <- c(" Auto", "R ist super!", "Ja")
x


# Sofern das erste Zeichen ein Leerzeichen ist, wird es herausgestrichen.
ifelse(substring(x, 1, 1) == " ", substring(x, 2, nchar(x)), x)

# Hier ist Vorsicht geboten. Folgender naheliegender Code tut *nicht*
# dasselbe:
sub(" ", "", x)

# sub() loescht das erste Leerzeichen, egal, wo es steht. Das heißt, wir
# brauchen das ifelse() weiterhin.
ifelse(substring(x, 1, 1) == " ", sub(" ", "", x), x)

# Nach dem naechsten Kapitel wirst du wohl eher Folgendes schreiben:
sub("^ ", "", x)

# Das ^ markiert den Anfang eines Strings. Naeheres dazu im naechsten
# Kapitel!

