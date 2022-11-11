### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 18
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


### a)

# Der Code wendet auf den Vektor 1:n elementweise den Sequenzoperator : an.
# lapply() liefert eine Liste mit 1:1, 2:1, 3:1, ..., n:1. Mit sapply()
# werden dann die Sequenzen addiert, also 1, 3, 6, 10, ...
n <- 6
sapply(lapply(1:n, ":", 1), sum)


### b)

# Der Code berechnet die kumulierte Summe des Vektors 1:n.
cumsum(1:n)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


pizzen <- list(
  Margherita  = c("Tomaten", "Kaese"),
  Cardinale   = c("Tomaten", "Kaese", "Schinken"),
  "San Romio" = c("Tomaten", "Kaese", "Schinken", "Salami", "Mais"),
  Provinciale = c("Tomaten", "Kaese", "Schinken", "Mais", "Pfefferoni"))

pizzen


### a)

# Zunaechst erfragen wir fuer jede Pizza, ob die Zutaten Schinken oder
# Salami gleichen. Dazu wenden wir den "%in%"-Operator an.
bool.fleisch <- lapply(pizzen, "%in%", c("Schinken", "Salami"))
bool.fleisch

# Jetzt zaehlen wir die TRUE in jeder Komponente.
anz.fleisch <- sapply(bool.fleisch, sum)
anz.fleisch


### b)

sum(anz.fleisch == 0)


### c)

# Schritt 1: Die Zutaten als Text aufschreiben
zutaten.text <- sapply(pizzen, paste, collapse = ", ")
zutaten.text

# Beachte, dass wir hier collapse und nicht sep benoetigen! Denn sapply()
# uebergibt paste() immer nur *einen* Vektor mit allen Zutaten (und nicht
# mehrere Vektoren mit jeweils einer Zutat).

# Schritt 2: Namen davorhaengen
pizzen.string <- paste0(names(pizzen), ": ", zutaten.text)
pizzen.string

# Wer den Text buendig ausrichten will, darf sich die Funktion format()
# ansehen ;-)


### d)

# Schritt 1: Selektiere die ersten beiden Zutaten jeder Pizza
zutaten.12 <- lapply(pizzen, "[", 1:2)
zutaten.12

# Schritt 2: Pruefe, ob diese Elemente in c("Tomaten", "Kaese") liegen
bool <- lapply(zutaten.12, "%in%", c("Tomaten", "Kaese"))
bool

# Schritt 3: Wenn in jeder Komponente genau zwei TRUE stehen, dann sind
# die ersten beiden Zutaten Tomaten und Kaese.
all(sapply(bool, sum) == 2)



### -----------------------------------------------------------------------
### Beispiel 3 (Fortsetzung von Beispiel 2)
### -----------------------------------------------------------------------


### a)

# Die ersten beiden Elemente jeweils entfernen
pizzen12 <- lapply(pizzen, "[", -(1:2))
pizzen12


# Allgemeinere Variante mit mapply()
# ?mapply
# Wir wenden "%in%" auf jede Kompoenente von pizzen an. Vergleichsargument
# ist jeweils c("Tomaten", "Kaese"), das muessen wir in eine Liste packen.
bool <- mapply("%in%", pizzen, list(c("Tomaten", "Kaese")))
bool

# Wahrheitswerte in bool umdrehen:
# TRUE, wenn nicht Tomaten oder Kaese
bool <- lapply(bool, "!")
bool

# Selektieren der Zutaten
pizzen12 <- mapply("[", pizzen, bool, SIMPLIFY = FALSE)
pizzen12


### b)

pizzen12 <- lapply(pizzen12, sort)
pizzen12


### c)

# i) Das Problem: Tomaten und Kaese wird *hinten* angehaengt.
lapply(pizzen12, c, c("Tomaten", "Kaese"))

# ii) c() hat lediglich das Dreipunkteargument, dem wir zu verkettende
# Elemente uebergeben. Damit haben wir keine Moeglichkeit, die
# Reihenfolge der Argumente zu beeinflussen.


### d)

# ?append
# append() ermoeglicht es uns, Elemente nach einer beliebigen Stelle
# (Parameter after) in einen Vektor einzufuegen. Mit after = 0 wird ganz
# zu Beginn angehaengt.
pizzen.sort <- lapply(pizzen12, append, c("Tomaten", "Kaese"), after = 0)
pizzen.sort


### Zusatz: Wie koennen wir das mit c() machen?

# Idee: Wir koennen in lapply() mit c() Elemente nur hinten anfuegen. Wenn
# wir die Zutaten in pizzen12 absteigend sortieren und dann Kaese und
# Tomaten (in dieser Reihenfolge) anhaengen, dann koennen wir die Zutaten
# umdrehen und wir haetten das Problem geloest.

# Schritt 1: Zutaten in pizzen12 absteigend sortieren
pizzen12 <- lapply(pizzen12, sort, decreasing = TRUE)
pizzen12

# Schritt 2: Kaese und Tomaten anhaengen mit c()
temp <- lapply(pizzen12, c, c("Kaese", "Tomaten"))
temp

# Schritt 3: Vektoren in temp umdrehen
pizzen.sort <- lapply(temp, rev)
pizzen.sort



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


x <- list(c("L", "E", "A"), c("I", "S", "S", "T"),
          c("E", "I", "E", "R"))
x


### a)

# i) Jeder Eintrag von x besteht aus 3 unterscheidbaren Elementen, also
# matrix
sapply(x, unique)

# ii) sample() erzeugt eine Permutation. Nicht alle 3 Elemente von x
# haben dieselbe Laenge, also
# list
sapply(x, sample)

# iii) Es wird von jedem Eintrag von x genau ein Element gezogen, also
# vector
sapply(x, sample, size = 1)

# iv) Es werden zwei Elemente gezogen, also
# matrix
sapply(x, sample, size = 2)


# Beachte: Bei Matrizen werden die Ergebnisvektoren spaltenweise
# angeordnet. So stehen in der Matrix des ersten Codes in der i. Spalte
# die unterscheidbaren Elemente des i. Eintrags von x.


### b)

# i) sapply(x, unique)
# Hier kann jede der drei Datenstrukturen herauskommen:
# vector, wenn jedes Element von x genau ein unterscheidbares Zeichen hat.
# matrix, wenn jedes Element gleich viele unterscheidbare Zeichen hat, aber
#   mindestens 2.
# list, in allen anderen Faellen

# ii) sapply(x, sample)
# Hier kann theoretisch jede der drei Datenstrukturen herauskommen:
# vector, wenn jedes Element von x genau ein Zeichen hat.
# matrix, wenn jedes Element gleich viele Zeichen hat, aber mindestens 2.
# list, in allen anderen Faellen

# iii) sapply(x, sample, size = 1)
# Hier kann nur ein Vektor herauskommen, da immer genau ein Element gezogen
# wird.

# iv) sapply(x, sample, size = 2)
# Hier kann nur eine Matrix herauskommen, denn es werden immer zwei Element
# gezogen.
# Sollte x ein Element mit nur einem Zeichen enthalten, so wuerde eine
# Fehlermeldung herauskommen.


### c)

# Schritt 1: Die Buchstaben in jeder Komponente verschmelzen. Beachte, dass
# wir collapse (und nicht sep) benoetigen.
sapply(x, paste, collapse = "")

# Schritt 2: Die Woerter verketten, auch hier nehmen wir collapse.
paste(sapply(x, paste, collapse = ""), collapse = " ")

