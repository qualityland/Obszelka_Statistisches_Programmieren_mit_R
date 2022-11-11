### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 37
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------


## Simulation der Einkommensdaten mit Hilfe der Funktion genderTest(), 
## der der Parameter genderEffekt übergeben werden kann

Gender_Test <- function(Gender_Effekt = -.25) {
  m <- 20
  n <- m * 20
  RNGversion("3.6.3")
  set.seed(4)
  inc <- data.frame(geschlecht = factor(rep(0:1, each = m * 10),
                                        labels = c("weiblich", "männlich")))
  inc$bildung <- factor(c(rep(0:2, c(2 * m, 5 * m, 3 * m)),
                          rep(0:2, c(3 * m, 6 * m, 1 * m))),
                        labels = c("niedrig", "mittel", "hoch"))
  inc$alter <- sample(20:64, size = n, replace = TRUE)
  inc$einkommen <- 10 ^ (
    Gender_Effekt * (inc$geschlecht == "männlich") +
      .005 * inc$alter +
      0.3 * (inc$bildung == "hoch") +
      .007 * inc$alter * (inc$geschlecht == "männlich") +
      rnorm(n, sd = .2) + 3
  )
  inc$einkommen_vorjahr <- 10 ^ (log10(inc$einkommen) +
                                   rnorm(n, mean = -.05, sd = .4))
  
  t.test(x = inc$einkommen[inc$geschlecht == "weiblich"], 
      y = inc$einkommen[inc$geschlecht == "männlich"])$p.value
  
}

## p-Wert für -.25 nachrechnen
Gender_Test()

## p-Werte für Effekte in der Umgebung von -.25 darstellen
Gender_Effekte <- seq(from = -.2, to = -.4, by = -.001)
pval <- sapply(Gender_Effekte, Gender_Test)
plot(Gender_Effekte, pval, type = "l")
abline(h=.05, v = -.25, col = 2)

## Effekte mit p-Werten unter 0.05 unter und oberhalb von -0.25 ermitteln
Gender_Effekte_unter <- Gender_Effekte[Gender_Effekte < -.25]
Gender_Effekte_ober <- Gender_Effekte[Gender_Effekte > -.25]

paste("Für Haupteffekte für Geschlecht größer als", 
      min(Gender_Effekte_ober[sapply(Gender_Effekte_ober, Gender_Test) < .05]),
      "und kleiner als",
      max(Gender_Effekte_unter[sapply(Gender_Effekte_unter, Gender_Test) < .05]),
      "regibt sich ein signifikanter Geschlechtseffekt")


### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------

CI_nicht_null <- numeric(1000)
pval <- numeric(1000)

for (i in 1:1000) 
{
  tmp <- t.test(rnorm(100))
  CI_nicht_null[i] <- sum(tmp$conf.int > 0) != 1
  pval[i] <- tmp$p.value
}

pval[CI_nicht_null == 1]

### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------

## Stichprobengröße und Simulationsdurchläufe
n <- 100 
runs <- 1000

## Parameter der Grunddaten
s <- 1
mu_1 <- 0
mu_2 <- 1

## Anzahl und Standardabweichung der Ausreißer
n_ausreisser <- 20 
sd_ausreisser <- 5

## Stichproben definieren
g <- factor(rep(0:1, each = n)) 
## Positionen der Ausreißer zufällig bestimmen
which_ausreisser <- c(sample(1:n, n_ausreisser), n + sample(1:n, n_ausreisser)) 

## Simulationsergebnisse werden im Objekt res gesammelt
res <- matrix(nrow = runs, ncol = 2, dimnames = list(1:runs, c("pval.par", "pval.npar")))

## Simulation durchführen
for (i in 1:runs) {
  y <- c(rnorm(n, mean = mu_1, sd = s), rnorm(n, mean = mu_2, sd = s))
  y[which_ausreisser] <- c(rnorm(n_ausreisser, mean = mu_1, sd = sd_ausreisser), 
                           rnorm(n_ausreisser, mean = mu_2, sd = sd_ausreisser))
  res[i, ] <- c(t.test(y ~ g)$p.value, wilcox.test(y ~ g)$p.value)
}

plot(-log10(res), xlab = "-log10 p-Wert paramaterisch", ylab = "-log10 p-Wert nicht paramaterisch", 
     xlim = c(0, max(-log10(res))), ylim = c(0, max(-log10(res))))
abline(a = 0, b = 1, col = 2)

## Signifikante Ergebnisse parametrisch vs nicht-parametrisch
table(res[, 1] < .05, res[, 2] <0.05) / runs


