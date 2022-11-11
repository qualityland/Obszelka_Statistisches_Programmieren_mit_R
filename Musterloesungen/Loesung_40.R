### -----------------------------------------------------------------------
### Statistisches Programmieren mit R
### Musterloesungen zu Kapitel 40
### -----------------------------------------------------------------------

### -----------------------------------------------------------------------
### Beispiel 1
### -----------------------------------------------------------------------

library(shiny)

ui <- fluidPage(
  titlePanel("Normalverteilungssimulation"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "N",
        label = "Stichprobengröße:",
        min = 10,
        max = 500,
        value = 100
      ),
      numericInput(
        inputId = "mean",
        label = "Mittelwert:",
        value = 0
      ),
      numericInput(
        inputId = "sd",
        label = "Standardabweichung:",
        value = 1
      ),
      checkboxInput("vert", "theoretische Verteilung einzeichnen?")
      
    ),
    
    mainPanel(tabsetPanel(
      tabPanel("Histogramm", plotOutput("hist")),
      tabPanel("Kerndichteschätzer", plotOutput("kern"))
    ))
  )
)

server <- function(input, output) {
  x <- reactive(rnorm(input$N, mean = input$mean, sd = input$sd))
  output$hist <- renderPlot({
    tmp <- hist(x(), plot = F)
    tmp.seq <-
      seq(tmp$breaks[1], rev(tmp$breaks)[1], length.out = 1000)
    tmp.dens <- dnorm(tmp.seq, input$mean, input$sd)
    hist(
      x(),
      main = "",
      xlab = "",
      ylab = "Dichte",
      ylim = c(0, max(c(
        tmp$density, tmp.dens
      ))),
      freq = FALSE
    )
    if (input$vert)
      lines(tmp.seq, tmp.dens, col = 2)
  })
  output$kern <- renderPlot({
    tmp <- density(x())
    tmp.seq <- seq(tmp$x[1], rev(tmp$x)[1], length.out = 1000)
    tmp.dens <- dnorm(tmp.seq, input$mean, input$sd)
    plot(
      density(x()),
      main = "",
      xlab = "",
      ylab = "Dichte",
      ylim = c(0, max(c(tmp$y, tmp.dens))),
      bty = "l"
    )
    if (input$vert)
      lines(tmp.seq, tmp.dens, col = 2)
  })
}

shinyApp(ui = ui, server = server)


### -----------------------------------------------------------------------
### Beispiel 2
### -----------------------------------------------------------------------

## Aufbauend auf die 2. Version der Shiny-App aus (40.4.2):
## Als Input abhängiges User Inteface Element wird die Eingabe des Ausreißer-Anteils eingebaut, wenn 
## die Ausreißer-Checkbox aktiv ist.

library(shiny)

ui <- fluidPage(
  titlePanel("Normalverteilungssimulation"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "N",
        label = "Stichprobengroesse:",
        min = 10,
        max = 500,
        value = 100
      ),
      numericInput(
        inputId = "mean",
        label = "Mittelwert:",
        value = 0
      ),
      numericInput(
        inputId = "sd",
        label = "Standardabweichung:",
        value = 1
      ),
      checkboxInput("outlier", "Ausreißer simulieren"),
      uiOutput("outlier_anteil")
    ),
    
    mainPanel(tabsetPanel(
      tabPanel("Histogramm", plotOutput("hist")),
      tabPanel("Kerndichteschätzer", plotOutput("kern"))
    ))
  )
)

server <- function(input, output) {
  x <- reactive({
    tmp <- rnorm(input$N, mean = input$mean, sd = input$sd)
    outlier_ind <-
      sample(1:input$N, size = max(1, round(input$N * input$outlierAnteil)))
    if (input$outlier)
      tmp[outlier_ind] <-
      rnorm(length(outlier_ind),
            mean = input$mean,
            sd = 5 * input$sd)
    return(tmp)
  })
  output$hist <- renderPlot(hist(
    x(),
    main = "",
    xlab = "",
    ylab = "Dichte",
    freq = FALSE
  ))
  output$kern <-
    renderPlot(plot(
      density(x()),
      main = "",
      xlab = "",
      ylab = "Dichte",
      bty = "l"
    ))
  output$outlier_anteil <- renderUI({
    if (input$outlier)
      sliderInput(
        inputId = "outlierAnteil",
        label = "Anteil Ausreißer:",
        min = 0,
        max = .1,
        value = .01
      )
  })
}

shinyApp(ui = ui, server = server)

### -----------------------------------------------------------------------
### Beispiel 3
### -----------------------------------------------------------------------

## Aufbauend auf die 1. Version der Shiny-App
## checkboxGroupedInput für 3 theoretische Verteilungen

library(shiny)

ui <- fluidPage(
  titlePanel("Normalverteilungssimulation"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "N",
        label = "Stichprobengröe:",
        min = 10,
        max = 500,
        value = 100
      ),
      numericInput(
        inputId = "mean",
        label = "Mittelwert:",
        value = 0
      ),
      numericInput(
        inputId = "sd",
        label = "Standardabweichung:",
        value = 1
      ),
      checkboxGroupInput(
        inputId = "verteilungen", 
        label = "Verteilungen einzeichnen:",
        choices = c("der Simulation entsprechend (rot)" = "SD1", 
                    "doppelte Standardabweichung (grün)" = "SD2",
                    "dreifache Standardabweichung (blau)" = "SD3"))
    ),
    mainPanel(plotOutput("hist"))
  )
)

server <- function(input, output) {
  x <- reactive(rnorm(input$N, mean = input$mean, sd = input$sd))
  output$hist <- renderPlot({
    tmp <- hist(x(), plot = F)
    tmp.seq <- seq(tmp$breaks[1], rev(tmp$breaks)[1], length.out = 1000)
    tmp.vert <- matrix(nrow = length(tmp.seq), ncol = 3, dimnames = list(1:length(tmp.seq), c("SD1", "SD2", "SD3")))
    for (i in 1:3)
      tmp.vert[, paste0("SD", i)] <- dnorm(tmp.seq, input$mean, input$sd * i)
    hist(
      x(),
      main = "",
      xlab = "",
      ylab = "Dichte",
      ylim = c(0, max(c(tmp$density, tmp.vert))),
      freq = FALSE
    )
    for (i in input$verteilungen)
      lines(tmp.seq, tmp.vert[, i], col = as.numeric(substring(i, 3, 3)) + 1)
  })
}

shinyApp(ui = ui, server = server)

### -----------------------------------------------------------------------
### Beispiel 4
### -----------------------------------------------------------------------

## In der 1. Version der Shiny-App wird statt titlePanel() eine h1- Überschrift eingebaut 

library(shiny)

ui <- fluidPage(h1("Normalverteilungssimulation"),
                sidebarLayout(
                  sidebarPanel(
                    sliderInput(
                      inputId = "N",
                      label = "Stichprobengröe:",
                      min = 10,
                      max = 500,
                      value = 100
                    ),
                    numericInput(
                      inputId = "mean",
                      label = "Mittelwert:",
                      value = 0
                    ),
                    numericInput(
                      inputId = "sd",
                      label = "Standardabweichung:",
                      value = 1
                    )
                  ),
                  mainPanel(plotOutput("hist"))
                ))

server <- function(input, output) {
  output$hist <- renderPlot({
    x <- rnorm(input$N, mean = input$mean, sd = input$sd)
    hist(
      x,
      main = "",
      xlab = "",
      ylab = "Dichte",
      freq = FALSE
    )
  })
}

shinyApp(ui = ui, server = server)