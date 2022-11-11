### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 23
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


rechnungen <- c("9 + 10 = 19, 2 - 5 = -3,11^2 = 121, 8-7=1")
rechnungen


### a)

# + ist ein Sonderzeichen, muss daher besonders behandelt werden.
sum(unlist(gregexpr("\\+", rechnungen)) > 0)
sum(unlist(gregexpr("[+]", rechnungen)) > 0)


### b)

# Variante 1: Mit gregexpr() jede Stelle einer Ziffer von 3 bis 5 
# bestimmen und die Anzahlen bestimmen.
ind.345 <- unlist(gregexpr("[345]", rechnungen))
ind.345

sum(ind.345 > 0)


# Variante 2: Zerlege rechnungen in die einzelnen Zeichen und pruefe fuer
# jedes Zeichen, ob es in der Menge 3:5 enthalten ist.
zeichen <- unlist(strsplit(rechnungen, split = ""))
zeichen

sum(zeichen %in% 3:5)


### c)

# Eine Moeglichkeit:
# Matche "=", Leerzeichen und eine Zahl (ohne Minus davor)
gregexpr("= *[0-9]+", rechnungen)[[1]]
sum(gregexpr("= *[0-9]+", rechnungen)[[1]] > 0)

# -3 fällt durch, da das Muster nicht erfüllt wird.


### d)

# Ergebnis ist 1 <=> Muster = "=" + beliebige Leerzeichen + 1 + keine Ziffer
# und kein "." (= 1.0 wuerde in diesem Fall nicht durchrutschen). Falls die
# 1 am Ende des Strings steht, so wuerde dieses Ergebnis nicht gematcht, wir
# muessen daher eine Oder-Verknuepfung einbauen fuer diesen Fall.
pattern <- "= *1[^0-9.]|= *1$"
pattern

# Alternative ueber Gruppen:
pattern <- "= *1([^0-9.]|$)"
pattern

gregexpr(pattern, rechnungen)
sum(gregexpr(pattern, rechnungen)[[1]] > 0)


### e)

# Zunaechst eine Loesung, die noch nicht ganz perfekt funktioniert.
# Wir bauen uns ein Muster zusammen, das die geraden Zahlen von 10 bis 20
# verodert.
pattern <- paste(seq(10, 20, by = 2), collapse = "|")
pattern

gregexpr(pattern, rechnungen)[[1]] 
sum(gregexpr(pattern, rechnungen)[[1]] > 0)


# Beachte, dass hier auch die Zahl 121 durchrutscht! 
# Reparatur: Vor den gewuenschten Zahlen darf entweder keine Ziffer oder
# der Stringanfang stehen. Nach den gewuenschten Zahlen darf entweder
# keine Ziffer oder das Stringende stehen.

# Wuerden wir Stringanfang und Stringende nicht beruecksichtigen, so wuerde
# etwa die Zahl 10 nicht gefunden werden, wenn sie zu Beginn oder am Ende
# des Strings stehen wuerde. Beachte, dass wir korrekte Zeichengruppen
# bilden, damit es einwandfrei funktioniert.

# Wir redefinieren das Muster nach obigen Ueberlegungen.
pattern <- paste0("([^0-9]|^)", seq(10, 20, by = 2), "([^0-9]|$)",
  collapse = "|")
pattern

gregexpr(pattern, rechnungen)[[1]]
sum(gregexpr(pattern, rechnungen)[[1]] > 0)

# Jetzt wird nur noch die 10 gematcht!



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


### a)

# Beispielvektor
x <- c("mean(abs(y)) + 1", "pi")
x

# Idee: Wir bestimmen alle Stellen der schliessenden Klammern. Wir
# selektieren die letzte Klammer, indem wir die Indizes umdrehen und 
# jeweils das erste Element selektieren. Eine -1 besagt, dass es keine
# schliessende Klammer gibt.
ind.all <- gregexpr(")", x)
ind.all

