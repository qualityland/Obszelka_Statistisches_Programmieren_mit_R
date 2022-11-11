### -------------------------------------------------------------------------
### Statistisches Programmieren mit R
### Daniel Obszelka und Andreas Baierl
### Kapitel 40: Interaktive Webanwendungen mit Shiny
### -------------------------------------------------------------------------



### -------------------------------------------------------------------------
### 40.1  Grundlegendes zur Programmierung einer Shiny-Anwendung
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 40.1.1  Struktur einer Shiny-Anwendung


library(shiny)
ui <- fluidPage()
server <- function(input, output){}
shinyApp(ui = ui, server = server)


### -------------------------------------------------------------------------
### 40.1.2  Bereitstellung einer Shiny-Anwendung}\label{sec:ShinyDeploy


setAccountInfo(name, token, secret)

deployApp(appDir)



### -------------------------------------------------------------------------
### 40.2  Serverfunktion und Render-Funktionen
### -------------------------------------------------------------------------


server <- function(input, output){}

server <- function(input, output) {
  output$p1 <- renderPlot(hist(rnorm(10)))
}

server <- function(input, output) {
  output$p1 <- renderPlot({
    x <- rnorm(10)
    hist(x)})
}

server <- function(input, output) {
  x <- reactive(rnorm(10))
	output$plot1 <- renderPlot(hist(x()))
  output$plot2 <- renderPlot(plot(x()))
}



### -------------------------------------------------------------------------
### 40.3  User Interface Objekt (UI)
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 40.3.1  Layout


ui <- fluidPage(
  fluidRow(
    column(4, "Inhalte"),
    column(8, "Inhalte")))

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel("Inhalte"),
    mainPanel("Inhalte")))

ui <- fluidPage(
  navbarPage(title = "Titel",
  tabPanel("Unterseite 1", "Inhalt"),
  tabPanel("Unterseite 2", "Inhalt")))


### -------------------------------------------------------------------------
### 40.3.2  Input- und Outputfunktionen


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput(
      inputId = "x",
      label = "Stichprobengröße:",
      min = 10,
      max = 500,
      value = 100)),
    mainPanel("Inhalte")))



### -------------------------------------------------------------------------
### 40.4  Shiny-Beispiel: Darstellung einer Normalverteilungsstichprobe
### -------------------------------------------------------------------------


### -------------------------------------------------------------------------
### 40.4.1  Version 1: sidebarLayout


# Paket shiny laden
library(shiny)

ui <- fluidPage(
    titlePanel("Normalverteilungssimulation"),
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "N",
                        label = "Stichprobengröße:",
                        min = 10,
                        max = 500,
                        value = 100),
            numericInput(inputId = "mean",
                         label = "Mittelwert:",
                         value = 0),
            numericInput(inputId = "sd",
                         label = "Standardabweichung:",
                         value = 1)),
        mainPanel(
            plotOutput("hist"))
    )
)

server <- function(input, output) {
    output$hist <- renderPlot({
        x <- rnorm(input$N, mean = input$mean, sd = input$sd)
        hist(x, main = "", xlab = "", ylab = "Dichte", freq = FALSE)
    })
}

shinyApp(ui = ui, server = server)


### -------------------------------------------------------------------------
### 40.4.2  Version 2: sidebarLayout mit Unterseiten


# Paket shiny laden
library(shiny)

ui <- fluidPage(
    titlePanel("Normalverteilungssimulation"),
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "N",
                        label = "Stichprobengröße:",
                        min = 10,
                        max = 500,
                        value = 100),
            numericInput(inputId = "mean",
                         label = "Mittelwert:",
                         value = 0),
            numericInput(inputId = "sd",
                         label = "Standardabweichung:",
                         value = 1)),
        mainPanel(
            tabsetPanel(
                tabPanel("Histogramm", plotOutput("hist")),
                tabPanel("Kerndichteschätzer", plotOutput("kern"))))
    )
)

server <- function(input, output) {
    x <- reactive(rnorm(input$N, mean = input$mean, sd = input$sd))
    output$hist <- renderPlot(hist(x(), main = "", xlab = "",
                              ylab = "Dichte", freq = FALSE))
    output$kern <- renderPlot(plot(density(x()), main = "", xlab = "",
                                   ylab = "Dichte", bty= "l"))
}

shinyApp(ui = ui, server = server)
