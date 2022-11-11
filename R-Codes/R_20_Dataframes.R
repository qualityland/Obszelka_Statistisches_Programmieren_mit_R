### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 20: Dataframes
### -------------------------------------------------------------------------


# Die Testergebnisse
nummer <- c(38, 82, 53, 72, 31, 59)        # Matrikelnummern
gruppe <- c("A", "B", "B", "A", "B", "A")  # Testgruppe
punkte <- c(12, 31, 17, NA, 28, 39)        # Testergebnisse



### -------------------------------------------------------------------------
### 20.1  Allgemeines zu Dataframes
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 20.1.1  Dataframes generieren -- data.frame()


# Dataframe erstellen
test <- data.frame(nummer, Gruppe = gruppe, Punkte = punkte, punkte >= 20)
test

Bestanden <- punkte >= 20
Bestanden


### -------------------------------------------------------------------------
### 20.1.2  Dimension von Dataframes -- nrow(), ncol(), length()


# Anzahl der Zeilen
nrow(test)

# Anzahl der Spalten
ncol(test)

# Anzahl der Spalten
length(test) 


### -------------------------------------------------------------------------
### 20.1.3  Beschriftungen ändern -- rownames(), colnames(), names()


rownames(test)  # Zeilennamen
colnames(test)  # Spaltennamen
names(test)     # Spaltennamen

# Spalten und Zeilen umbenennen
bool <- names(test) %in% c("nummer", "punkte....20")
names(test)[bool] <- c("Nr", "Bestanden")
rownames(test) <- paste0("Stud", 1:nrow(test))

test


### -------------------------------------------------------------------------
### 20.1.4  Überblick über das Dataframe -- str(), head(), tail()


# Die ersten 3 Zeilen betrachten
head(test, n = 3)

# Die letzten 3 Zeilen betrachten
tail(test, n = 3)

# Die Struktur des Dataframes betrachten
str(test)


# stringsAsFactors
temp <- data.frame(Nr = nummer, Gruppe = gruppe, Punkte = punkte,
  Bestanden = punkte >= 20, stringsAsFactors = TRUE)
str(temp)



### -------------------------------------------------------------------------
### 20.2  Zusammenhang mit Matrizen -- as.matrix()
### -------------------------------------------------------------------------


# Dataframe test

test


# Umwandlung in Matrix
test.matrix <- as.matrix(test)
test.matrix

length(test.matrix)
mode(test.matrix)



### -------------------------------------------------------------------------
### 20.3  Zugriff auf Zeilen und Spalten: Subsetting
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 20.3.1  Zugriff auf Spalten/Variablen


# Zugriff mit [[ ]]
test[["Punkte"]]

# Zugriff mit $-Operator
test$Punkte

# Selektion mit [, ]
test[, "Punkte"]


# Zugriff mit [ ]
test["Punkte"]

# Zugriff mit [ , , drop = FALSE]
test[, "Punkte", drop = FALSE]
# Zugriff mit [ ]

test[c("Gruppe", "Punkte")]
# Zugriff mit [ , , drop = FALSE]
test[, c("Gruppe", "Punkte"),
  drop = FALSE]


### -------------------------------------------------------------------------
### 20.3.2  Zugriff auf Zeilen/Beobachtungen


test[test$Gruppe == "B" & test$Punkte >= 25 & !is.na(test$Punkte), ]

test[1, ]   # Eine Zeile selektieren


### -------------------------------------------------------------------------
### 20.3.3  Flexibler Zugriff -- subset()


subset(test, subset = Gruppe == "A" & Punkte < 20,
  select = c("Nr", "Gruppe", "Punkte"))

subset(test, subset = Gruppe == "A" & (Punkte < 20 | is.na(Punkte)),
  select = c("Nr", "Gruppe", "Punkte"))



### -------------------------------------------------------------------------
### 20.4  Manipulation von Dataframes
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 20.4.1  Variablen anfügen und löschen -- cbind(), NULL, list(NULL)


test


# 1.) Punkte des zweiten Antritts bestimmen
#     Jene Studierende herausgreifen, die antreten dürfen
bool <- test$Punkte < 20 | is.na(test$Punkte)
bool

#     Punkte des zweiten Antritts mit NA initialisieren
punkte2 <- rep(NA, nrow(test))
punkte2

#     Punkte simulieren und ersetzen
punkte2[bool] <- sample(0:40, size = sum(bool), replace = TRUE)
punkte2


