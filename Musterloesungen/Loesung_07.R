### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 7
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Ggf. Arbeitsverzeichnis wechseln
# setwd(...)
objekte <- load("Apfel.RData")
objekte

# Hilfe zu sort()
# ?sort

# Beachte insbesondere den Parameter na.last!


### a)

sort(apfel, na.last = TRUE)


### b)

sort(apfel, na.last = FALSE)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


# Aus Beispiel 1
apfel

var(apfel)
var(apfel, na.rm = TRUE)


# Die Aufgabe sieht einfach aus, allerdings machen NAs sie anspruchsvoller.
# Eine Idee: Selektiere die gueltigen Beobachtungen mit Hilfe von is.na().

apfel.na <- apfel[!is.na(apfel)]
apfel.na

1 / (length(apfel.na) - 1) * sum((apfel.na - mean(apfel.na))^2)


# Eine andere (weniger empfehlenswerte, aber kreative) Idee:
# Verwende na.rm und die Beobachtung, dass sort() standardmaessig NAs
# entfernt.

# Anzahl der gueltigen Beobachtungen
n <- length(sort(apfel))
summe <- sum((apfel - mean(apfel, na.rm = TRUE))^2, na.rm = TRUE)
1 / (n - 1) * summe



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


# Die Variante 2 ist wohl schneller. Denn um die Quantile zu bestimmen,
# müssen die Elemente sortiert werden. Das Sortieren ist die zeitkritische
# Aufgabe.

# Wenn quantile() gut implementiert ist, wird sie den Vektor genau einmal
# sortieren und mit dem sortierten Vektor alle Quantile in einem Aufwasch
# bestimmen.

# In der 1. Variante muss bei jedem Aufruf von Quantile der Vektor sortiert
# werden. Das heisst, wir führen unnötige Mehrfachberechnungen durch.



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Hilfe zu mean()
# ?mean

# trim nimmt Werte in [0, 0.5] an und gibt an, welcher Anteil der kleinsten
# und groessten Werte eliminiert werden, bevor der Mittelwert berechnet
# wird. Betrachten wir ein Beispiel.

x <- c(0, 4, 5, 9, 17)
x

# trim = 0 (Standard) heisst: Alle Werte werden gemittelt
mean(x)

# trim = 0.2 heisst: Schneide die 20% groessten und 20% kleinsten Werte
# ab vor der Mittelung. In dem Fall hat x 5 Elemente, es werden also 0 und
# 17 entfernt und der Mittelwert aus 4, 5 und 9 gebildet.
mean(x, trim = 0.2)

# trim = 0.4 heisst demgemaess, dass die zwei groessten und zwei kleinsten
# Werte entfernt werden. Der Mittelwert aus dem verbliebenen Element 5 wird
# gebildet.
mean(x, trim = 0.4)



### -----------------------------------------------------------------------
### Beispiel 5
### -----------------------------------------------------------------------


# Beispielvektor
x <- 1:3

y <- sort(x)
y <- mean(y[((length(y) + 1:2) %/% 2)])
y

# Der Code berechnet den Median von x, wobei NAs implizit gestrichen
# werden (wegen sort(x)). Wie sieht man das?

# für 1:3 (ungerade Anzahl an Elementen) ergibt sich
y <- 1:3
length(y) + 1:2 
c(4, 5) %/% 2
mean(y[c(2, 2)])

# Also der Mittelwert aus der mittleren und der mittleren Beobachtung


# für 1:4 (gerade Anzahl an Elementen) ergibt sich
y <- 1:4
length(y) + 1:2
c(5, 6) %/% 2
mean(y[c(2, 3)])

# Also der Mittelwert aus den beiden mittleren Beobachtungen


# Kuerzere Alternative (wobei na.rm = TRUE nicht offensichtlich ist)
median(x, na.rm = TRUE)



### -----------------------------------------------------------------------
### Beispiel 6
### -----------------------------------------------------------------------


groesse <- c(176, 181, 181, 183, 163, 157, 164, 166, 176, 184)
gewicht <- c(65, 92, 65, 93, 49, 47, 55, 50, 62, 84)


### a)

summary(groesse)

# Ja, die Werte sind plausibel, da sie zwischen 157 und 184 liegen.
# Waere etwa das Minimum 1.73, dann hat die Person vermutlich eine Angabe
# in Metern gemacht, was wir korrigieren muessten.


### b)

# Die groesse muss in Meter umgerechnet werden.
bmi <- gewicht / (groesse / 100)^2
bmi


### c)

mean(bmi) > median(bmi)


### d)

sum(bmi >= 25)


### e)

# Anteile mit mean(), beachte die logische Verknuepfung
mean(bmi >= 18.5 & bmi < 25)


### f)

bmi.stand <- (bmi - mean(bmi)) / sd(bmi)



### -----------------------------------------------------------------------
### Beispiel 7
### -----------------------------------------------------------------------


groesse <- c(164, 1.83, 176, 480, 0, 167, 1.62)
groesse


### a)

# Wir nehmen an, dass alle Angaben im Intervall [1.2, 2.4] Meterangaben
# sind. Diese muessen wir mit 100 multiplizieren.
# Mit is.na() erfragen wir zusaetzlich, ob der Wert nicht fehlend ist.

bool <- groesse >= 1.2 & groesse <= 2.4
groesse[bool] <- groesse[bool] * 100

groesse


### b)

summary(groesse)

# Wir sehen ein Minimum von 0 und ein Maximum von 480, das sind Datenfehler.
# Wir setzen alle Werte ausserhalb von [120, 240] auf NA

groesse[groesse < 120 | groesse > 240] <- NA
groesse


### c)

groesse[!is.na(groesse)]

