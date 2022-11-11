### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 31: Stringformatierung, Consoleneingabe und -ausgabe
### -------------------------------------------------------------------------


# Name und Alter der herausgepickten Kinder
name <- c("Hugo", "Brigitte")
alter <- c(9, 10)



### -------------------------------------------------------------------------
### 31.1  Consolenausgabe -- cat(), print(), "\n", "\t"
### -------------------------------------------------------------------------


# Trenne Spalten mit Tabulator und Zeilen mit Zeilenumbruch
text <- paste0(name, "\t", alter, collapse = "\n")
text <- paste0(text, "\n")
cat(text)

nchar(text)



### -------------------------------------------------------------------------
### 31.2  Strings formatieren -- format()
### -------------------------------------------------------------------------


# Unformatiert
name
nchar(name)

# Linksbündige Formatierung
format(name)
nchar(format(name))

# Rechtsbündig ausrichten
format(name, justify = "right")

# Zentriert ausrichten
format(name, justify = "centre")


format(name,
  width = 6)

format(name,
  width = max(nchar(name)) + 2)



### -------------------------------------------------------------------------
### 31.3  Zahlen formatieren -- formatC()
### -------------------------------------------------------------------------


alter

# Formatiere alter rechtsbündig
formatC(alter, width = max(nchar(alter)))

# Formatiere alter mit führenden Nullen
formatC(alter, width = max(nchar(alter)), flag = "0")



### -------------------------------------------------------------------------
### 31.4  Tabellen erstellen
### -------------------------------------------------------------------------


# 1.) Variablennamen und Werte zusammenketten.
name1 <- c("Name", name)
alter1 <- c("Alter", alter)

# 2.) Zeilen der Tabelle erstellen
text <- paste0(format(name1), " | ", format(alter1, justify = "right"))
text

# 3.) Waagrechten Trennstrich erzeugen
strich <- paste0(paste0(rep("-", max(nchar(text))), collapse = ""), "\n")
strich

# 4.) Teile korrekt zusammenbauen
titel <- paste0(text[1], "\n")
rest <- paste0(paste0(text[-1], collapse = "\n"), "\n")
tabelle <- paste0(titel, strich, rest)

# Ausgabe unserer Tabelle
cat(tabelle)


text <- paste0(paste0(name1, "\t", alter1, collapse = "\n"), "\n")
cat(text)



### -------------------------------------------------------------------------
### 31.5  Consoleneingabe -- scan()
### -------------------------------------------------------------------------


namen <- scan(what = "")
Hugo
Hans Peter
Anna

namen


namen <- scan(what = "")
Hugo
"Hans Peter"
Anna

namen


namen <- scan(what = "", sep = "*")
Hugo
Hans Peter
Anna

namen


# n = 7 heisst, dass nach (spätestens) 7 Eingaben Schluss ist.
lottozahlen <- scan(n = 7)  # 6 + Zusatzzahl
3
19
24
23
7
34
16

# Die eingelesenen Zahlen
lottozahlen

# Es sind tatsächlich Zahlen
is.numeric(lottozahlen)



### -------------------------------------------------------------------------
### 31.6  Aus der guten Praxis
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 31.6.1  Fallbeispiel: Mathequiz


n <- 2; k <- 3
M <- matrix(sample(1:10, size = n * k, replace = TRUE), ncol = k)
M

# Rechnungen erstellen
rechnung <- apply(M, 1, paste,
  collapse = " * ")
rechnung

# Korrekte Ergebnisse berechnen
erg <- apply(M, 1, prod)

erg


### Nicht abgesicherte Version des Mathequiz

