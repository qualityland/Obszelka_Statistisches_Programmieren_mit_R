### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 25
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# tapply(): Kann nur eine Variable nach einem Faktor splitten.
# aggregate(): Kann mehrere Variablen (Dataframes) verarbeiten.
#   by muss immer eine Liste sein.



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Daten laden
# Evtl. Arbeitsverzeichnis wechseln bzw. absoluten/relativen Pfad angeben
objekte <- load("Vertreter.RData")
objekte

aggregate(daten[lapply(daten, is.numeric)], daten$Gebiet, mean)

# Korrekturen:
# 1.) lapply() muss durch sapply() ersetzt werden.
# 2.) aggregate() braucht fuer by eine Liste (oder Dataframe).
aggregate(daten[sapply(daten, is.numeric)], daten["Gebiet"], mean)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


# Daten laden: siehe vorheriges Beispiel


### a)

tab.min <- tapply(daten$Gewinn, daten[c("Gebiet", "Ausbildung")], min)
tab.min


### b)

# Ohne addmargins()
# Spaltenmaxima anhaengen
tab.min.max <- tab.min
col.max <- apply(tab.min.max, 2, max)
tab.min.max <- rbind(tab.min.max, max = col.max)

# Zeilenmaxima anhaengen
row.max <- apply(tab.min.max, 1, max)
tab.min.max <- cbind(tab.min.max, max = row.max)
tab.min.max


# Mit addmargins()
addmargins(tab.min, FUN = max)



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Datensatz laden und Hilfe zum Datensatz abrufen
data(airquality)
# ?airquality

head(airquality) # Überblick über den Datensatz


### a)

colSums(is.na(airquality))


### b)

anz.na <- rowSums(is.na(airquality))
sum(anz.na >= 1)


### c)

aggregate(airquality[c("Ozone", "Solar.R", "Wind", "Temp")],
  by = airquality["Month"], mean, na.rm = TRUE)


### d)

Temp30 <- factor(airquality$Temp <= 86, levels = c(TRUE, FALSE),
  labels = c("<=30GradC", ">30GradC"))
Temp30

# Temp30 anhaengen
airquality$Temp30 <- Temp30


### e)

# Haeufigkeitstabelle mit beiden Variablen erstellen
tab <- table(Temp30, airquality$Month)
tab

# Beschriftungen der leeren Kombinationen zusammenbauen
res0 <- cbind(rownames(tab)[tab == 0], colnames(tab)[tab == 0])
colnames(res0) <- c("Temp30", "Month")
res0


### f)

# mit drop = FALSE kann man auch leere Kategorien bzw. Kategoriekombinationen
# ausdrucken.
aggregate(airquality[c("Ozone", "Solar.R", "Wind", "Temp")],
  by = airquality[c("Month", "Temp30")], mean, na.rm = TRUE, drop = FALSE)

