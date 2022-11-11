### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 10
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Beispielzahlen
z1 <- c(3, 8, 4, 1)
z2 <- c(5, 9, 2, 5)

# paste() verwendet standardmaessig Leerzeichen als Separator, paste0()
# setzt keinen Separator.


### a)

paste(z1, "+", z2, "=", z1 + z2)
paste0(z1, " + ", z2, " = ", z1 + z2)


### b)

# Hier muessen wir (auch) collapse definieren.
paste(z1, "+", z2, "=", z1 + z2, collapse = " und ")
paste0(z1, " + ", z2, " = ", z1 + z2, collapse = " und ")



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


tipp <- c(4, 7, 15, 19, 20, 38)
lotto <- c(3, 19, 24, 23, 7, 34, 16)


### a)

# Zunaechst erstellen wir einen logischen Hilfsvektor, der uns angibt,
# ob die entsprechenden Zahlen von tipp gezogen wurden, ehe wir die Saetze
# mit paste() (oder paste0()) zusammenbauen.
gezogen <- ifelse(tipp %in% lotto, "gezogen", "nicht gezogen")
paste0("Die Zahl ", tipp, " wurde ", gezogen, ".")


### b)

# Wir formatieren die Zahlen des Vektors tipp, zum Beispiel mit ifelse():
# Wenn die Zahl zweistellig ist, brauchen wir nichts zu tun, ist die Zahl
# einstellig, haengen wir davor ein Leerzeichen an.
tipp.format <- ifelse(tipp >= 10, tipp, paste0(" ", tipp))
tipp.format

# Der Rest funktioniert wie in a)
paste0("Die Zahl ", tipp.format, " wurde ", gezogen, ".")


# Hinweis: In einem spaeteren Kapitel lernen wir Funktionen zur Formatierung
# von Zeichenketten kennen (format(), formatC()).


### c)

# Wir fuehren eine weitere vektorwertige Fallunterscheidung ein.
# Die Kunst bei derlei Zusammensetzungen ist es, die Leerzeichen korrekt
# einzustellen.
zusatz <- ifelse(tipp == lotto[length(lotto)], " (als Zusatzzahl)", "")
zusatz

paste0("Die Zahl ", tipp.format, " wurde ", gezogen, zusatz, ".")


# In dem Fall wurde die Zusatzzahl nicht gezogen. Testen wir also unseren
# Code, indem wir kurzerhand die letzte Zahl auf zum Beispiel 15 setzen.

lotto[length(lotto)] <- 15

gezogen <- ifelse(tipp %in% lotto, "gezogen", "nicht gezogen")
zusatz <- ifelse(tipp == lotto[length(lotto)], " (als Zusatzzahl)", "")
zusatz

paste0("Die Zahl ", tipp.format, " wurde ", gezogen, zusatz, ".")

# Passt :-)

