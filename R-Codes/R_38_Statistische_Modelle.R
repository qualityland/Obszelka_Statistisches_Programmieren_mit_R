### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 38: Statistische Modelle
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 38.1  Lineare Regression -- lm(), formula
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 38.1.1  Einfache lineare Regression


lm(formula = log(einkommen) ~ alter, data = inc)
# Modell berechnen und Summary erzeugen
m1 <- lm(log(einkommen) ~ alter, data = inc)
summary(m1)
summary(m1)$coef  # coef als Abkürzung für coefficients


### -------------------------------------------------------------------------
### 38.1.2  Mehrere metrische unabhängige Variablen, Modellbildung


m2 <- lm(log(einkommen) ~ alter + log(einkommen_vorjahr), data = inc)
f <- paste0("y ~ ", paste0("x", 1:3, collapse = " * "))
f
as.formula(f)


### -------------------------------------------------------------------------
### 38.1.3  Kategorielle Variablen -- model.matrix(), contrasts()


m3 <- lm(log(einkommen) ~ bildung, data = inc)
coef(m3)
model.matrix(m3)[cumsum(c(0, 2 * m, 7 * m, 3 * m, 6 * m, 1 * m)) + 1, ]


### -------------------------------------------------------------------------
### 38.1.4  Modellselektion und Modelldiagnostik -- step(), anova()


anova(m1, m2)
anova(m2)

tmp <- lm(log10(einkommen) ~ alter, data = inc)       # Alter
c(tmp$coef[2], confint(tmp)[2, ])

tmp <- lm(log10(einkommen) ~ geschlecht, data = inc)  # Geschlecht
c(tmp$coef[2], confint(tmp)[2, ])

tmp <- lm(log10(einkommen) ~ bildung, data = inc)     # Bildung
cbind(Estimate = tmp$coef[2:3], confint(tmp)[2:3, ])

tmp <- lm(log10(einkommen) ~ alter * geschlecht, data = inc)
cbind(Estimate = tmp$coef[2:4], confint(tmp)[2:4, ])

inc$alter_c <- scale(inc$alter, scale = FALSE)
inc$geschlecht_r <- inc$geschlecht
contrasts(inc$geschlecht_r) <- c(-.5, .5)

m4 <- lm(log10(einkommen) ~ alter * geschlecht + bildung, data = inc)
cbind(Estimate = m4$coef[2:6], confint(m4)[2:6, ])

plot(m4)


### -------------------------------------------------------------------------
### 38.1.5  Zusatzbeispiel zur linearen Regression -- predict(), step()


n <- 150
RNGversion("4.0.2")
set.seed(2^31 - 1)
x <- runif(n, min = -3, max = 3)
gruppe <- sample(0:1, size = n, replace = TRUE)

y <- 2 + x + 5 * x^2 + 10 * (gruppe == 1) -
  10 * (gruppe == 1) * x + rnorm(n)

d <- data.frame(x, gruppe, y)
d <- d[order(d$x), ]

plot(d$x, d$y, col = d$gruppe + 1, pch = d$gruppe + 1,
  xlab = "x", ylab = "y")
legend("topright", legend = 0:1, title = "Gruppe", col = 1:2, pch = 1:2)

res.lm1 <- lm(y ~ 1, data = d)                       # Modell 1
coef(res.lm1)

mean(d$y)

res.lm2 <- lm(y ~ x, data = d)                       # Modell 2
coef(res.lm2)

res.lm3 <- lm(y ~ x + I(x^2), data = d)              # Modell 3
coef(res.lm3)

plot(d$x, d$y, col = d$gruppe + 1, pch = d$gruppe + 1,
  xlab = "x", ylab = "y")
legend("topright", legend = 0:1, title = "Gruppe", col = 1:2, pch = 1:2)

lines(d$x, predict(res.lm1), col = "black")
lines(d$x, predict(res.lm2), col = "green")
lines(d$x, predict(res.lm3), col = "blue")

legend("top", title = "Modell", legend = paste(1:3),
  col = c("black", "green", "blue"), lty = 1)

res.lm4 <- lm(y ~ gruppe + x + I(x^2), data = d)     # Modell 4
coef(res.lm4)
plot(d$x, d$y, col = d$gruppe + 1, pch = d$gruppe + 1,
  xlab = "x", ylab = "y")
legend("topright", legend = 0:1, title = "Gruppe", col = 1:2, pch = 1:2)
yhat4 <- predict(res.lm4)
for (i in 0:1) lines(d$x[d$gruppe == i], yhat4[d$gruppe == i], col = i + 1)

res.lm5 <- lm(y ~ gruppe * (x + I(x^2)), data = d)   # Modell 5
summary(res.lm5)$coef

res.lm6 <- lm(y ~ gruppe * x + I(x^2), data = d)     # Modell 6
coef(res.lm6)
plot(d$x, d$y, col = d$gruppe + 1, pch = d$gruppe + 1,
  xlab = "x", ylab = "y")
legend("topright", legend = 0:1, title = "Gruppe", col = 1:2, pch = 1:2)
yhat6 <- predict(res.lm6)
for (i in 0:1) lines(d$x[d$gruppe == i], yhat6[d$gruppe == i], col = i + 1)

res.step <- step(lm(y ~ (gruppe + x + I(x^2))^2, data = d), trace = 0)
coef(res.step)

res.step <- step(lm(y ~ gruppe * x * I(x^2), data = d), trace = 0)
coef(res.step)



### -------------------------------------------------------------------------
### 38.2  Weitere statistische Verfahren
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 38.2.2  Generalisierte lineare Modelle -- glm()


gm1 <- glm(einkommen > 2500 ~ alter + einkommen_vorjahr, data = inc,
       family = binomial)

summary(gm1)



### -------------------------------------------------------------------------
### 38.3  Abschluss
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 38.3.3  Übungen


formel <- as.formula("y ~ x1 + x1^2 + x2")