mathequiz <- function(n, k = 2) {
  # Stellt n Multiplikationsaufgaben mit je k Faktoren.
  # Gibt eine Liste mit der Anzahl der gestellten Aufgaben und der
  # Anzahl der richtig gelösten Aufgaben zurück.
  # n ... Anzahl der Aufgaben
  # k ... Schwierigkeitsgrad der Aufgaben = Anzahl der Faktoren
  #       Defaultwert: 2
	
  # 1.) Erstelle Matrix mit den Faktoren
  M <- matrix(sample(1:10, size = n * k, replace = TRUE), ncol = k)
	
  # 2.) Erstelle die Rechnungen und die Ergebnisse
  rechnung <- apply(M, 1, paste, collapse = " * ")
  erg <- apply(M, 1, prod)
	
  # 3.) Zähler für die Anzahl der richtigen Antworten
  anz.richtig <- 0
	
  for (i in 1:n) {
    # 4.) Frage stellen
    cat("Wie lautet das Ergebnis der folgenden Rechnung:\n")
    cat(paste0("    ", rechnung[i], "\n"))
	
    # 5.) Auf Eingabe des Benutzers warten
    tipp <- scan(n = 1)  # Bei numerischen Werten bleibt what frei
	
    # 6.) Vergleiche tipp mit der richtigen Loesung
    if (tipp == erg[i]) {
      # korrekt! Gebe Glückwunschtext aus.
      cat("Super, weiter so!\n")
      anz.richtig <- anz.richtig + 1
    }
    else {
      # Falsch! Gebe "Motivationstext" aus.
      cat("Falsch! Streng dich an, du Penner!\n")
    }
  }
	
  # 7.) Ergebnis ausdrucken und als Liste zurückgeben
  cat(paste0("Ergebnis: ", anz.richtig, " geloeste Aufgaben.\n"))
  return(list(Aufgaben = n, Richtig = anz.richtig))
}


as.numeric("Keine Zahl")
is.na(as.numeric("Keine Zahl"))

# Annahme: Es werden folgende "Zahlen" eingegeben:
eingabe <- c("Null", "Eins", "2", "3")

while (TRUE) {
  # Entnehme nächste Eingabe
  zahl <- as.numeric(eingabe[1])
  eingabe <- eingabe[-1]
	
  if (!is.na(zahl)) {
    # Gültige Zahl: Abbruch
    break
  }
	
  # Keine gültige Zahl: Hinweistext ausgeben
  cat("Bitte eine gueltige Zahl eingeben!\n")
}
	
zahl   # Enthält die erste gültige Zahl von eingabe


tipp <- character(0)  # leeren Vektor erzeugen
length(tipp) > 0 & !is.na(as.numeric(tipp))
if (length(tipp) > 0 & !is.na(as.numeric(tipp))) print("Hallo")


### Abgesicherte Version des Mathequiz

mathequiz <- function(n, k = 2) {
  # Stellt n Multiplikationsaufgaben mit je k Faktoren.
  # Gibt eine Liste mit der Anzahl der gestellten Aufgaben und der
  # Anzahl der richtig gelösten Aufgaben zurück.
	
  M <- matrix(sample(1:10, size = n * k, replace = TRUE), ncol = k)
  rechnung <- apply(M, 1, paste, collapse = " * ")
  erg <- apply(M, 1, prod)
	
  anz.richtig <- 0
	
  for (i in 1:n) {
    cat("Wie lautet das Ergebnis der folgenden Rechnung:\n")
    cat(paste0("    ", rechnung[i], "\n"))
	
    suppressWarnings(
      while (TRUE) {
        tipp <- scan(what = "", n = 1)  # what = "" -> character
	
        if (length(tipp) > 0 && !is.na(as.numeric(tipp))) {
          # Jetzt wurde eine zulässige Zahl eingegeben
          break
        }
	
        # Es wurde keine zulässige Zahl eingegeben.
        cat("Bitte eine gueltige Zahl eingeben!\n")
      }
    )
	
    # Umwandeln, da String übergeben wurde
    tipp <- as.numeric(tipp)
	
    # Vergleiche tipp mit der richtigen Loesung
    if (tipp == erg[i]) {
      cat("Super, weiter so!\n")
      anz.richtig <- anz.richtig + 1
    }
    else {
      cat("Falsch! Streng dich an, du Penner!\n")
    }
  }
	
  cat(paste0("Ergebnis: ", anz.richtig, " geloeste Aufgaben.\n"))
  return(list(Aufgaben = n, Richtig = anz.richtig))
}



### -------------------------------------------------------------------------
### 31.7  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 31.7.3  Übungen


x <- runif(10, -20, 20)
