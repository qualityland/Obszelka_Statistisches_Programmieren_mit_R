### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 27
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


geb.posix <- as.POSIXct("1986-07-07 07:22:00 CET")
geb.posix

# Mit format() (generisch) und den richtigen Platzhaltern kein Problem.
format(geb.posix, format = "%d. %B %Y um %H:%M Uhr")



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


str1 <- "13 Uhr am 7. Jänner 2019"
str2 <- "32. Tag des Jahres 2019 um 15:30 Uhr"


### a)

# Beide Strings sind in unterschiedlichen Formaten gegeben, daher brauchen
# wir fuer beide ein eigenes Format.
str.POSIXct <- c(
  as.POSIXct(str1, format = "%H Uhr am %d. %B %Y"),
  as.POSIXct(str2, format = "%j. Tag des Jahres %Y um %H:%M Uhr")
)

str.POSIXct

# Hinweis: Falls "Jänner" nicht korrekt angezeigt wird oder die Locale
# January oder Januar etc. erwartet, so koennen wir mit gsub() eine 
# Ersetzung vornehmen. Zum Beispiel:
# str1 <- gsub("Jänner", "January", str1)
# str1 <- gsub("J.{1,2}nner", "January", str1)


### b)

# Zwei Varianten
weekdays(str.POSIXct)
format(str.POSIXct, "%A")


### c)

# Bei difftime koennen wir die units einstellen
diff.weeks <- difftime(str.POSIXct[2], str.POSIXct[1], units = "weeks")
diff.weeks

# Ganze Wochen bestimmen
floor(diff.weeks)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


# Die Geburtstage von Peter und Herbert sind schnell erstellt.
peter <- as.Date("1989-01-20")
herbert <- peter + 7  # eine Woche = 7 Tage

# Bei Lisa muessen wir rechnen. Eine Moeglichkeit:
# 1.) Wir erstellen von Peter den Geburtstag im Jahr 2015.
# 2.) Wir erstellen einen Vektor mit den 7 darauf folgenden Tagen.
# 3.) Aus diesen Tagen suchen wir uns den Freitag heraus.
# 4.) Wir erstellen das Geburtsdatum von Lisa.

# 1.)

peter.2015 <- as.Date("2015-01-20")

# Bzw. automatisiert aus dem Objekt peter
peter.2015 <- as.Date(format(peter, "2015-%m-%d"))
peter.2015

# 2.)

lisa.kandidaten <- peter.2015 + 1:7
lisa.kandidaten

# 3.) Freitag herausfischen

# Freitag ist der 5. Tag der Woche
bool.freitag <- format(lisa.kandidaten, "%u") == "5"
lisa.2015 <- lisa.kandidaten[bool.freitag]
lisa.2015

# Nicht empfohlen: Abfrage auf Gleichheit via weekdays() und "Freitag".
# Grund: Das ist nicht unabhaengig von den Locales.
bool.freitag <- weekdays(lisa.kandidaten) == "Freitag"

# 4.)
lisa <- as.Date(format(lisa.2015, "1989-%m-%d"))

# Damit haben wir alle Geburtstage beisammen.
lisa
herbert
peter

# Jetzt erstellen wir noch einen beschrifteten Vektor:
gebtag <- c(Lisa = lisa, Herbert = herbert, Peter = peter)

# Und sortieren ihn chronologisch
gebtag <- sort(gebtag)

gebtag



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Die Umsatzdaten
umsatz <- c(15, 19, 16, 14, 36, 48, 16, 13, 19, 19, 15, 54, 57, 11)


### a)

# Datum erzeugen
datum <- as.Date("1018-11-23") + 0:(length(umsatz) - 1)
daten <- data.frame(Datum = datum, Umsatz = umsatz)
daten


### b)

# Freitag und Samstag sind die 5. und 6. Tage der Woche.
# Damit funktioniert es auch mit anderern Laendereinstellungen (Locales).
bool.we <- format(datum, format = "%u") %in% c(5, 6)
bool.we

# Faktor erstellen und ans Dataframe anhaengen
daten$Wochenende <- factor(bool.we, levels = c(FALSE, TRUE),
  labels = c("Woche", "Wochenende"))

daten


### c)

tapply(daten$Umsatz, daten$Wochenende, mean)


### d)


tab.wochentag <- tapply(daten$Umsatz, weekdays(daten$Datum), mean)
tab.wochentag

# Die Wochentage sind nicht chronologisch sortiert. Wir koennten jetzt
# die Wochentage per Hand eingeben und die Tabelle entsprechend sortieren.
# Wir zeigen aber eine automatisierte Variante, die Locale-unabhaengig ist.

