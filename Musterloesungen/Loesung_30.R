### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 30
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


# Lösche Objekte
rm(v, w, x, y, z)

w <- 1
x <- 2
y <- 3
z <- 4

fun <- function(x = 5, y) {
  v <- 0
  w <- -1
  return(v + w + x + y + z)
}


### a)

# i. Fehlermeldung (Argument y fehlt)
# v und w sind innerhalb von fun() definiert, fuer x wird der Defaultwert
# 5 eingesetzt. z ist nicht innerhalb von fun() definiert, also greift R
# auf z <- 4 ausserhalb von fun() zu. y jedoch ist innerhalb von fun()
# definiert, daher greift R *nicht* auf y <- 3 zurueck. Da y keinen
# Standardwert hat und wir y beim Funktionsaufruf nicht spezifizieren,
# kann R das Objekt y nicht finden.
fun()

# ii. Fehlermeldung (Argument y fehlt)
# Wie i., nur dass jetzt x auf 7 gesetzt wird. Nach wie vor fehlt fuer y
# eine Spezifikation.
fun(7)

# iii. 15 (0 - 1 + 5 + 7 + 4)
# Hier wird fuer x der Standardwert 5 herangezogen. Dank y = 7 sind jetzt
# alle Objekte definiert.
fun(y = 7)

# iv. 16 (0 - 1 + 6 + 7 + 4)
# Hier wird zunaechst x = 6 gesetzt, da wir x exakt benannt haben. Das
# unbenannte Argument 7 wird auf den naechsten noch nicht spezifizierten
# Parameter zugewiesen (y).
fun(7, x = 6)


### b)

fun(7, x = 6)

# v kann nicht gefunden werden, da es ausserhalb von fun() nicht erzeugt
# wurde und das v innerhalb von fun() als eigenstaendiges Objekt nur
# innerhalb von fun() existiert.
# w, x, y und z behalten ihre Werte von aussen (1, 2, 3 und 4). Insbesondere
# wird w nicht auf -1 gesetzt, da das w innerhalb von fun() unabhaengig von
# w ausserhalb von fun() ist.
v
w
x
y
z


### c)

# Wir sollten nach Moeglichkeit vermeiden, dass wir auf Objekte ausserhalb
# einer Funktion zugreifen.

fun <- function(v = 0, w = -1, x = 5, y, z) {
  return(v + w + x + y + z)
}



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


geschlecht <- c("w", "m", NA, "m", "w", "w", "w", "m", "m", "m")
groesse <- c(176, 181, 181, 183, 163, 157, 164, 166, 176, 184)
gewicht <- c(65, 92, 65, 93, 49, 47, NA, 50, 62, 84)

daten <- data.frame(geschlecht, groesse, gewicht)
daten


# Wir bedienen uns einer anonymen Funktion, die der Reihe nach die
# numerischen Spalten von daten erhaelt und in die Funktion tapply()
# steckt.
bool <- sapply(daten, is.numeric)
sapply(daten[bool], function(x)
  tapply(x, daten$geschlecht, mean, na.rm = TRUE))



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


# Der Bisektionsalgorithmus eignet sich hervorragend fuer Rekursion, da
# das Problem immer kleiner wird (das Intervall halbiert sich) und wir
# keine Mehrfachberechnungen durchfuehren (was sehr ineffizient waere).

