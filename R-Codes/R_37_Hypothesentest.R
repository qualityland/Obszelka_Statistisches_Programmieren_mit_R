### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 37: Verteilungstests und Hypothesentests
### -------------------------------------------------------------------------


# Anzahlen und Zufallszahlengenerator einstellen
m <- 20              # Bildungsstufen in Blöcken der Grösse m
n <- m * 20          # Gesamtanzahl der Personen
RNGversion("4.0.2")
set.seed(4)

# Datensatz generieren
inc <- data.frame(geschlecht = factor(rep(0:1, each = m * 10),
                                      labels = c("weiblich", "männlich")))
inc$bildung <- factor(c(rep(0:2, c(2 * m, 5 * m, 3 * m)),
                        rep(0:2, c(3 * m, 6 * m, 1 * m))),
                      labels = c("niedrig", "mittel", "hoch"))
inc$alter <- sample(20:64, size = n, replace = TRUE)
inc$einkommen <- 10^(-0.25  * (inc$geschlecht == "männlich") +
                      0.005 *  inc$alter +
                      0.3   * (inc$bildung == "hoch") +
                      0.007 *  inc$alter * (inc$geschlecht == "männlich") +
                              rnorm(n, sd = .2) + 3)
inc$einkommen_vorjahr <- 10^(log10(inc$einkommen) +
                             rnorm(n, mean = -.05, sd = .4))

head(inc)
str(inc, vec.len = 2)



### -------------------------------------------------------------------------
### 37.1  Verteilungstests
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 37.1.1  Histogramme mit Anpassungslinie -- hist()


# Histogramm mit Verteilungskurve zeichnen
x <- seq(0, max(inc$einkommen), by = 1)
y <- dlnorm(x, mean(log(inc$einkommen)), sd(log(inc$einkommen)))
hist(inc$einkommen, freq = FALSE, yaxt = "n", main = "", ylab = "",
     xlab = "Einkommen", ylim = c(0, max(y)))
lines(x, y, col = 2)

# Mittelwert und Logarithmieren
mean(inc$einkommen)
exp(mean(log(inc$einkommen)))

library(psych)
psych::geometric.mean(inc$einkommen)
median(inc$einkommen)


### -------------------------------------------------------------------------
### 37.1.2  Quantil-Quantil-Plot -- qqplot(), qqline(), qqPlot()


# QQ-Plot und QQ-Linie durch 1. und 3. Quartil zeichnen
qqplot(qlnorm(ppoints(nrow(inc)), mean = mean(log(inc$einkommen)),
              sd = sd(log(inc$einkommen))), inc$einkommen,
       xlab = "theoretisches Quantil der Log-Normalverteilung",
       ylab = "Einkommen")
qqline(inc$einkommen, distribution = function(p) 
qlnorm(p, mean(log(inc$einkommen)), sd(log(inc$einkommen))), col = 2)

library(car)

car::qqPlot(inc$einkommen, "lnorm", mean = mean(log(inc$einkommen)),
            sd = sd(log(inc$einkommen)), ylab = "Einkommen", 
            xlab = "theoretisches Quantil der Log-Normalverteilung", 
            col.lines = 2, lwd = 1)
car::qqPlot(log(inc$einkommen), "norm", ylab = "logarithmiertes Einkommen", 
            col.lines = 2, lwd = 1,
            xlab = "theoretisches Quantil der Normalverteilung")


### -------------------------------------------------------------------------
### 37.1.3  Kolmogorov-Smirnov-Test -- ks.test(), LcKS()


# Standardfunktion
ks.test(inc$einkommen, "plnorm", mean(log(inc$einkommen)), 
        sd(log(inc$einkommen)))

# Korrigierte Version
library(KScorrect)

KScorrect::LcKS(inc$einkommen, "plnorm", nreps = 1000)$p.value



### -------------------------------------------------------------------------
### 37.2  Hypothesentests für kategorielle Merkmale
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 37.2.1  Binomialtest -- binom.test()


