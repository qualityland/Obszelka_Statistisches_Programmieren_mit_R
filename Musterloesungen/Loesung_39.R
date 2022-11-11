### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 39
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


## a-c
<<echo=TRUE, comment=NA, background='#FFFFFF'>>=

## d-e
\documentclass{article}
\begin{document}

\section{Mittelwertsberechnung}  

Der Mittelwert aus 200 standardnormalverteilten Zufallsvariablen beträgt:

<<echo=TRUE, comment=NA, background='#FFFFFF', fig.cap='Histogramm fuer 200 standardnormalverteilte Zufallszahlen', fig.height=4>>=
x <- rnorm(200)
round(mean(x), 2)
hist(x)
@

Die Standardabweichung lautet \Sexpr{round(sd(x), 1)}.

\end{document}


### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------

## a
## Figure Captions und Chunk-Hintergrundfarbe können in Rhtml nicht vergeben werden.

<html>
  <body>
  
  <h1>Mittelwertsberechnung</h1>
  
  Der Mittelwert aus 200 standardnormalverteilten Zufallsvariablen beträgt:
  
  <!--begin.rcode echo=TRUE, comment=NA, fig.height=4
x <- rnorm(200)
round(mean(x), 2)
hist(x)
end.rcode-->
  
  
  Die Standardabweichung lautet <!--rinline round(sd(x), 1) -->.

</body>
  </html>


## b
---
  output: pdf_document
---
  
# Mittelwertsberechnung
  
Der Mittelwert aus 200 standardnormalverteilten Zufallsvariablen beträgt:
  
```{r echo=TRUE, comment=NA, fig.cap='Histogramm fuer 200 standardnormalverteilte Zufallszahlen', fig.height=4}
x <- rnorm(200)
round(mean(x), 2)
hist(x)
```

Die Standardabweichung lautet `r round(sd(x), 1)`.

## Die Graufärbung des Hintergrunds der Code-Chunks kann in Markdown über HTML (CSS) und class.source erzielt werden, 
## lässt sich aber nur für ein HTML Outputfile realisieren


---
  output: html_document
  title: beispiel
---
  
```{css, echo=FALSE}
.mystyle {
  background-color: #FFFFFF;
}
```

# Mittelwertsberechnung

Der Mittelwert aus 200 standardnormalverteilten Zufallsvariablen beträgt:
  
```{r echo=TRUE, comment=NA, fig.cap='Histogramm fuer 200 standardnormalverteilte Zufallszahlen', fig.height=4, class.source="mystyle"}
x <- rnorm(200)
round(mean(x), 2)
hist(x)
```

Die Standardabweichung lautet `r round(sd(x), 1)`.



### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------

s <- c(1, sample(2:10))
for(i in 1:10)
  cat("f", s[i], " <- function(x) if (x < 0) stop('x kleiner 0') else
      f", s[i + 1], "(sqrt(x) - rnorm(1, .5))\n",
      sep = "", file = "tmp", append = TRUE)
source("tmp")
unlink("tmp")

## a)
ls()

## b)
## source(tmp) liest den Code aus der Datei tmp, wandelt den Text in eine expression um (parse) und führt diese aus.

## c)
## Der Fehler tritt bei unterschiedlichen Funktionsaufrufen auf, 
## da die Zufallszahlen in rnorm(1, 0.5) für jeden Aufruf von f(x =1) variieren.

## d - f)

## mit traceback()
traceback()
## Output von traceback zeigt, dass zuerst f6() aufgerufen wurde, dann f4(), wo der Fehler auftrat.
4: stop("x kleiner 0") at tmp#5
3: f4(sqrt(x) - rnorm(1, 0.5)) at tmp#3
2: f6(sqrt(x) - rnorm(1, 0.5)) at tmp#1
1: f1(x = 1)


## mit debug()
debug(f1)
f1(x = 1)
undebug()
## debug() hilft uns für die Fehleranalyse des verschachtelten Funktionsaufrufs nur wenig, 
## da Breaktpoints nur innerhalb der Funktion f1() gesetzt werden.

## mit recover()
old <- getOption("error")
options(error = recover)
f1(x = 1)
## nun muss die "frame number" eingegeben werden, anschließend kann der Wert von x ausgegeben werden (Aufgabe f). 
## Mit der Eingabe c kehren wir zum Menü zurück, mit "0" verlassen wir es.

## Am Ende muss der Wert der Option "error" wird zurückgesetzt werden.
options(error = old)

## g)
## Der semantische Fehler betrifft die letzte Funktion in tmp. Das letzte Element des Vektors s hilft, die Funktion zu bestimmen.
## Hier gibt es keine i+1. Funktion und somit lautet diese Funktion fälschlicherweise fNA().
## Der Fehler wird aber selten sichtbar, da der Fehler (x < 0) sehr selten bei der letzten Funktion auftritt.