ind.last <- sapply(lapply(ind.all, rev), "[", 1)
ind.last


### b)

# Beispielvektor
x <- c("Zwei Fische", "2 Fische", "Fische.")
x

# Eine Moeglichkeit: Wir matchen den Stringanfang und das Stringende.
# Dazwischen duerfen nur Buchstaben und Leerzeichen vorkommen.
bool <- grepl("^[a-zA-Z ]*$", x)
bool

# Verdichten auf den gesamten Vektor
all(bool)


### c)

# Beispielvektor
x <- c("Zwei FISCHE", "R-3.6.3", "Eins Zwei")
x

# Wir koennen die Frage leicht beantworten, indem wir zuerst abfragen, ob
# es einen Grossbuchstaben gibt, der *nicht* von einem Kleinbuchstaben
# gefolgt wird. Und dann den Wahrheitswert umdrehen.
bool <- !grepl("[A-Z][^a-z]", x)
bool

# Verdichten auf den gesamten Vektor
all(bool)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


namen <- c("Adam", "Ana", "Anna", "Annabelle", "Anna-Maria",
  "Anne", "Aurelia", "Elena", "Eugen", "Ida",
  "Freia", "Maaouiya", "Marie-Anne", "Otto", "Renee")
namen


### a)

# Variante 1: Ueber Suchmuster
# Das Muster lautet: Stringanfang, Selbstlaut, mindestens 0 beliebige
# Zeichen, Selbstlaut, Stringende
pattern <- "^[aeiou].*[aeiou]$"
grep(pattern, namen, ignore.case = TRUE, value = TRUE)


# Variante 2: Ueber substring()
# Wir extrahieren jeweils die ersten und letzten Buchstaben und pruefen,
# ob beide Zeichen Selbstlaute sind.
first <- substring(namen, 1, 1)
last <- substring(namen, nchar(namen))
first
last

namen[tolower(first) %in% c("a", "e", "i", "o", "u") &
      tolower(last)  %in% c("a", "e", "i", "o", "u")]


### b)

# Variante 1: Folgende Idee:
# 1.) Wir splitten die Namen in ihre einzelnen Zeichen auf.
# 2.) Wir bilden fuer jeden Eintrag eine Haeufigkeitstabelle der Zeichen.
# 3.) Wir selektieren die Tabelleneintraege, die Selbstlaute markieren.
# 4.) Wir bestimmen, wie viele Selbstlaute vorkommen.

# Schritt 1.)
namen.split <- strsplit(toupper(namen), split = "")
namen.split

# Schritt 2.)
tab.zeichen <- lapply(namen.split, table)
tab.zeichen

# Schritt 3.)
vokale <- c("A", "E", "I", "O", "U")
tab.vokal <- sapply(tab.zeichen, "[", vokale)
tab.vokal

rownames(tab.vokal) <- vokale
tab.vokal

# Schritt 4.)
# Ein Eintrag [i, j] in tab.vokal gibt an, wie oft Vokal i in Name j
# vorkommt. NA bedeutet: kommt nicht vor. Das heisst, die Anzahl der 
# unterscheidbaren Selbstlaute laesst sich einfach ueber die Anzahl der
# Nicht-NA-Eintraege bestimmen. Ist diese Zahl gleich 1, dann hat der
# entsprechende Name nur einen unterscheidbaren Selbstlaut.
colSums(!is.na(tab.vokal))
namen[colSums(!is.na(tab.vokal)) == 1]


# Variante 2: Aehnliche Idee, allerdings kleine Modifikation:
# 1.) Wir loeschen jeden Nichtselbstlaut heraus.
# 2.) Wir splitten die uebrig gebliebenen selbstlaute auf in die
#     einzelnen Zeichen.
# 3.) Wir entfernen mehrfach vorkommende Eintraege und erhalten Vektoren,
#     welche alle unterscheidbaren Selbstlaute enthalten. Wir brauchen nur
#     noch die Laenge bestimmen.