# Binomialtest durchführen
inc$weiblich <- inc$geschlecht == "weiblich"
binom.test(x = sum(inc$einkommen[inc$weiblich] > 2500), 
           n = sum(inc$weiblich), p = 0.5)


### -------------------------------------------------------------------------
### 37.2.3  Tests für Anteilswerte -- prop.test()


einkommen_gt_2500 <- tapply(inc$einkommen > 2500, inc$geschlecht, sum)
einkommen_gt_2500

# Anteilstest durchführen
prop.test(x = einkommen_gt_2500, 
          n = table(inc$geschlecht), correct = FALSE, alternative = "less")


### -------------------------------------------------------------------------
### 37.2.4  McNemar-Test -- mcnemar.test()


# 1.) 2 x 2 Tabelle bilden
einkommen_vgl <- table(inc$einkommen_vorjahr > 2500, inc$einkommen > 2500)
dimnames(einkommen_vgl) <- list("Einkommen Vorjahr" = c("<=2500", ">2500"),
                                "Einkommen aktuell" = c("<=2500", ">2500"))
einkommen_vgl

# 2.) McNemar-Test durchführen
mcnemar.test(x = einkommen_vgl)


### -------------------------------------------------------------------------
### 37.2.5  \texorpdfstring{$\chi^2$-Test}{X2-Test} -- chisq.test()


# Chi-Quadrat-Test durchführen
res <- chisq.test(x = inc$bildung, y = inc$einkommen > 2500)
res$observed

res$residuals
res$expected

res$stdres



### -------------------------------------------------------------------------
### 37.3  Hypothesentests für metrische Merkmale
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 37.3.1  Test für Korrelationskoeffizienten -- cor.test()


library(car)
car::dataEllipse(x = as.matrix(inc[, c("einkommen_vorjahr", "einkommen")]),
                 level = .95)    # mit originalen Daten
car::dataEllipse(x = log(as.matrix(
                     inc[, c("einkommen_vorjahr", "einkommen")])),
                 xlab = "log(einkommen_vorjahr)", ylab = "log(einkommen)", 
                 level = .95)    # mit logarithmierten Daten

cor.test(log(inc$einkommen), log(inc$einkommen_vorjahr))
cor.test(inc$einkommen, inc$einkommen_vorjahr, method = "spearman")


### -------------------------------------------------------------------------
### 37.3.2  t-Test für eine und zwei Stichproben -- t.test()


# t-Test für eine Stichprobe rechnen
t.test(inc$einkommen, mu = 2500)

# t-Test für zwei gepaarte Stichproben rechnen
t.test(inc$einkommen, inc$einkommen_vorjahr, paired = TRUE)
t.test(log(inc$einkommen), log(inc$einkommen_vorjahr), paired = TRUE)

# t-Test für zwei unabhängige Stichproben rechnen
inc$weiblich <- inc$geschlecht == "weiblich"
t.test(x = inc$einkommen[inc$weiblich], y = inc$einkommen[!inc$weiblich])
t.test(einkommen ~ geschlecht, data = inc)        # t.test.formula()



### -------------------------------------------------------------------------
### 37.4  Nichtparametrische Hypothesentests -- wilcox.test()
### -------------------------------------------------------------------------


# Wilcoxon-Test für eine Stichprobe rechnen
wilcox.test(inc$einkommen, mu = 2500)

# Wilcoxon-Test für zwei gepaarte Stichproben rechnen
wilcox.test(inc$einkommen, inc$einkommen_vorjahr, paired = TRUE)

# Mann-Whitney-U-Test rechnen
inc$weiblich <- inc$geschlecht == "weiblich"
wilcox.test(x = inc$einkommen[inc$weiblich], y = inc$einkommen[!inc$weiblich])
wilcox.test(einkommen ~ geschlecht, data = inc)   # wilcox.test.formula()
