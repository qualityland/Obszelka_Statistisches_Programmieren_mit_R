### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 23: Komplexe Textsuchmuster: Regular Expressions
### -------------------------------------------------------------------------


namen <- c("Adam", "Ana", "Anna", "Annabelle", "Anna-Maria",
           "Anne", "Aurelia", "Elena", "Eugen", "Ida",
           "Freia", "Maaouiya", "Marie-Anne", "Otto", "Renee")
namen



### -------------------------------------------------------------------------
### 23.1  Sonderzeichen und Escape-Befehle -- ?regex, [ ], \\, \n, \"
### -------------------------------------------------------------------------


# Explizite Suche nach dem (ersten) Punkt
index.p <- regexpr(pattern = "\\.", "R 4.0.2")  # doppelter Backslash
index.p <- regexpr(pattern = "[.]", "R 4.0.2")  # mit eckigen Klammern

index.p


# Anführungszeichen in Strings
"Hugo "Nimmersatt" Mustermann
"Hugo \"Nimmersatt\" Mustermann"

# Text auf die Console drucken
cat("Hugo \"Nimmersatt\" Mustermann\n")


# 1.) Escapebefehle und Backslashes
text <- c("Der Escapebefehl \\n beginnt eine neue Zeile.",
          "Der Escapebefehl \n beginnt eine neue Zeile.")
grepl("\n", text)     # Kommt der Escape-Befehl \n vor?
grepl("\\\\n", text)  # Kommt die Zeichenkette \n vor?

text.collapse <- paste0(text, "\n", collapse = "")
cat(text.collapse)    # für \n wird neue Zeile eingefügt, für \\n nicht.


# 2.) Stelle des ersten Potenzzeichens suchen
rechnung <- "3 + 2 ^ 4 - 1 = 18"
rechnung

regexpr("[^]", rechnung)  # Potenzzeichen suchen - so nicht!
regexpr("\^", rechnung)  # Potenzzeichen suchen - so geht's!



### -------------------------------------------------------------------------
### 23.2  Zeichenmengen und flexible Suchmuster definieren
### -------------------------------------------------------------------------


namen

# Alle Namen, die ein grosses A enthalten
grep("A", namen, value = TRUE)

# Alle Namen, die Anne enthalten
grep("Anne", namen, value = TRUE)


### -------------------------------------------------------------------------
### 23.2.1  Beliebiges Zeichen -- "."


# Alle Namen mit A gefolgt von beliebigem Zeichen gefolgt von a
grep("A.a", namen, value = TRUE)


### -------------------------------------------------------------------------
### 23.2.2  Zeichen ein- und ausschliessen -- [ ], [^ ]


# Suche nach Ann gefolgt von einem a oder e
grep("Ann[ae]", namen, value = TRUE)

# Grosser Selbstlaut gefolgt von beliebigem Zeichen gefolgt von a
grep("[AEIOU].a", namen, value = TRUE)

# Grosser Selbstlaut gefolgt von einem Zeichen ausser d gefolgt von a
grep("[AEIOU][^d]a", namen, value = TRUE)


# Selbstlaute zählen
anz.vokal <- gregexpr("[aeiou]", namen, ignore.case = TRUE)
sapply(lapply(anz.vokal, ">", 0), sum)

head(namen, 5)

# Selbstlaute zählen: Alternative
temp1 <- strsplit(tolower(namen), "")
temp2 <- lapply(temp1, "%in%", c("a", "e", "i", "o", "u"))
sapply(temp2, sum)

# Nicht-Selbstlaute zählen
anz <- gregexpr("[^aeiou]", namen, ignore.case = TRUE)
sapply(lapply(anz, ">", 0), sum)
head(namen, n = 5)


### -------------------------------------------------------------------------
### 23.2.3  Zeichenbereiche definieren -- [A-Z], [a-z], [0-9]


# Suchmuster für alle Grossbuchstaben zusammenbauen
paste0("[", paste0(LETTERS, collapse = ""), "]")