# Schritt 1.)
# Ersetze Nichtselbstlaute durch einen Leerstring
namen.vokale <- gsub("[^aeiou]", "", tolower(namen))
namen.vokale

# Schritt 2.)
namen.vokale.split <- strsplit(namen.vokale, split = "")
namen.vokale.split

# Schritt 3.)
lapply(namen.vokale.split, unique)
anz <- sapply(lapply(namen.vokale.split, unique), length)
anz

# anz enthaelt die Anzahl der unterscheidbaren Selbstlaute für jeden
# Namen. Die Selektion der gewuenschten Namen ist nur noch Formsache.
namen[anz == 1]


### c)

# Nach bzw. mit Hilfe von b) muehelos beantwortbar.

# Variante 1
namen[colSums(!is.na(tab.vokal)) >= 3]

# Variante 2
namen[anz >= 3]


### d)

# Variante 1: Mit Rueckreferenzen. Das Muster liest sich so:
# Stringanfang, beliebiges Zeichen (als 1. Gruppe markiert), mindestens
# 0 beliebige Zeichen, selbes Zeichen wie in 1. Gruppe, Stringende
# Beachte, dass ignore.case bei Rueckreferenzen keinen Effekt hat, daher
# tolower(namen) (oder toupper()).
bool <- grepl("^(.).*\\1$", tolower(namen))
namen[bool]


# Variante 2: Mit substring() extrahieren wir die ersten und letzten
# Buchstaben.
first <- substring(tolower(namen), 1, 1)
last <- substring(tolower(namen), nchar(namen))

namen[first == last]



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


wort <- c("Augenbraue", "Auto", "Baum", "Ei", "Eiertanz",
  "Feierlaune", "Igel", "Pfau")
wort


# Eine Moeglichkeit: Wir bestimmen zunaechst, welche Woerter mindestens
# 2 bzw. mindestens 3 Selbstlaute haben.
bool.2 <- grepl("[aeiou]{2}", wort, ignore.case = TRUE)
bool.3 <- grepl("[aeiou]{3}", wort, ignore.case = TRUE)

# Mit bool.2 bekommen wir alle Woerter mit *mindestens* 2
# aufeinanderfolgenden Selbstlauten.
wort[bool.2]

# Genau 2 aufeinanderfolgende Selbstlaute hat ein Wort, wenn es mindestens
# 2 aufeinanderfolgende Selbstlaute hat, aber keine Sequenz aus mindestens
# 3 Selbstlauten.
wort[bool.2 & !bool.3]



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


pattern.zahl <- "-?[0-9]+[.]?[0-9]+"
pattern.zahl


# Nach einem optionalen Minuszeichen muss mindestens eine Ziffer kommen.
# Anschliessend ein optionaler Dezimalpunkt und mindestens eine Ziffer.
# Damit werden folgende Zahlen *nicht* gefunden:
# .) einstellige ganze Zahlen (positive und negative)
# .) Zahlen der Form ".2", welche als "0.2" interpretiert werden.
# .) Zahlen der Form "2.", welche als "2.0" interpretiert werden.
# Vor allem die einstelligen Zahlen sind sehr ungut!


# Beispielzahlen
zahlen <- c("-7", ".2", "2.", "11", "-3.4", ".")
zahlen

# Anwendung des Suchmusters
grep(pattern.zahl, zahlen, value = TRUE)



### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


x.datum <- c("Heute -20%", "Samstag, der 04.01.2019",
  "Viele Meter laufen", "Er hat 20.25 Punkte.", "Kalte -4.5 Grad")
x.datum


# Die Idee: Wir selektieren alle Zahlen inkl. Datumswerte und setzen
# Datumswerte am Ende manuell auf NA.

