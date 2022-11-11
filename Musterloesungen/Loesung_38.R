### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 38
### -----------------------------------------------------------------------



### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------

## Ergebnisse der Simulation sammeln
res <- matrix(nrow = 1000, ncol = 3)
colnames(res) <- c("Koeff", "pval_t", "pval_f")
for (i in 1:1000) 
{
  y <- rnorm(100)
  x <- rnorm(100)
  res[i, 1:2] <- summary(lm( y~ x))$coef[2, c(1, 4)]
  tmp <- summary(lm( y~ x))$fstatistic
  res[i, 3] <- 1 - pf(tmp[1], tmp[2], tmp[3])
}

## a
plot(res[, "Koeff"], -log10(res[, "pval_t"]), xlab = "Koeffizient", ylab = "-log10(P)")

## b
mean(res[, "pval_f"] < 0.05)

## Im Fall der Einfachregression ist der p-Wert des t-Tests f?r den Koeffizienten 
## ident mit dem p-Wert aus dem Overall F-Test.
all.equal(res[, "pval_t"], res[, "pval_f"])


### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------

set.seed(7)
n <- 100
x1 <- rnorm(n, mean = 10)
x2 <- 2 + .5 * x1 + rnorm(n, sd = .2)
y <- 3 + .3 * x1 + .7 * x2 + rnorm(n, sd = .5)


## a
coef(summary(lm(y ~ x1)))
coef(summary(lm(y ~ x2)))
coef(summary(lm(y ~ x1 + x2)))

## Der Schätzer für x1 in der Einfachregression y~x1 ist verzerrt, wenn eine Variable x2 existiert, 
## die sowohl mit y als auch mit x1 korreliert ist. 
## Die Verzerrung nennt man Omitted variable Bias.

## b
coef(summary(lm(y ~ x1 + x2)))
coef(summary(lm(y ~ x1 * x2)))

## Die Interpretation der Haupteffekte ändert sich, wenn eine Wechselwirkung ins Modell inkludiert wird. 
## Der Haupteffekt von x1 wird zum Effekt für x2 = 0 und umgekehrt.

## c
coef(summary(lm(y ~ x1 * x2)))
coef(summary(lm(y ~ scale(x1, scale= F) * scale(x2, scale= F))))

## Nun ändern sich die Schätzer der Haupteffekte kaum, 
## wenn die Wechselwirkung im Modell inkludiert wird.
## Vergleiche:
coef(summary(lm(y ~ scale(x1, scale= F) * scale(x2, scale= F))))


### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------

## a
## i und iii (das volle Modelle)
## ii und iv (x2 ist genestet in x1)
## v und vi (das additive Modell)

## b
## Die richtige Definition lautet:
## formel <- as.formula("y ~ x1 + I(x1^2) + x2")

