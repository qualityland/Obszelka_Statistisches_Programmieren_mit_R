### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 31
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


x <- runif(10, -20, 20)
x

x.round <- round(x, 2)
x.round


# Wir schauen in der R-Hilfe zu formatC() (?formatC) nach und entdecken
# unter anderem die Parameter format und digits, die sich hervorragend
# fuer unseren Zweck eignen.
# Mit format = "f" stellen wir ein, dass es sich um Dezimalzahlen handelt,
# wodurch in weiterer Folge digits als die Anzahl der Nachkommastellen
# interpretiert wird.
x.format <- formatC(x.round, format = "f", digits = 2,
  width = max(nchar(x.round)))
x.format

# Indexvektor formatieren
index.format <- formatC(1:length(x), width = nchar(length(x)))
index.format

# Baue String zusammen
paste0("Zufallszahl Nr. ", index.format, ": ", x.format)



### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------


### Vorueberlegung zu der Anzahl der Nachkommastellen

# Bei den Rundungsfunktionen (zum Beispiel ?round) sehen wir die Funktion
# signif(), die sich als einfache Moeglichkeit anbietet, die Anzahl der
# Nachkommastellen gut einzustellen. Probieren wir sie aus!

u <- runif(5, min = -100, max = 100)
u

# Runde auf 4 signifikante Stellen
signif(u, digits = 4)

# Addieren wir 1000 hinzu, dann fallen die Nachkommastellen nicht mehr
# so stark ins Gewicht!
u <- u + 1000
u

signif(u, digits = 4)

# Runden wir auf eine Nachkommastelle
u <- round(u/10 - 100, digits = 1)
u

z <- signif(abs(u), digits = 4)
z

# Die Anzahl der benoetigten Nachkommastellen finden wir zum Beispiel
# so heraus:
# 1.) Wir suchen bei den mit signif() gerundeten Zahlen nach dem Muster
#     [.][0-9]+
# 2.) Die Matchlaenge abzueglich 1 gibt die Anzahl der Nachkommastellen
#     der entsprechenden Zahlen an.
# 3.) Nimm das Maximum davon, oder 0, wenn alle Eintraege negativ sind.

# 1.)
res.dec <- regexpr("[.][0-9]+", z)
res.dec

# 2.)
anz.dec <- attributes(res.dec)$match.length - 1
anz.dec

# 3.)
formatC(z, format = "f", digits = max(0, anz.dec))


# Diese Erkenntnisse stecken wir in eine Funktion, auf die wir dann in der
# eigentlichen Druckfunktion zugreifen.

format.signif <- function(x, digits = 4) {
  x.round <- signif(x, digits = digits)

  res.dec <- regexpr("[.][0-9]+", x.round)
  res.dec
  
  anz.dec <- attributes(res.dec)$match.length - 1
  anz.dec

  return(formatC(x.round, format = "f", digits = max(0, anz.dec)))
}


### Die Printfunktion

cat.data.frame <- function(df, digits = 4) {
  # Druckt alle numerischen Spalten sowie Faktoren oder Zeichenketten
  # des Dataframes df als formatierte Tabelle auf die Console.
  # df ....... Ein Dataframe
  # digits ... Anzahl der signifikanten Stellen bei Dezimalzahlen

  titel <- NULL
  zeilen <- NULL

  for (j in 1:ncol(df)) {
    x <- df[[j]]

    if (!is.numeric(x) && !is.character(x) && !is.factor(x)) {
      next
    }

    # Temporaeres Objekt, das den Titel der aktuellen Spalte verwaltet
    titel.temp <- names(df)[j]

    if (is.numeric(x)) {
      # Unterscheide ganzzahlige und nicht ganzzahlige Zahlen
      if (!any(grepl("[.]", x))) {
        # Ganze Zahlen koennen wir einfach rechtsbuendig anordnen
        zeilen.temp <- format(x, justify = "right")
      }
      else {
        # Dezimalzahlen runden wir adäquat.
        zeilen.temp <- format.signif(x, digits = digits)
      }
    }
    else {
      # Etwaige Faktoren in Strings umwandeln
      x <- as.character(x)
      zeilen.temp <- format(x)
    }

    if (!is.null(titel)) {
      # Senkrechte Striche anhaengen
      zeilen <- paste0(zeilen, " | ")
      titel <- paste0(titel, " | ")
    }

    # Inhalt anhaengen
    inhalt <- format(c(titel.temp, zeilen.temp),
      justify = ifelse(is.numeric(x), "right", "left"))
    titel <- paste0(titel, inhalt[1])
    zeilen <- paste0(zeilen, inhalt[-1])
  }

  # Feinschliff
  strich <- paste0(paste0(rep("-", nchar(titel)), collapse = ""), "\n")
  titel <- paste0(titel, "\n")
  zeilen <- paste0(zeilen, "\n")
  
  cat(titel, strich, zeilen, sep = "")
}


# Testen unsere Funktion

# Name und Alter der herausgepickten Kinder
name <- c("Hugo", "Brigitte")
alter <- c(9, 10)

# Mische noch ein paar Gewichtsangaben hinzu. Um die Funktion zu testen,
# messen wir bei Hugo besonders genau ;-)
gewicht.kg <- c(38.57154, 34.5)   # in kg
gewicht.g <- gewicht.kg * 1000    # in g

df <- data.frame(Name = name, Alter = alter, "Gewicht_kg" = gewicht.kg,
  "Gewicht_g" = gewicht.g)