# Das Suchmuster gestalten wir so, dass sowohl (Dezimal)zahlen als auch
# Datumswerte extrahiert werden.
pattern <- "-?[0-9]+([.]?[0-9]*){2}"
pattern

# Stellen des Vorkommens speichern
ind <- regexpr(pattern, x.datum)
ind

# Ergebnisse extrahieren
res <- rep(NA, length(x.datum))
res[ind > 0] <- regmatches(x.datum, ind)
res

# Datumswerte auf NA setzen. Eine einfache Regel, die in komplexeren Faellen
# nicht zutreffen muss: Wenn mehr als ein Punkt vorkommt, ist es keine Zahl.
bool.pkt2 <- sapply(lapply(gregexpr("[.]", res), ">", 0), sum) >= 2
bool.pkt2

# Datumswerte auf NA setzen
res[bool.pkt2] <- NA
res



### -----------------------------------------------------------------------
### Beispiel 7
### -----------------------------------------------------------------------


wettertext <- "Es ist 20.05 Uhr. Zeit für die Wettervorhersage.
  Morgen, am 9.01. hat es 5.5 Grad, am 10.01. sind es noch 3 °C.
  Der 11.1. kommt mit winterlichen -2.5 Grad und -1°C hat es am 12.1."

wettertext


### Schritt 1: Datumswerte extrahieren

# Suchmuster: Zwei Mal eine Zahl gefolgt von einem Punkt
datum.ind <- gregexpr("([0-9]+[.]){2}", wettertext)
datum.ind

datum <- regmatches(wettertext, datum.ind)[[1]]
datum


### Schritt 2: Gradangaben extrahieren

# Variante 1: Gradangaben inkl. Masseinheit extrahieren, Masseinheit
# anschliessend loeschen.

# Suchmuster: ggf. ein Minuszeichen, eine Zahl gefolgt von Grad oder °C.
# Vor Grad oder °C kann ein Leerzeichen stehen, muss aber nicht.
grad.ind <- gregexpr("-?[0-9]+([.][0-9]+)? *(°C|Grad)", wettertext)
grad.ind

grad <- regmatches(wettertext, grad.ind)[[1]]
grad

grad <- gsub(" *(°C|Grad)", "", grad)
grad


# Variante 2: Masseinheit als positiven Lookahead einsetzen

# Suchmuster: Wie in Variante 1, durch (?= *(°C|Grad)) wird die Masseinheit
# aber als Lookahead markiert. Dieses Muster muss also nach der Zahl folgen,
# wird aber von regmatches() nicht mitextrahiert.
grad.ind <- gregexpr("-?[0-9]+([.][0-9]+)?(?= *(°C|Grad))", wettertext,
  perl = TRUE)
grad.ind

grad <- regmatches(wettertext, grad.ind)[[1]]
grad


### Schritt 3: Dataframe zusammenbauen

grad <- as.numeric(grad)

wetter <- data.frame(Datum = datum, Temperatur = grad)
wetter



### -----------------------------------------------------------------------
### Beispiel 8
### -----------------------------------------------------------------------


### Daten laden

# Ggf. Arbeitsverzeichnis wechseln
# setwd(...)
objekte <- load("U2.RData")
objekte


### 3.)

# Eine U-Bahn erkennen wir an einem U gefolgt von einer Ziffer
pattern.ubahn <- "U[0-9]"

bool.ubahn <- grepl(pattern.ubahn, umstieg)
umstieg[bool.ubahn]
stationen[bool.ubahn]


### 4.)

# Variante 1: umstieg bei Beistrichen splitten und die Laengen der
# resultierenden Vektoren bestimmen.

umstieg.split <- strsplit(umstieg, ",")
umstieg.split

anz.linien <- sapply(umstieg.split, length)
names(anz.linien) <- stationen
anz.linien

