### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 21: Dataframes verknüpfen
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 21.1  Joins -- merge()
### -------------------------------------------------------------------------


# Erstelle die Dataframes
T1 <- data.frame(Name = c("Ben", "Eva"), T1 = c(2, 3))
T2 <- data.frame(Name = c("Eva", "Jan"), T2 = c(5, 4))

T1
T2


# Inner Join
# all = FALSE
merge(T1, T2)

# Outer Join
merge(T1, T2,
  all = TRUE)

# Left Join
merge(T1, T2,
  all.x = TRUE)

# Right Join
merge(T1, T2,
  all.y = TRUE)


names(T1)
names(T2)

intersect(names(T1), names(T2))


names(T2)[1] <- "Person"
T2

intersect(names(T1), names(T2))

merge(T1, T2, all = TRUE)

# Outer Join
Res.outer <- merge(T1, T2, by.x = "Name", by.y = "Person", all = TRUE)
Res.outer



### -------------------------------------------------------------------------
### 21.2  Zeilenweise Verknüpfung -- rbind()
### -------------------------------------------------------------------------


Res2 <- data.frame(
  Person = c("Ina", "Tom"), T1 = c(5, 1), T2 = c(5, NA))

# Unsere Studis
Res.outer

# Studis der Parallelgruppe 2
Res2


# Dataframes zeilenweise verknüpfen - so noch nicht
rbind(Res.outer, Res2)


# Dataframes zeilenweise verknüpfen - so klappt es
names(Res2)[names(Res2) == "Person"] <- "Name"   # Beschriftung ändern
Res.outer
Res2

rbind(Res.outer, Res2)


# Verdrehe die Spalten von Res2 - rbind() funktioniert immer noch
Res2 <- Res2[length(Res2):1]
Res.outer
Res2

rbind(Res.outer, Res2)



### -------------------------------------------------------------------------
### 21.3  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 21.3.1  Fallbeispiel: Verwaltung einfacher Datenbanken


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


gerda.nr <- Stud$Nr[Stud$Name == "Gerda"]
LV$Titel[LV$Nr %in% besucht$LV[besucht$Student == gerda.nr]]

# 1.) Gerdas LVs - mit merge()
Stud.gerda <- Stud[Stud$Name == "Gerda", ]
temp <- merge(Stud.gerda, besucht, by.x = "Nr", by.y = "Student")
res <- merge(temp, LV, by.x = "LV", by.y = "Nr")

Stud.gerda
temp
res
res$Titel