# 2.) Zweiten Antritt anhängen und Spalte Punkte umbenennen
test$Pkt2 <- punkte2
names(test)[names(test) == "Punkte"] <- "Pkt1"
test


# 1.) Pkt bestimmen
pkt <- pmax(test$Pkt1, test$Pkt2, na.rm = TRUE)

# 2.) Note berechnen
note <- pmin(pmax(ceiling(8 - pkt / 40 * 8), 1), 5)

# Beide Variablen anhängen
test <- cbind(test, Pkt = pkt, Note = note)
test


# Spalte Bestanden löschen
test["Bestanden"] <- list(NULL)
# Alternative
# test$Bestanden <- NULL

test


### -------------------------------------------------------------------------
### 20.4.2  Zeilen und Spalten umordnen


# Dataframe test aufsteigend nach Gruppe und absteigend nach Pkt ordnen
test[order(test$Gruppe, -test$Pkt), ]


### -------------------------------------------------------------------------
### 20.4.3  Einträgen oder Variablen ersetzen


test[, "Pkt1"][is.na(test[, "Pkt1"])] <- 0
test$Pkt1[is.na(test$Pkt1)] <- 0    # Alternative

test



### -------------------------------------------------------------------------
### 20.5  Zusammenhang mit Listen -- is.list(), as.list(), is.data.frame(),
###       as.data.frame(), class(), unclass()
### -------------------------------------------------------------------------


test.part <- test[c("Pkt1", "Pkt2", "Pkt")]
test.part

is.data.frame(test.part)  # Abfrage auf Dataframe
is.list(test.part)        # Ein Dataframe ist tatsächlich auch eine Liste,
is.matrix(test.part)      # aber keine Matrix.

class(test.part)          # Klassenattribut abfragen

# Entferne das Klassenattribut
unclass(test.part)


# Umwandlung in eine Liste
test.part.liste <-
  as.list(test.part)
test.part.liste

# Rückumwandlung in ein Dataframe
# ist problemlos möglich.
as.data.frame(test.part.liste)


# Entferne fehlende Werte in Pkt2
temp <- test.part.liste[["Pkt2"]][!is.na(test.part.liste[["Pkt2"]])]
test.part.liste[["Pkt2"]] <- temp

# Die Liste ohne NAs in Pkt2
test.part.liste

# Rücküberführung in ein Dataframe
as.data.frame(test.part.liste) # !!


# Lösche alle 0-Einträge in Pkt1
test.part.liste$Pkt1 <- test.part.liste$Pkt1[test.part.liste$Pkt1 != 0]
test.part.liste

as.data.frame(test.part.liste)



### -------------------------------------------------------------------------
### 20.6  Funktionen revisited
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 20.6.1  apply() und sapply() bei Dataframes


test

# Berechne Spaltenmittelwerte mit colMeans() - so leider nicht!
colMeans(test, na.rm = TRUE)

apply(test, 2, mean, na.rm = TRUE)

sapply(test, mean, na.rm = TRUE)


# Bestimme, welche Spalten numerisch sind
bool.numeric <- sapply(test, is.numeric)
bool.numeric

# Spaltenmittelwerte aller numerischen Spalten berechnen
sapply(test[bool.numeric], mean, na.rm = TRUE)
colMeans(test[bool.numeric], na.rm = TRUE)   # Funktioniert jetzt tadellos

# Bestimme, welche Spalten Punktinformationen enthalten
bool.pkt <- grepl("Pkt[0-9]*", names(test))
bool.pkt

test[bool.pkt]

colMeans(test[bool.pkt], na.rm = TRUE)


### -------------------------------------------------------------------------
### 20.6.2  is.na() und Vergleichsoperatoren bei Dataframes


test[bool.pkt]
is.na(test[bool.pkt])


# Wie oft wurden bei jedem Test mindestens 20 Punkte erzielt?
test[bool.pkt]
test[bool.pkt] >= 20
colSums(test[bool.pkt] >= 20, na.rm = TRUE)



### -------------------------------------------------------------------------
### 20.7  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 20.7.1  Objekte sichern


# Daten sichern
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
# setwd(...)
save(test, file = "Test.RData")


### -------------------------------------------------------------------------
### 20.7.4  Übungen


geschlecht <- c("w", "m", NA, "m", "w", "w", "w", "m", "m", "m")
groesse <- c(176, 181, 181, 183, 163, 157, 164, 166, 176, 184)
gewicht <- c(65, 92, 65, 93, 49, 47, NA, 50, 62, 84)
bool.test <- grepl("Pkt[0-9]+", names(test))