# Haben alle Namen (mindestens) einen Grossbuchstaben?
all(grepl("[A-Z]", namen))


# An welchen Stellen stehen Ziffern größer oder gleich 3?
rechnung
gregexpr("[3-9]", rechnung)[[1]]  # [[1]], weil nur eine Komponente



### -------------------------------------------------------------------------
### 23.3  Matchlänge steuern
### -------------------------------------------------------------------------


# Welche Namen haben 3 aufeinanderfolgende Vokale?
grep("[aeiou][aeiou][aeiou]", namen, ignore.case = TRUE, value = TRUE)


### -------------------------------------------------------------------------
### 23.3.1  Matchlängenoperatoren und Kürzel -- { }, +, *, ?


grep("An{1,2}a", namen, value = TRUE)
grep("Ann?a", namen, value = TRUE)


# Mindestens zwei aufeinanderfolgende Vokale?
grep("[aeiou]{2,}", namen, ignore.case = TRUE, value = TRUE)

# Alternativen, die zum selben Ergebnis führen
grep("[aeiou][aeiou]+", namen, ignore.case = TRUE, value = TRUE)
grep("[aeiou][aeiou][aeiou]*", namen, ignore.case = TRUE, value = TRUE)
grep("[aeiou]{2}", namen, ignore.case = TRUE, value = TRUE)


### -------------------------------------------------------------------------
### 23.3.2  Greedy Matching unterbinden -- ?


text <- "x--x--x--x"
text

# Greedy Matching (default)
regexpr("x.+x", text)

# Greedy Matching abschalten
regexpr("x.+?x", text)



### -------------------------------------------------------------------------
### 23.4  Teilstrings extrahieren -- regmatches()
### -------------------------------------------------------------------------


x <- c("Heute -20%", "Er hat 20.25 Punkte.", "Viele Meter laufen",
  "Kalte -4.5 Grad")
x

# Suchmuster für Zahlen definieren
pattern.zahl <- "-?[0-9]+[.]?[0-9]*"

stelle.zahl <- regexpr(pattern.zahl, x)   # Suche Positionen der Zahlen

res.zahl <- regmatches(x, stelle.zahl)    # Extrahiere die Zahlen
res.zahl
# Jene Stellen mit NA markieren, in denen das Suchmuster nicht vorkommt
res.zahl.na <- rep(NA, length(x))
res.zahl.na[stelle.zahl > 0] <- res.zahl
res.zahl.na


x.datum <- c("Heute -20%", "Samstag, der 04.01.2019", "Viele Meter laufen",
       "Er hat 20.25 Punkte.", "Kalte -4.5 Grad")

# Zahlen ohne Datumswerte extrahieren - Fehlschlag Nummer 1
stelle.zahl <- regexpr(pattern.zahl, x.datum)
regmatches(x.datum, stelle.zahl)

# Zahlen ohne Datumswerte extrahieren - Fehlschlag Nummer 2
stelle.zahl <- regexpr("-?[0-9]+[.]?[0-9]*[^.]", x.datum)
regmatches(x.datum, stelle.zahl)
x

stellen.zahl <- gregexpr(pattern.zahl, x)
regmatches(x, stellen.zahl)



### -------------------------------------------------------------------------
### 23.5  Nützliche Tools zum Ersten
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 23.5.1  Zeichengruppen definieren -- ( )


# Ist das weder Fisch noch Fleisch?
x <- c("Fisch", "Fleisch")
grep("F(le)?isch", x, value = TRUE)


# Welche Namen enthalten zwei Mal in Folge einen Selbstlaut gefolgt von
# einem Mitlaut?
grep("([aeiou][bcdfghjklmnpqrstvwxyz]){2}", namen, ignore.case = TRUE,
  value = TRUE)


# Fisch und Fleisch ausschliessen! - so nicht!
grep("^(F(le)?isch)", c("Fisch", "Fleisch"), value = TRUE)


### -------------------------------------------------------------------------
### 23.5.2  Zeichen und Zeichengruppen verodern -- |


x

