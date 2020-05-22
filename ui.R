library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

ui <- navbarPage(
  "Explore:",
  

  tabPanel("Latest Viz",
           sidebarLayout(
             sidebarPanel(
               selectInput("team",         "Team", sort(unique(latest_plot_data$team         )), "YGG"),
               selectInput("model",       "Model", sort(unique(latest_plot_data$model        ))),
               selectInput("target",     "Target", sort(unique(latest_plot_data$simple_target))),
               selectInput("location", "Location", sort(unique(latest_plot_data$location   )))
             ), 
             mainPanel(
               plotOutput("latest_plot")
             )
           )
  ),
  
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