# 1.) Aus dem Datumsvektor (oder einem beliebigen Datumsvektor mit sieben
# aufeinanderfolgenden Tagen) den ersten Montag suchen
montag <- daten$Datum[format(daten$Datum, format = "%u") == "1"][1]
montag

# 2.) Sieben aufeinanderfolgende Tage ab (inkl.) Montag bilden
woche <- montag + 0:6
woche

# 3.) Wochentage extrahieren: Beachte, dass die Ausgabe zwar abhaengig von
# den Locales sind, der Code aber stets funktioniert. Die Namen sind
# chronologisch sortiert.
wochentage <- weekdays(woche)
wochentage

# 4.) Einen Faktor erstellen, wobei wir als Levels die eben generierten
# wochentage verwenden.
daten$Wochentag <- factor(weekdays(daten$Datum), levels = wochentage)
daten

# Jetzt koennen wir die Tabelle in chronologischer Sortierung erstellen.
tab.wochentag <- tapply(daten$Umsatz, daten$Wochentag, mean)
tab.wochentag



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


### a)

# Wir verwenden das Objekt wochentage aus dem vorherigen Beispiel.
wochentage

# Datumsvektor mit den Heiligabenden erzeugen
heiligabend <- as.Date(paste(2020:2059, 12, 24, sep = "-"))
heiligabend

# Tabelle erstellen ...
tab <- table(weekdays(heiligabend))
tab

# ... und chronologisch sortieren
tab <- tab[wochentage]
tab


### b)

# Wir muessen den 1. Adventsonntag fuer jedes Jahr berechnen. Das geht
# voellig gleich, wie im Fallbeispiel.

# Datum des 1. Adventsonntages berechnen
tag <- as.numeric(format(heiligabend, "%u"))
advent1 <- heiligabend - (tag %% 7) - 21
advent1

# Wahrheitsvektor, ob der 1. Adventsonntage im November stattfindet
bool.nov <- format(advent1, format = "%m") == 11
sum(bool.nov)

# Oder in Form einer Tabelle mit November und Dezember
monat.faktor <- factor(bool.nov, levels = c(TRUE, FALSE),
  labels = c("November", "Dezember"))
table(monat.faktor)



### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


# Beispieldatumsvektor
datum <- as.Date(paste(2020, c(1, 3, 4, 6, 7, 9, 10, 12),
  c(1, 31, 1, 30, 1, 30, 1, 31), sep = "-"))
datum


# Die Quartale berechnen sich wie folgt:
# Q1: Januar bis Maerz
# Q2: April bis Juni
# Q3: Juli bis September
# Q4: Oktober bis Dezember

# 1.) Monat bestimmen
monat <- as.numeric(format(datum, format = "%m"))

# 2.) Auf die Quartale umrechnen: durch 3 dividieren und aufrunden
q <- ceiling(monat / 3)

paste0("Q", q)

# Kontrolle
quarters(datum)



### -----------------------------------------------------------------------
### Beispiel 7
### -----------------------------------------------------------------------


# Beliebige Jahre waehlen
jahre <- c(2020, 2021)

### Variante 1: Selektionsstrategie

# 1.) Alle Kandidatenwerte generieren.
#     Dazu erzeugen wir fuer die 8 relevanten Monate jeweils die ersten
#     7 Tage. Dadurch haben wir fuer jeden Monat genau einen Donnerstag
#     im Vektor (den ersten).
kandidaten <- as.Date(paste(rep(jahre, each = 8*7), 
  rep(c(1, 3:6, 10:12), each = 7), 1:7, sep = "-"))
kandidaten

# 2.) Die Donnerstage selektieren (der 4. Tag der Woche)
stammtisch <- kandidaten[format(kandidaten, "%u") == 4]
stammtisch

# 3.) Jaennerstammtische um eine Woche nach hinten schieben
bool.jan <- format(stammtisch, format = "%m") == "01"
stammtisch[bool.jan] <- stammtisch[bool.jan] + 7
stammtisch


### Variante 2: Berechnungsstrategie

# 1.) Alle Monatsersten der 8 relevanten Monate generieren.
tag1 <- as.Date(paste(rep(jahre, each = 8), c(1, 3:6, 10:12), 1,
  sep = "-"))
tag1

# 2.) Die erforderliche Anzahl der Tage dazuaddieren
tag <- as.numeric(format(tag1, format = "%u"))
stammtisch <- tag1 + (4 + 7 - tag) %% 7
stammtisch

# 3.) Jaennerstammtische um eine Woche nach hinten schieben
bool.jan <- format(stammtisch, format = "%m") == "01"
stammtisch[bool.jan] <- stammtisch[bool.jan] + 7
stammtisch

