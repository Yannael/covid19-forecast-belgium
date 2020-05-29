library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(rpivotTable)

ui <- navbarPage(
  "Explore:",
  
  tabPanel("Predictions",
           #sidebarLayout(
          #   sidebarPanel(
               selectInput("team_model", "Team-Model", sort(unique(all_data$team_model))),
               selectInput("resolution", "Resolution", sort(unique(all_data$unit))),
               selectInput("location", "Location", sort(unique(all_data$location))),
               selectInput("forecast_date", "Forecast date:", sort(unique(all_data$forecast_date)),max(all_data$forecast_date)),
           #  ), 
          #   mainPanel(
               plotlyOutput("prediction_plot")
             ),
           #)
 # ),
  
  tabPanel("Model accuracy comparison",
           rpivotTableOutput("rpivot_model_accuracy")),
           
  
  tabPanel("All",              
           DT::DTOutput("all_data")),
  
  tabPanel("Help",
           h3("Explore tabs"),
           h5("All: contains all of the processed data including those with missing required fields"),
           h5("Latest: subset of `All` that only contains the most recent forecast for each team-model"),
           h5("Latest targets: summarizes `Latest` to see which targets are included"),
           h5("Latest locations: summarizes `Latest` to see which locations are included"),
           h5("Latest quantiles: summarizes `Latest` to see which quantiles are included"),
           h3("Usage"),
           h4("Each table has the capability to be searched and filtered")
  )
)