# Fisch oder Fleisch?
x[grepl("Fisch", x) | grepl("Fleisch", x)]

grep("Fisch|Fleisch", x, val = TRUE)
grep("F(le|)isch", x, val = TRUE)


# 1.) Welche Namen enthalten denselben Selbstlaut zwei Mal in Folge?
selbstlaute <- c("a", "e", "i", "o", "u")
pattern <- paste(selbstlaute, selbstlaute, sep = "", collapse = "|")
grep(pattern, namen, ignore.case = TRUE, value = TRUE)

# 2.) Welche Namen enthalten einen Doppelbuchstaben?
pattern <- paste(letters, letters, sep = "", collapse = "|")
grep(pattern, namen, ignore.case = TRUE, value = TRUE)


### -------------------------------------------------------------------------
### 23.5.3  Stringanfang und Stringende -- "^", "$"


# Welche Namen enthalten ein grosses A?
grep("A", namen, value = TRUE)

# Welche Namen fangen mit einem grossen A an?
grep("^A", namen, value = TRUE)

# Welche Namen fangen nicht mit einem Selbstlaut an?
grep("^[^AEIOU]", namen, value = TRUE)

# Welche Namen enden nicht auf einem Selbstlaut?
grep("[^aeiou]$", namen, value = TRUE)


# Welche Namen haben genau zwei aufeinanderfolgende Selbstlaute?

# Die Suchmuster zu den vier Fällen
pattern1 <- "[^aeiou][aeiou]{2}[^aeiou]"
pattern2 <- "^[aeiou]{2}[^aeiou]"
pattern3 <- "[^aeiou][aeiou]{2}$"
pattern4 <- "^[aeiou]{2}$"

# Veroderung der vier Suchmuster
pattern <- paste(pattern1, pattern2, pattern3, pattern4, sep = "|")

# Namen extrahieren
grep(pattern, namen, ignore.case = TRUE, value = TRUE)


### -------------------------------------------------------------------------
### 23.5.4  Strings trimmen und White Space -- [:space:]


# Beispieltext mit Leerzeichen und Rufzeichen
text <- c("  Hugo lacht! ", " Haha! Haha!   ")
text

# Alle Leerzeichen löschen
gsub(" ", "", text)

# Leerzeichen am Rand löschen
gsub("^ *| *$", "", text)

# White Space zu Beginn und am Ende löschen
gsub("^[[:space:]]*|[[:space:]]*$", "", text)

# White Space und Rufzeichen zu Beginn und am Ende löschen
gsub("^[[:space:]!]*|[[:space:]!]*$", "", text)



### -------------------------------------------------------------------------
### 23.6  Nützliche Tools zum Zweiten
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 23.6.1  Vorherige Zeichengruppe erneut matchen -- \\k


x <- c("Haha", "haha", "hiha", "hihi", "Aha")
x

# Selektiere all jene Lacher, die aus exakt denselben Silben bestehen
grep("([Hh])([ai])\\1\\2", x, value = TRUE)

grep("ha\\1\\2", x, value = TRUE)      # Bei Zeichen keine Rückreferenz!
grep("(h)(a)\\1\\2", x, value = TRUE)  # Muss Zeichen in Gruppe stecken!


x

# Verdopple alle Selbstlaute
gsub("([aeiou])", "\\1\\1", x, ignore.case = TRUE)
gsub("([aeiou])", "\\1\\1", x, ignore.case = FALSE)

# 1. und 3. Buchstabe gleich - So nicht!
grep("^([a-z]).\\1", namen, ignore.case = TRUE, value = TRUE)

# 1. und 3. Buchstabe gleich - So schon!       # Kleinschreibweise
grep("^([a-z]).\\1", tolower(namen), value = TRUE)
namen[grepl("^([a-z]).\\1", tolower(namen))]   # Originalschreibweise


### -------------------------------------------------------------------------
### 23.6.2  Bedingte Extraktion: Lookaheads und Lookbehinds -- perl, (?= ),
###         (?! ), (?<= ), (?<! )


