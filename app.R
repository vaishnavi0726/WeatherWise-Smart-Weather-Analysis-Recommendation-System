# ================================================
# WeatherWise - Web version (Shiny)
# File : app.R
# ================================================
library(shiny)

source("modules/module1_analyzer.R")
source("modules/module2_recommend.R")
source("modules/module3_factorial.R")
source("modules/module4_converter.R")
source("modules/module5_area.R")

ui <- fluidPage(
  titlePanel("WeatherWise - Smart Weather Analysis & Recommendation System"),
  tabsetPanel(
    tabPanel("Analyze Weather Data",
             br(),
             selectInput("column", "Choose a column:", choices = c("Temperature", "Humidity", "Rainfall")),
             tableOutput("even_odd_table"),
             textOutput("even_odd_summary")
    ),
    tabPanel("Weather Recommendation",
             br(),
             numericInput("temp", "Temperature (C):", value = 30),
             radioButtons("rain", "Is it raining?", choices = c("no", "yes"), inline = TRUE),
             actionButton("go_weather", "Get Recommendation"),
             br(), br(),
             verbatimTextOutput("weather_result")
    ),
    tabPanel("Factorial",
             br(),
             numericInput("fact_n", "Enter a whole number (0 to 20):", value = 5),
             actionButton("go_fact", "Calculate"),
             br(), br(),
             textOutput("fact_result")
    ),
    tabPanel("Celsius to Fahrenheit",
             br(),
             numericInput("celsius", "Temperature in Celsius:", value = 37),
             actionButton("go_convert", "Convert"),
             br(), br(),
             textOutput("convert_result")
    ),
    tabPanel("Rectangle Area",
             br(),
             numericInput("rect_length", "Length:", value = 8),
             numericInput("rect_width", "Width:", value = 5),
             actionButton("go_area", "Calculate Area"),
             br(), br(),
             textOutput("area_result")
    )
  )
)

server <- function(input, output) {
  weather_data <- reactive({
    validate(need(file.exists("data/weather.csv"), "Error: data/weather.csv not found."))
    read.csv("data/weather.csv")
  })
  selected_values <- reactive({
    df <- weather_data()
    validate(need(input$column %in% names(df), "Column not found."))
    validate(need(is.numeric(df[[input$column]]), "Non-numeric data."))
    df[[input$column]]
  })
  output$even_odd_table <- renderTable({
    values <- selected_values()
    data.frame(Day = weather_data()$Day, Value = values, Result = check_even_odd(values))
  })
  output$even_odd_summary <- renderText({
    values <- selected_values()
    results <- check_even_odd(values)
    paste("Even:", sum(results == "Even"), "| Odd:", sum(results == "Odd"), "| Average:", round(mean(values, na.rm = TRUE), 2))
  })
  weather_result <- eventReactive(input$go_weather, {
    validate(need(!is.na(input$temp), "Please enter a valid temperature."))
    validate(need(input$temp >= -50 && input$temp <= 60, "Temperature must be between -50 and 60 C."))
    r <- get_weather_advice(input$temp, input$rain)
    paste0("Weather Type : ", r$type, "\nAdvice : ", r$advice, "\nRain Advice : ", r$rain_advice)
  })
  output$weather_result <- renderText({ weather_result() })
  fact_result <- eventReactive(input$go_fact, {
    n <- input$fact_n
    validate(need(!is.na(n) && n >= 0 && n == floor(n) && n <= 20, "Please enter a whole number between 0 and 20."))
    paste("Factorial of", n, "is", format(calculate_factorial(n), big.mark = ",", scientific = FALSE))
  })
  output$fact_result <- renderText({ fact_result() })
  convert_result <- eventReactive(input$go_convert, {
    celsius <- input$celsius
    validate(need(!is.na(celsius), "Please enter a valid number."))
    validate(need(celsius >= -273.15, "Temperature cannot be below absolute zero (-273.15 C)."))
    paste(celsius, "C =", celsius_to_fahrenheit(celsius), "F")
  })
  output$convert_result <- renderText({ convert_result() })
  area_result <- eventReactive(input$go_area, {
    l <- input$rect_length
    w <- input$rect_width
    validate(need(!is.na(l) &&!is.na(w) && l > 0 && w > 0, "Length and width must be positive numbers."))
    paste("Area of the rectangle =", rectangle_area(l, w), "square units")
  })
  output$area_result <- renderText({ area_result() })
}
shinyApp(ui = ui, server = server)