### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 26: Klassen, generische Funktionen und Attribute
### -------------------------------------------------------------------------


geschlecht <- factor(c(1, 2, 2, 1), labels = c("Mann", "Frau"))
alter <- c(23, 26, 19, 27)

geschlecht
alter



### -------------------------------------------------------------------------
### 26.1  Klassen, generische Funktionen -- class(), UseMethod(), methods()
### -------------------------------------------------------------------------


class(geschlecht)
class(alter)

# Drucke einen Faktor mit levels
print(geschlecht)

# Drucke einen numerischen Vektor
print(alter)


print

# Einige Methoden der Funktion print()
methods(print)[auszug]


### print() bei Objekten der Klasse integer

x <- 1:5
class(x)

# Gibt es eine spezielle Methode print.integer()?
"print.integer" %in% methods(print)

# Generischer print()-Aufruf
print(x)

# Äquivalent in diesem Fall
print.default(x)


### print() bei Objekten der Klasse factor

class(geschlecht)

# Gibt es eine spezielle Methode print.factor()?
"print.factor" %in% methods(print)

# Generischer print()-Aufruf
print(geschlecht)

# Äquivalent in diesem Fall
print.factor(geschlecht)


### print() bei Objekten der Klasse data.frame

x <- data.frame(Geschlecht = geschlecht, Alter = alter)
class(x)

"print.data.frame" %in% methods(print)

# Generischer print()-Aufruf
print(x)

# Äquivalent in diesem Fall
print.data.frame(x)



### -------------------------------------------------------------------------
### 26.2  Attribute erfragen und Klassenattribut entfernen -- attributes(),
###       unclass()
### -------------------------------------------------------------------------


unclass(geschlecht)     # Ruft intern print(unclass(geschlecht)) auf
attributes(geschlecht)  # Eine Liste mit den Attributen

# Zugriff auf Attribut class
attributes(geschlecht)$class

class(geschlecht)

# Zugriff auf Attribut levels
attributes(geschlecht)$levels

levels(geschlecht)



### -------------------------------------------------------------------------
### 26.3  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 26.3.1  Fallbeispiel: Run Length Encoding


# Anzahl der Münzwürfe
k <- 50

# Münzwürfe simulieren
RNGversion("4.0.2")
set.seed(29)
wurf <- sample(c("Z", "K"), size = k, replace = TRUE)

# Münzwürfe in String umwandeln
string <- paste(wurf, collapse = "")
string

# Matchlängen bestimmen: Suchmuster K, KK, KKK, KKKK, ...
res <- gregexpr("K+", string)[[1]]
res

# Attribut match.length selektieren und Häufigkeitstabelle erstellen
anz.kopf <- attributes(res)$match.length
table(anz.kopf)



### -------------------------------------------------------------------------
### 26.4  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 26.4.3  Übungen


M <- matrix(1:12, ncol = 3)