# Sonderfall: Es haelt keine andere Linie an einer Station, dann wuerde
# ein Leerstring herauskommen, der Laenge 1 haette. Das muessen wir noch
# korrigieren. Ist zwar bei der U2 nicht der Fall, aber sicher ist besser.

# Bei Stationen ohne Umsteigemoeglichkeiten die Anzahl auf 0 setzen
bool <- umstieg == ""
anz.linien[bool] <- 0
anz.linien


# Variante 2: Wir zaehlen die Anzahl der Beistriche. Kommt zumindest ein
# Beistrich vor, so addieren wir eine 1 zur Anzahl der Beistriche hinzu,
# um die Anzahl der Linien zu erhalten. Kommt kein Beistrich vor, so kann
# an der Station entweder keine Linie oder genau eine Linie halten.

# Beistiche zaehlen
ind.beistrich <- gregexpr(",", umstieg)
ind.beistrich

anz.beistrich <- sapply(lapply(ind.beistrich, ">", 0), sum)
anz.beistrich

# Anzahl der Linien bestimmen
anz.linien <- anz.beistrich
names(anz.linien) <- stationen

# Dort, wo mind. ein Beistrich vorkommt, die Anzahl hochzaehlen
bool.g0 <- anz.beistrich > 0
anz.linien[bool.g0] <- anz.linien[bool.g0] + 1

# Dort, wo kein Beistrich vorkommt, zaehlen wir die Anzahl dann hoch, wenn
# an den entsprechenden Stellen in umstieg kein Leerstring vorkommt (und
# somit eine Linie dort haelt).
anz.linien[!bool.g0] <- anz.linien[!bool.g0] + (umstieg[!bool.g0] != "")
anz.linien


### 5.)

# Variante 1: Via umstieg.split

# Zunaechst in umstieg.split auf Gleichheit mit 2 pruefen ...
umstieg.split
lapply(umstieg.split, "==", 2)

# ... und bestimmen, ob eine "2" vorkommt
bool2 <- sapply(lapply(umstieg.split, "==", 2), any)
bool2

umstieg[bool2]
stationen[bool2]


# Variante 2: Via Suchmuster

# Diese Variante ist relativ tricky. Wir betrachten zunaechst einige 
# noch nicht korrekt funktionierenden Loesungsvorschlaege.

# Fail Nummer 1: Wenn wir nur das Muster "2" suchen, so rutscht zu viel
# mit durch (zum Beispiel 25, 82A).
# Das Muster "2" ist also zu lose.
bool <- grepl("2", umstieg)
umstieg[bool]

# Fail Nummer 2: Wenn wir festschreiben, dass "2" nicht von einer Zahl
# oder einem Buchstaben gefolgt werden darf und vor der "2" ebenso keine
# Zahl stehen darf, dann rutschen zwar keine falschen Linien durch, aber
# gleichzeitig finden wir die Linie 2 beim Rathaus und bei der Taborstrasse
# *nicht*.
# Das Muster "[^0-9]2[^0-9AB]" ist also zu streng. 
bool <- grepl("[^0-9]2[^0-9AB]", umstieg)
umstieg[bool]


# Jetzt zur korrekten Loesung! Wir unterscheiden mehrere Faelle: Die Linie
# 2 kann entweder die einzige Linie sein (Fall 1) oder nicht (Fall 2). Im
# zweiten Fall kann sie entweder zu Beginn (Fall 2a), in der Mitte (Fall 2b)
# oder am Ende (Fall 3c) stehen. Die Faelle im Ueberblick:
# Fall 1:  Die Linie 2 ist die einzige Linie. In dem Fall wird die "2" vom
#          Stringanfang und Stringende eingeschlossen.
#          Suchmuster: "^2$"
# Fall 2a: Die Linie 2 ist nicht die einzige Linie und steht zu Beginn.
#          In dem Fall wird "2" vom Stringanfang und von einem Beistrich
#          eingeschlossen.
#          Suchmuster: "^2,"
# Fall 2b: Die Linie 2 ist nicht die einzige Linie und steht in der Mitte.
#          In dem Fall wird sie von zwei Beistrichen eingeschlossen.
#          Suchmuster: ",2,"
# Fall 3c: Die Linie 2 ist nicht die einzige Linie und steht am Ende.
#          In dem Fall wird sie von einem Beistrich und dem Stringende
#          umschlossen.
#          Suchmuster: ",2$"

