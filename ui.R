library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(rpivotTable)

ui <- navbarPage(
  "Explore:",
  
  tabPanel("Predictions",
               selectInput("team_model", "Team-Model", sort(unique(all_data$team_model))),
               selectInput("resolution", "Resolution", sort(unique(all_data$unit))),
               selectInput("location", "Location", sort(unique(all_data$location))),
               selectInput("forecast_date", "Forecast date:", sort(unique(all_data$forecast_date)),max(all_data$forecast_date)),
               plotlyOutput("prediction_plot")
             ),

  tabPanel("Model accuracy comparison",
           rpivotTableOutput("rpivot_model_accuracy")),
           
  tabPanel("All",              
           DT::DTOutput("all_data")),
  
  tabPanel("Help",
           h3("Explore tabs"),
           h5("Predictions: Visualise predictions for the different forecasting models"),
           h5("Model accuracy comparison: Compares model prediction accuracy thanks to a pivot table"),
           h5("All: contains all of the forecast data")
  )
)