bisektion.rekursiv <- function(f, intervall, eps = 10^(-9)) {
  # Gibt eine Liste mit einer Nullstelle von f und dem Funktionswert
  # an dieser Stelle zurueck.
  # f ........... Objekt vom Typ function, gibt reelle Zahl zurück
  # intervall ... Intervall, in dem gesucht werden soll.
  # eps ......... Rechengenauigkeit

  # Hier darfst du gerne auf sinnvolle Werte fuer die Parameter pruefen
  # und ggf. mit einer Fehlermeldung abbrechen!

  links <- min(intervall)
  rechts <- max(intervall)

  # Checke Vorzeichenbedingung
  if (f(links) * f(rechts) > 0)
    stop("Kein Vorzeichenwechsel im uebergebenen Intervall!")

  mitte <- (links + rechts) / 2

  # Jetzt kommt die Rekursion:
  # .) Ist |f(mitte)| < eps, so gebe diesen Wert zurueck.
  # .) Andernfalls rufe die Funktion rekursiv mit dem halbierten Intervall
  #    auf.
  if (abs(f(mitte)) <= eps) {
    # Gebe Liste zurück mit der näherungsweisen Nullstelle und dem
    # Funktionswert.
    return(list(Nullstelle = mitte, Funktionswert = f(mitte)))
  }
  else {
    # Rekursiver Abstieg
    if (f(mitte) * f(links) > 0) {
      # Vorzeichen wechselt nicht
      return(Recall(f, c(mitte, rechts), eps))
    }
    else {
      # Vorzeichen wechselt
      return(Recall(f, c(links, mitte), eps))
    }
  }
}


# Testen unsere Funktion

# Berechne die Wurzel aus 2
fun <- function(x) x^2 - 2
bisektion.rekursiv(fun, intervall = c(0, 2))

# Zur Kontrolle
sqrt(2)



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Zunaechst lesen wir alle notwendigen Funktionen ein.

is.ganzzahlig <- function(x) {
  # Prüft, ob alle Elemente des Vektors x annähernd ganzzahlig sind.
  
  return(all((x %% 1)^2 < .Machine$double.eps))
}


Bruch <- function(zaehler, nenner) {
  # Erzeugt aus zwei annaehernd ganzzahligen Skalaren zaehler und nenner
  # ein Objekt der Klasse Bruch

  # Pruefe auf numerische Skalare
  if (!is.numeric(zaehler) || !is.numeric(nenner) ||
    length(zaehler) > 1 || length(nenner) > 1) {
    stop("Zaehler und Nenner muessen numerische Skalare sein!")
  }

  # Ergebnisobjekt erstellen
  res <- c(zaehler, nenner)

  # Pruefe auf gültige Werte und annaehernde Ganzzahligkeit
  if (any(is.na(res)) || !is.ganzzahlig(res)) {
    stop("Zaehler und Nenner muessen ganzzahlig sein!")
  }

  # In Integer (ganzzahlige Werte) umwandeln
  res <- as.integer(round(res))

  # Klasse "Bruch" hinzufügen und Bruch zurückgeben
  class(res) <- c("Bruch", class(res))
  return(res)
}


print.Bruch <- function(bruch) {
  cat(paste0(bruch[1], "/", bruch[2], "\n"))
}


"+.Bruch" <- function(bruch1, bruch2) {
  if (!inherits(bruch1, "Bruch")) {
    bruch1 <- Bruch(bruch1, nenner = 1) # Versuche Bruch zu erstellen
  }
  if (!inherits(bruch2, "Bruch")) {
    bruch2 <- Bruch(bruch2, nenner = 1) # Versuche Bruch zu erstellen
  }

  nenner <- bruch1[2] * bruch2[2]
  zaehler <- bruch1[1] * bruch2[2] + bruch2[1] * bruch1[2]
  return(Bruch(zaehler, nenner))
}


### Jetzt zu unserer Subtraktionsfunktion "-.Bruch"

# Wir fuehren "-.Bruch" einfach auf "+.Bruch" zurueck.
# Achtung: Es ist besser "+.Bruch" statt "+" aufzurufen. Denn wenn bruch1
# oder bruch2 keine Brueche sind, so wird die falsche Funktion gewaehlt.

"-.Bruch" <- function(bruch1, bruch2) {
  if (!inherits(bruch2, "Bruch")) {
    bruch2 <- Bruch(bruch2, nenner = 1) # Versuche Bruch zu erstellen
  }

  # Vorzeichen umdrehen
  bruch2[1] <- -bruch2[1]

  return("+.Bruch"(bruch1, bruch2))
}


# Testen unsere Funktion
b1 <- Bruch(7, 5)
b2 <- Bruch(3, 10)

b1
b2

# 7/5 - 3/10 sollte 11/10 ergeben (oder ungekuerzt 55/50).
b1 - b2

