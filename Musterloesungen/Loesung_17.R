### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 17
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Matrix X aus der Einleitung
X <- matrix(c(2, 1, -2, 0, 0.5, 0, 2, 4, 7), ncol = 3)
X


### a)

# qr() gibt eine beschriftete Liste zurueck. Der Rang ist unter $rank
# abrufbar.
qr(X)
X.rang <- qr(X)$rank
X.rang


### b)

X.liste <- list(matrix = X, rang = X.rang)
X.liste


### c)

# Dimension hinzufuegen: Zwei Moeglichkeiten
X.liste$dim <- dim(X)
X.liste[["dim"]] <- dim(X)
X.liste

# Elemente umordnen
X.liste <- X.liste[c("matrix", "dim", "rang")]
X.liste



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

str(pizzen)

# 4 Listenelemente => 4 Pizzen
# chr [1:k] gibt an, dass es sich um einen character-Vektor der Laenge k
# handelt. Also 2, 3, 5 und 5 Zutaten


### b)

# Wir kombinieren unlist() und unique()
zutaten <- unique(unlist(pizzen))
zutaten

# Anzahl der unterscheidbaren Zutaten
length(zutaten)


### c)

# Wir entfernen Tomaten und Kaese aus der Zutatenliste und waehlen aus
# den restlichen beiden zwei zufaellig mit sample() aus.
bool <- zutaten %in% c("Tomaten", "Kaese")
bool

pizza.neu <- c(zutaten[bool], sample(zutaten[!bool], size = 2))
pizza.neu

# Neue Pizza an die Liste anhaengen
pizzen$Fantastico <- pizza.neu
pizzen


### d)

# Zwei Varianten:
# mit order() oder sort() (funktioniert, da Elemente beschriftet sind.

# Variante order()
pizzen <- pizzen[order(names(pizzen))]
pizzen

# Variante sort()
pizzen <- pizzen[sort(names(pizzen))]
pizzen


### e)

# lengths() gibt uns die Laenge jeder Listenkomponente zurueck, wendet
# also length() auf jede Listenkomponente an.
n.zutaten <- lengths(pizzen)
n.zutaten

# Wenn wir nur eine Pizza mit den wenigsten Zutaten loeschen wollen, dann
# verwenden wir which() und selektieren einen (etwa den ersten) Index.
ind <- which(n.zutaten == min(n.zutaten))[1]
ind

# Pizza loeschen
pizzen <- pizzen[-ind]
pizzen

# Alternativ ginge zum Beispiel auch Folgendes:
# pizzen[[ind]] <- NULL
# pizzen[names(pizzen) != names(ind)]