df


cat.data.frame(df)

# Beachte, dass bei Gewicht in Gramm auch auf 4 signifikante Stellen
# gerundet wird (38571.54 => 38570). Das macht bei Ueberblickstabellen
# durchaus Sinn, aber wenn wir das nicht so haben wollen, muessen wir
# im Code ueberpruefen, ob nach der Rundung noch Nachkommastellen uebrig
# bleiben. Falls nicht, so runde die Zahlen mit round().

# Integerzahlen werden rechtsbuendig formatiert. Wir koennen natuerlich
# auch bei allen Zahlen unsere format.signif()-Funktion verwenden. Das
# machen wir in Beispiel 3 so.

# Zahlen auf 3 signifikante Stellen runden
cat.data.frame(df, digits = 3)



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------


# In diesem Beispiel koennen wir grosse Teile von Beispiel 2
# wiederverwerten. Nichtnumerische Spalten werden mit as.character()
# in Strings umgewandelt.

# Als Zusatzoption bauen wir digits ein, analog zu Beispiel 2.


createLatexTable <- function(df, justify, digits = 4) {
  # Erzeugt aus dem Dataframe df eine LaTeX-Tabelle
  # df ........ Ein Dataframe
  # justify ... Vektor derselben Laenge wie df, gibt an, wie die Spalten
  #             angeordnet werden sollen.
  #             "l": left (linksbuendig)
  #             "c": centered (zentriert)
  #             "r": right (rechtsbuendig)
  # digits .... Anzahl der signifikanten Stellen bei Zahlen

  # Pruefe auf sinnvolle und korrekte Eingaben
  if (!"data.frame" %in% class(df) || length(df) != length(justify)) {
    stop("df muss ein data.frame sein und
      justify muss dieselbe Laenge haben wie df.\n")
  }

  if (!all(justify %in% c("l", "c", "r"))) {
    stop("In justify sind nur 'l', 'c' und 'r' erlaubt!\n")
  }

  titel <- NULL
  zeilen <- NULL

  for (j in 1:ncol(df)) {
    x <- df[[j]]

    # Temporaeres Objekt, das den Titel der aktuellen Spalte verwaltet
    titel.temp <- names(df)[j]

    if (is.numeric(x)) {
      # Nehme fuer alle Zahlen digits viele signifikannte Stellen.
      zeilen.temp <- format.signif(x, digits = digits)
    }
    else {
      # Vektor in character umwandeln
      # Eine Formatierung ist nicht mehr noetig, das macht dann LaTeX.
      zeilen.temp <- as.character(x)
    }

    if (!is.null(titel)) {
      # Trenne die Spalten mit &
      zeilen <- paste0(zeilen, " & ")
      titel <- paste0(titel, " & ")
    }

    # Inhalt anhaengen
    inhalt <- format(c(titel.temp, zeilen.temp),
      justify = ifelse(is.numeric(x), "right", "left"))
    titel <- paste0(titel, inhalt[1])
    zeilen <- paste0(zeilen, inhalt[-1])
  }

  # Feinschliff: Doppelter Backslash mit 4 Backslashes darstellen
  titel <- paste0(titel, " \\\\\n")
  zeilen <- paste0(zeilen, " \\\\\n")

  # Erste und letzte Zeile hinzufuegen
  justify.str <- paste0(justify, collapse = "")
  str.first <- paste0("\\begin{tabular}{", justify.str, "}\n")
  str.last <- "\\end{tabular}\n"

  return(paste0(c(str.first, titel, zeilen, str.last), collapse = ""))
}


# Testen unsere Funktion

# Name und Alter der herausgepickten Kinder
name <- c("Hugo", "Brigitte")
alter <- c(9, 10)

# Mische noch ein paar Gewichtsangaben hinzu. Um die Funktion zu testen,
# messen wir bei Hugo besonders genau ;-)
gewicht.kg <- c(38.57154, 34.5)   # in kg
gewicht.g <- gewicht.kg * 1000    # in g

df <- data.frame(Name = name, Alter = alter, "Gewicht_kg" = gewicht.kg,
  "Gewicht_g" = gewicht.g)
df


res <- createLatexTable(df, justify = c("r", "l", "c", "r"))
cat(res)

# Das Ergebnis koennen wir mit cat() nicht nur auf die Console drucken,
# sondern stattdessen auch in eine Datei schreiben (siehe naechstes
# Kapitel). Dann koennen wir in LaTeX diese Tabelle einfach mit
# dem \input-Befehl einbinden.



### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------


# Waehle ein "kreatives" Passwort
passwort <- "Passwort123"


# Muessen den Code innerhalb von drei Versuchen erraten.
versuch <- 0

while (TRUE) {
  cat("Geben Sie das richtige Passwort ein und druecken Sie ENTER:\n")
  
  # Passworteingabe
  versuch <- versuch + 1
  eingabe <- scan(what = "", n = 1)

  if (eingabe == passwort) {
    cat("Super, das Passwort ist korrekt!\n")
    break
  }
  else if (versuch <= 2) {
    vers.str <- ifelse(3 - versuch > 1, "Versuche", "Versuch")
    cat("Leider falsch! Sie haben noch", 3 - versuch, vers.str, "\n")
  }
  else {
    # Nach drei Versuchen ist Schluss!
    cat("Leider falsch! Sie haben keinen Versuch mehr, Karte gesperrt!\n")
    break
  }
}
MeinPasswort
Hugo
Lala