# Wir verodern diese 4 Faelle.
pattern2 <- "^2$|^2,|,2,|,2$"
pattern2

bool <- grepl(pattern2, umstieg)
umstieg[bool]
stationen[bool]

# Jetzt haben wir es geschafft :-)


### 6.)

# Anmerkung: Bim ist Wienerisch fuer Strassenbahn

# Eine Variante von vielen moeglichen: Wir gehen von umstieg.split aus
# und bestimmen, welche Linien *keine* Strassenbahnlinien sind (also 
# U-Bahn, Autobus oder WLB) und bestimmen die entsprechenden Anzahlen
# pro Station. Dann bilden wir die Differenz der Anzahlen aller Linien
# und die Anzahlen der Nicht-Strassenbahnlinien.

# Suchmuster fuer U-Bahn, Autobus oder WLB zusammenbauen
pattern.ubahn <- "U[0-9]"
pattern.bus <- "[0-9]+[AB]"
pattern.wlb <- "WLB"
pattern.nicht.bim <- paste(pattern.ubahn, pattern.bus, pattern.wlb,
  sep = "|")
pattern.nicht.bim

# Anzahl der Nicht-Strassenbahnlinien zaehlen
bool.nicht.bim <- lapply(umstieg.split, grepl, pattern = pattern.nicht.bim)
anz.nicht.bim <- sapply(bool.nicht.bim, sum)
anz.nicht.bim

# Differenz bilden
anz.bim <- anz.linien - anz.nicht.bim
anz.bim


# Variante 2: Via Suchmuster

# Analoges Suchmuster wie in Variante 2 aus 5.) nur mit "([0-9]+|[A-Z])"
# statt "2" und die Beistriche muessen als Lookaheads bzw. Lookbehinds
# definiert werden, um eine ueberlappende Suche zu ermoeglichen, damit
# Beistriche mehrfach gematcht werden koennen.

pattern2 <- "^2$|^2(?=,)|(?<=,)2(?=,)|(?<=,)2$"
pattern2

# Ersezen alle Vorkommen von "2" durch "([0-9]+|[A-Z])"
pattern.bim <- gsub("2", "([0-9]+|[A-Z])", pattern2)
pattern.bim

# Jetzt bestimmen wir mit gregexpr() die Stellen
ind.bim <- gregexpr(pattern.bim, umstieg, perl = TRUE)
ind.bim

anz.bim <- sapply(lapply(ind.bim, ">", 0), sum)
names(anz.bim) <- stationen
anz.bim


### 7.)

bimlinien <- unlist(regmatches(umstieg, ind.bim))
bimlinien

# Mehrfacheintraege streichen
bimlinien.unique = unique(bimlinien)
bimlinien.unique

length(bimlinien.unique)



### -----------------------------------------------------------------------
### Beispiel 9
### -----------------------------------------------------------------------


### a) 

# Falsch! Das Suchmuster selektiert jene Elemente, die mindestens zwei a
# enthalten.
x <- c("aa", "aba", "abaa", "ab")
grep("a[^a]*a", x, value = TRUE)


### b)

# Richtig! Denn das Suchmuster besteht aus 5 beliebigen Zeichen zu Beginn
# Strings. Jeder String mit mindestens 5 Zeichen erfuellt dieses Muster.
x <- c("abc", "abcd", "abcde", "abcdef")
grepl("^.{5}", x)
nchar(x) >= 5


### c)