masse <- c("50 g", "30 kg", "7kg", "50 km", "27cm")
masse


# 1. Variante
# Alle Zahlen extrahieren, die von g oder kg gefolgt werden
temp <- regmatches(masse, regexpr("[0-9]+ *(g|kg)", masse))
temp
# Alle g und kg löschen
gsub(" *(g|kg)", "", temp)

# 2. Variante: Lookaheads nehmen
temp <- regexpr("[0-9]+(?= *(g|kg))", masse, perl = TRUE)
temp

regmatches(masse, temp)


# Extrahiere alle Zahlen, die keine cm beschreiben - so noch nicht!
regmatches(masse, regexpr("[0-9]+(?! *(cm))", masse, perl = TRUE))

# Extrahiere alle Zahlen, die keine cm beschreiben - so geht es!
regmatches(masse, regexpr("[0-9]+(?![0-9]* *(cm))", masse, perl = TRUE))


### -------------------------------------------------------------------------
### 23.6.3  Überlappende Suche -- perl, (?= )


x <- "ababa"
x

# Nicht überlappende Suche
gregexpr("aba", x)


x <- "ababa"
x

# Überlappende Suche
gregexpr("a(?=ba)", x, perl = TRUE)


# Anzahl des Musters "Selbstlaut, kein Selbstlaut, Selbstlaut"

# 1.) Ohne Überlappungen
temp1 <- gregexpr("[aeiou][^aeiou][aeiou]", namen, ignore.case = TRUE)
res1 <- sapply(lapply(temp1, ">", 0), sum)
res1

# 2.) Mit Überlappungen (Lookahead)
temp2 <- gregexpr("[aeiou](?=[^aeiou][aeiou])", namen, ignore.case = TRUE,
  perl = TRUE)
res2 <- sapply(lapply(temp2, ">", 0), sum)
res2

namen[res1 != res2]



### -------------------------------------------------------------------------
### 23.7  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 23.7.1  Fallbeispiel: Stationsansagen der Wiener Linien


# Ggf. Arbeitsverzeichnis wechseln
# setwd(...)
objekte <- load("U2.RData")
objekte

head(ansagen, n = 6)
head(stationen, n = 6)
head(umstieg, n = 6)


# 1.) Bei welchen Stationen können wir zu keinem Autobus umsteigen?
pattern.bus <- "[0-9]+[AB]"
stationen[!grepl(pattern.bus, umstieg)]


# 2.) In wie viele Autobuslinien können wir bei jeder Station umsteigen?
stellen.bus <- gregexpr(pattern.bus, umstieg)
temp <- lapply(stellen.bus, ">", 0)
sapply(temp, sum)

# Alternative: Erstelle eine beschriftete Liste
umstieg.liste <- strsplit(umstieg, " *, *")  # Nach Komma trennen
names(umstieg.liste) <- stationen            # Liste beschriften
head(umstieg.liste, n = 4)

# Die Autobuslinien in jeder Listenkomponente extrahieren
temp <- sapply(umstieg.liste, grep, pattern = pattern.bus, value = TRUE)
head(temp, n = 4)

# Länge jeder Komponente bestimmen
anz.bus <- sapply(temp, length)
head(anz.bus, n = 4)



### -------------------------------------------------------------------------
### 23.8  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 23.8.3  Übungen


rechnungen <- c("9 + 10 = 19, 2 - 5 = -3,11^2 = 121, 8-7=1")


wort <- c("Augenbraue", "Auto", "Baum", "Ei", "Eiertanz",
          "Feierlaune", "Igel", "Pfau")


x.datum <- c("Heute -20%", "Samstag, der 04.01.2019",
    "Viele Meter laufen", "Er hat 20.25 Punkte.", "Kalte -4.5 Grad")


wettertext <- "Es ist 20.05 Uhr. Zeit für die Wettervorhersage.
   Morgen, am 9.01. hat es 5.5 Grad, am 10.01. sind es noch 3 °C.
   Der 11.1. kommt mit winterlichen -2.5 Grad und -1°C hat es am 12.1."
