### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 22: Textmanipulation: Stringfunktionen
### -------------------------------------------------------------------------


# Die Daten dieses Kapitels
# Ggf. Arbeitsverzeichnis wechseln oder Pfad angeben
objekte <- load("Pizza.RData")
objekte

pizza

pizza.liste   # Ziel: Beschriftete Liste mit den Zutaten

preise        # Ziel: Die Preise der Pizzen als Zahlen



### -------------------------------------------------------------------------
### 22.1  Simple Stringfunktionen -- nchar(), tolower(), toupper()
### -------------------------------------------------------------------------


# Vektor mit unschön geschriebenen Pizzanamen
namen <- c("MArgherita", "valentino", "CARDINALE", "Provinciale")

# Generelle Gross- und Kleinschreibung
namen.upper <- toupper(namen)   # in Grossbuchstaben umwandeln
namen.lower <- tolower(namen)   # in Kleinbuchstaben umwandeln

namen.upper
namen.lower


namen.lower

# Länge der Namen bestimmen = Anzahl der Zeichen zählen
namen.nchar <- nchar(namen.lower)
namen.nchar

# Alle längsten Namen extrahieren
namen.lower[namen.nchar == max(namen.nchar)]

# Namen eindeutig abkürzen
abbreviate(namen.lower, minlength = 4)



### -------------------------------------------------------------------------
### 22.2  Nach Mustern in Texten suchen
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 22.2.1  Elemente des Vektors finden -- grepl(), grep()


# Wie viele Pizzen enthalten Mais?
pizza

# Möglichkeit 1: mit grepl() - liefert TRUE/FALSE-Vektor
bool.mais <- grepl(pattern = "Mais", x = pizza)
bool.mais
sum(bool.mais)

# Möglichkeit 2: mit grep() - liefert Vektor mit Indizes
ind.mais <- grep(pattern = "Mais", x = pizza)
ind.mais
length(ind.mais)


# Pizzen selektieren, die Mais enthalten bzw. keinen Mais enthalten
grep(pattern = "Mais", x = pizza, value = TRUE)
grep(pattern = "Mais", x = pizza, value = TRUE, invert = TRUE)


# Welche Pizzen enthalten keinen Schinken?
pizza

!grepl("Schinken", pizza)
grep("Schinken", pizza, value = TRUE, invert = TRUE)

	
bool <- grepl(pattern = "schinken", x = tolower(pizza))
bool
	
bool <- grepl(pattern = "Schinken", x = pizza) |
        grepl(pattern = "schinken", x = pizza)
bool
				
bool <- grepl(pattern = "Schinken", x = pizza, ignore.case = TRUE)
bool

pizza[!bool]


### -------------------------------------------------------------------------
### 22.2.2  Stellen in Texten finden -- regexpr(), gregexpr()


pizza

# Stelle des ersten Auftretens von Schinken
ind.schinken <- regexpr(pattern = "Schinken", text = pizza)
ind.schinken


grepl("Schinken", pizza)
regexpr("Schinken", pizza) > 0  # Nachbau von grepl()


pizza

# Die Stellen aller Beistriche
stellen.beistrich <- gregexpr(",", pizza)
head(stellen.beistrich, n = 2)


### -------------------------------------------------------------------------
### 22.2.3  Anzahl der Übereinstimmungen zählen


sapply(stellen.beistrich, length)


gregexpr(",", "Text ohne Beistrich")

sapply(gregexpr(",", "Text ohne Beistrich"), length)


temp <- lapply(stellen.beistrich, ">", 0)
temp

# Wie viele Beistriche pro Eintrag?
sapply(temp, sum)

# Wie viele Beistriche insgesamt?
sum(unlist(stellen.beistrich) > 0)



### -------------------------------------------------------------------------
### 22.3  Extraktion von Teilen aus Zeichenketten -- substring()
### -------------------------------------------------------------------------


# Die ersten fünf Zeichen
substring(pizza, 1, 5)

# Vektorwertige Anwendung
substring(pizza, 1, 2:5)


# 1.) Stelle des ersten Doppelpunktes finden
stelle.doppelpunkt <- regexpr(pattern = ":", pizza)
stelle.doppelpunkt

pizza

all(stelle.doppelpunkt > 0)
range(stelle.doppelpunkt)


# 2.) Teilbereich bis exklusive des ersten Doppelpunktes extrahieren
substring(pizza, first = 1, last = stelle.doppelpunkt)
namen <- substring(pizza, first = 1, last = stelle.doppelpunkt - 1)
namen


# 3.) Namen richtig schreiben
namen.anfang <- toupper(substring(namen, 1, 1))
namen.rest <- tolower(substring(namen, 2, nchar(namen)))

namen.anfang   # 1. Zeichen gross
namen.rest     # Rest klein

namen <- paste0(namen.anfang, namen.rest)
namen


regexpr(pattern = ".", pizza)



### -------------------------------------------------------------------------
### 22.4  Sonderzeichen mit besonderen Fähigkeiten -- [ ], "\\"
### -------------------------------------------------------------------------


# Explizite Suche nach dem Punkt
stelle.punkt <- regexpr("\\.", pizza)  # doppelten Backslash voranstellen
stelle.punkt <- regexpr("[.]", pizza)  # in eckige Klammern setzen
stelle.punkt

substring(pizza, stelle.punkt)

# Hoppala, 2 Zeichen zu Beginn zu viel ...
substring(pizza, stelle.punkt + 2)

# ... und Euro wollen wir am Ende auch nicht haben.
preise <- substring(pizza, stelle.punkt + 2, nchar(pizza) - nchar(" Euro"))
preise


# Extrahiere das erste Vorkommen einer Dezimalzahl
regmatches(pizza, regexpr("[0-9]+,[0-9]+", pizza))



### -------------------------------------------------------------------------
### 22.5  Ersetzungen in Zeichenketten -- sub(), gsub()
### -------------------------------------------------------------------------


# Erstes A durch X ersetzen
sub("A", "X", x = "ABCABC")

# Alle A durch X ersetzen
gsub("A", "X", x = "ABCABC")


preise
as.numeric(preise)

preise <- sub(pattern = ",", replacement = ".", preise)
preise <- as.numeric(preise)
preise


sub(pattern = ",", replacement = "[.]", x = "5,9")


# Zwischenstand
namen
preise


pizza

# 1.) Teilstring zwischen Doppelpunkt und Punkt extrahieren
zutaten <- substring(pizza, stelle.doppelpunkt + 1, stelle.punkt - 1)
zutaten

# 2.) Alle Leerzeichen löschen
zutaten <- gsub(pattern = " ", replacement = "", zutaten)
zutaten



### -------------------------------------------------------------------------
### 22.6  Zerlegung von Zeichenketten -- strsplit()
### -------------------------------------------------------------------------


zutaten

# Bei jedem Komma splitten
pizza.liste <- strsplit(zutaten, split = ",")
pizza.liste

# Beschriftungen hinzufügen
names(pizza.liste) <- namen
pizza.liste



### -------------------------------------------------------------------------
### 22.8  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 22.8.1  Objekte sichern


# Daten sichern
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
save(pizza, namen, zutaten, preise, pizza.liste, file = "Pizza.RData")


### -------------------------------------------------------------------------
### 22.8.4  Übungen


text <- c("R ist super. Mit R kann ich so viele tolle Dinge tun.",
          "Zeichenketten aufsplitten ist ein Beispiel.",
          "Vektoren umdrehen und das erste Element selektieren.")


dateien <- c("Version_2.1.txt", "Liste_2019.08.01.xlsx", "Run.R")