# Nein, nicht ganz richtig! Denn besteht ein String nur aus einem kleinen
# Selbstlaut (endet somit automatisch auf selbigem), so wird dieser String
# durch das Voranstellen von ".+" nicht gefunden.
x <- c("a", "ba", "ab")
grepl(".+[aeiou]$", x)


### d)

# Falsch! Denn der Punkt kann fuer jeden Selbstlaut stehen.
x <- c("aba", "aea", "abbae")
grepl("[aeiou](.*\\1)*", tolower(x))


### e)

# Richtig! Denn eine Ueberlappung kann nur dann passieren, wenn sich Zeichen
# ueberschneiden.



### -----------------------------------------------------------------------
### Beispiel 10
### -----------------------------------------------------------------------


### Gene erzeugen
n <- 10
k <- 100
basen <- c("A", "C", "T", "G")

set.seed(234957)
temp <- sample(basen, size = n * k, replace = TRUE)
M <- matrix(temp, nrow = n, ncol = k)
M

gene <- apply(M, 1, paste0, collapse = "")
gene


### a)

# Beim Muster "ACT" kann es keine Ueberlappungen geben, da alle Zeichen
# unterschiedlich sind.
pattern <- "ACT"
sapply(lapply(gregexpr(pattern, gene), ">=", 0), sum)


### b)

# Beim Muster "TAT" kann es Ueberlappungen geben, da sich die T
# ueberschneiden koennen. Daher definieren wir das letzte T als
# Lookahead.
pattern <- "TA(?=T)"
sapply(lapply(gregexpr(pattern, gene, perl = TRUE), ">=", 0), sum)


### c)

# Zerlege die gene in die einzelnen Basen
gene.split <- strsplit(gene, split = "")
gene.split

# Eine n x 4 Matrix bietet sich an. Jede Spalte steht fuer eine Base.
# Wenn wir sichergehen koennen, dass jede Base in jedem Gen zumindest
# ein Mal vorkommt, dann funktioniert schon folgender Code:
t(sapply(gene.split, table))

# Das Problem: Kommt zumindest in einem Gen nicht jede Base vor, dann 
# entsteht eine unuebersichtliche Liste.

# Daher ist es sicherer, die Anzahl fuer jede Base einzeln zu bestimmen.
anzA <- colSums(sapply(gene.split, "==", "A"))
anzC <- colSums(sapply(gene.split, "==", "C"))
anzT <- colSums(sapply(gene.split, "==", "T"))
anzG <- colSums(sapply(gene.split, "==", "G"))

tab <- cbind(anzA, anzC, anzT, anzG)
colnames(tab) <- basen
tab

# Spaeter lernen wir Schleifen kennen, mit denen wir obigen Code kuerzer
# aufschreiben koennen:
tab <- matrix(0, nrow = n, ncol = 4)
colnames(tab) <- basen
tab

for (b in basen) {
  tab[, b] <- colSums(sapply(gene.split, "==", b))
}

tab


### d)

# Es gibt viele Loesungsvarianten. Und einige von ihnen koennen mit
# Techniken, die wir spaeter noch lernen, veredeln. Vor allem Schleifen
# tragen zur Veredelung bei.

# Eine Moeglichkeit: Wir erfragen fuer jede der vier Basen, ob nach der
# entsprechenden Base mindestens vier Mal eine andere Base kommt.
patternA <- "A[^A]{4,}"
patternC <- "C[^C]{4,}"
patternT <- "T[^T]{4,}"
patternG <- "G[^G]{4,}"

anzA <- sapply(lapply(gregexpr(patternA, gene), ">", 0), sum)
anzC <- sapply(lapply(gregexpr(patternC, gene), ">", 0), sum)
anzT <- sapply(lapply(gregexpr(patternT, gene), ">", 0), sum)
anzG <- sapply(lapply(gregexpr(patternG, gene), ">", 0), sum)

anzA + anzC + anzT + anzG

