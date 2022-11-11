### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 11
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Wir gehen die Codes spaltenweise durch und kommentieren rechts daneben
# das interne Vorgehen bzw. die Typumwandlungen.

TRUE == 1            # TRUE => 1, 1 == 1
TRUE == 2            # TRUE => 1, 1 == 2
TRUE <= 2            # TRUE => 1, 1 <= 2
TRUE == "TRUE"       # TRUE => "TRUE", "TRUE" == "TRUE"
TRUE == "1"          # TRUE => "TRUE", "TRUE" == "1"
1 == "TRUE"          # 1 => "1", "1" == "TRUE"
1 == "1"             # 1 => "1", "1" == "1"
TRUE + "TRUE" == 2   # FEHLER: kann nicht mit Zeichenketten rechnen
TRUE + 1 == 2        # TRUE => 1, 1 + 1 == 2
TRUE + 1 == "2"      # TRUE => 1, 1 + 1 = 2, dann 2 => "2" und "2" == "2"
TRUE & "1"           # FEHLER: keine Zeichenketten mit logischen Operatoren
0 & 2                # 0 => FALSE, 2 => TRUE, FALSE & TRUE
0 | 2                # 0 => FALSE, 2 => TRUE, FALSE | TRUE
"FALSE" | TRUE       # FEHLER: keine Zeichenketten mit logischen Operatoren
(0 & 1) == FALSE     # 0 => FALSE, 1 => TRUE, FALSE & TRUE ergibt FALSE
                     # FALSE == FALSE ergibt TRUE



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Beispielvektor
x <- c(1, 2, 3, 5)
x


### a)

# Vorschlag Nummer 1: Hier wird zunaechst x == 2 ausgefuehrt, was einen
# logischen Vektor der Laenge jener von x erzeugt. Anschliessend wird
# dieser Vektor durch | mit 4 verknuepft. 4 wird zu TRUE umkonvertiert und
# daher entsteht ein Vektor mit lauter TRUE Einträgen und es werden daher
# alle Werte aus x selektiert.
x == 2 | 4
x[x == 2 | 4]

# Vorschlag Nummer 2: Ist nicht wirklich besser. Hier wird zunaechst 2 | 4
# ausgefuehrt. Dabei werden 2 und 4 in logische Werte umgewandelt (TRUE, da
# ungleich 0) und 2 | 4 ergibt TRUE. Effektiv wird also x == TRUE gebildet
# Jetzt wird aber TRUE in 1 umkonvertiert, womit wiederum effektiv x == 1
# abgefragt wird. Wir erhalten also alle Elemente aus x, die dem Wert 1 
# gleichen.
x == (2 | 4)
x[x == (2 | 4)]


### b)

x[x == 2 | x == 4]
x[x %in% c(2, 4)]



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


### a)

# 1.) In c(TRUE, 0) wird TRUE in 1 umkonvertiert.
c(TRUE, 0)

# 2.) Anschliessend werden diese Zahlen in Strings umkonvertiert.
c(c(TRUE, 0), "FALSE")

# 3.) Bei der Umwandlung in logische Werte kann 1 und 0 nicht richtig
# interpretiert werden, daher NA.
as.logical(c(c(TRUE, 0), "FALSE"))


### b)

# letters[a] gibt hier "d" zurueck.
# Da "b" im Alphabet vor "d" kommt, wird TRUE ausgegeben
# b <- 2 fliesst dabei nirgedwo ein.
a <- 4
b <- 2
"b" < letters[a]


### c)

# "T" und "UE" werden durch "R" verbunden, daher kommt "TRUE" heraus.
# "TRUE" kann in den Wahrheitswert TRUE umgewandelt werden.
as.logical(paste(c("T", "UE"), collapse = "R"))



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Beispielzahlen
x1 <- 3 + 2i
x2 <- 3 - 2i

x1
x2

# Abfrage, ob der Imaginaerteil von x1 * x2 gleich 0 ist.
x1 * x2
Im(x1 * x2) == 0



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


# Koeffizienten definieren
a <- 0.5
b <- -3
c <- 6.5

# Loesungen bestimmen gemaess der Formel
# (-b +/- sqrt(b^2 - 4*a*c)) / (2 * a)
# Wenn b^2 - 4*a*c >= 0 ist, dann gibt es eine reellwertige Loesung,
# andernfalls nicht. Genau da setzen wir an mit unserer Fallunterscheidung.

temp <- b^2 - 4*a*c
temp

# Gibt es eine reellwertige Loesung?
bool.reell <- b^2 - 4*a*c >= 0
bool.reell

# Berechne sowohl die reellwertige Loesung als auch die komplexwertige
# Loesung ...
res.reell <- (-b + c(-1, 1) * sqrt(temp)) / (2 * a)
res.komplex <- (-b + c(-1, 1) * sqrt(abs(temp)) * 1i) / (2 * a)

# Bei der komplexwertigen Loesung machen wir dabei Folgendes: sei x > 0:
# sqrt(-x) = sqrt(abs(x)) * 1i

res.reell
res.komplex

# ... und gebe das gemaess bool.reell passende Ergebnis aus.
# Dabei muss der Testvektor repliziert werden, da sonst nur das jeweils
# erste Element des Resultats zurueckgegeben wird.
ifelse(rep(bool.reell, 2), res.reell, res.komplex)

