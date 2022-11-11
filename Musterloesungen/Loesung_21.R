### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 21
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Die Tabellen mit Beispieldaten
Stud <- data.frame(Nr = 1:4, Name = c("Fritz", "Gerda", "Hubert",
  "Isabella"), stringsAsFactors = FALSE)
LV <- data.frame(Nr = 11:14, Titel = c("Statistik", "Programmieren",
  "Analysis", "Spieltheorie"), stringsAsFactors = FALSE)
besucht <- data.frame(Student = c(1, 2, 2, 4, 4),
  LV = c(12, 11, 12, 12, 13))

Stud
LV
besucht


### 1.)

# Bereits im Buch geloest


### 2.)

# Mit merge()
# Wir machen einen Inner Join (Standard), wobei wir die Schluessel manuell
# einstellen muessen.
LV.merge <- merge(LV, besucht, by.x = "Nr", by.y = "LV")
LV.merge

# Titel ausgeben
unique(LV.merge$Titel)


# Eine flexible Moeglichkeit, um Abfragen wie: Gib die Titel all jener
# Lehrveranstaltungen aus, die von mindestens k Personen besucht werden,
# basiert auf table():
k <- 1
tab.lv <- table(LV.merge$Titel)
tab.lv

tab.lv[tab.lv >= k]


# Ohne merge()
# Idee: LVs, die von mindestens einer Person besucht werden, kommen im
# Dataframe besucht vor. Alle anderen LVs kommen da nicht vor.
lvnr <- sort(unique(besucht$LV))
lvnr

# Selektiere die Titel zu diesen Nummern
LV$Titel[LV$Nr %in% lvnr]


### 3.)

# Schritt 1: Tabelle vorbereiten
stud.tab <- rep(0, length = nrow(Stud))
names(stud.tab) <- Stud$Name
stud.tab

# Schritt 2: Studierendendaten mit besucht zusammenfuehren
stud.merge <- merge(Stud, besucht, by.x = "Nr", by.y = "Student")
stud.merge

# Schritt 3: Haeufigkeiten der Namen bestimmen und in Tabelle einfuellen
tab <- table(stud.merge$Name)
tab

stud.tab[names(tab)] <- tab
stud.tab


### 4.)

# Wir bereiten die LV-Tabelle vor: Dazu erstellen wir einen Right Join
# zwischen besucht und LV, sodass alle LVs in der Tabelle erscheinen.
LV.merge <- merge(besucht, LV, by.x = "LV", by.y = "Nr", all.y = TRUE)
LV.merge


# a) Right Join zwischen Stud und LV.merge
merge(Stud, LV.merge, all.y = TRUE, by.x = "Nr", by.y = "Student")

# b) Inner Join zwischen Stud und LV.merge
merge(Stud, LV.merge, by.x = "Nr", by.y = "Student")

# c) Outer Join zwischen Stud und LV.merge
merge(Stud, LV.merge, all = TRUE, by.x = "Nr", by.y = "Student")


### 5.)

# Matrikelnummer von Isabella erfragen
stud.nummer <- Stud$Nr[Stud$Name == "Isabella"]
stud.nummer

# LV-Nummer von Spieltheorie erfragen
lv.nummer <- LV$Nr[LV$Titel == "Spieltheorie"]
lv.nummer

# Dataframe besucht erweitern
besucht <- rbind(besucht, c(stud.nummer, lv.nummer))
besucht

# Alternativ kann man auch zwei Dataframes verschmelzen:
# temp <- data.frame(Student = stud.nummer, LV = lv.nummer)
# besucht <- rbind(besucht, temp)
# besucht

