library(DT)

server <- function(input, output, session) {
  
  
  #############################################################################
  # Visualization: Filter data based on user input
  
  data_f     <- reactive({ all_data %>% filter(forecast_date == input$forecast_date) })
  data_ft    <- reactive({ data_f() %>% filter(team_model == input$team_model) })
  data_ftmt  <- reactive({ data_ft() %>% filter(unit == input$resolution) })
  data_ftmtl <- reactive({ data_ftmt() %>% filter(location == input$location) })
  
  truth_plot <- reactive({ 
    truth %>% 
      filter(location == input$location,
             unit == input$resolution)
  })
  
  output$prediction_plot <- renderPlotly({
    
    xaxis <- list(
      title = 'Date',
      titlefont = list(size=15)
    )
    
    yaxis <- list(
      title = 'Mortality',
      titlefont = list(size=15)
    )
    
    m <- list(l=100, r=20, b=100, t=100)
    
    graph_title <- paste0('Mortality per day and predictions for the next 4 weeks. \n Model : ',input$team_model,sep="")
    
    d    <- data_ftmtl()
    
    if (NROW(d)>0) {
    
    fig <- plot_ly()
    
    fig <- fig %>% add_lines(x = truth_plot()$date, y = truth_plot()$value,
                             color = I("Green"), name = "Observed")
    
    fig <- fig %>% add_lines(x = d$target_end_date, y = d$point, color = I("blue"), name = "Prediction")
    
    fig <- fig %>% add_ribbons(x = d$target_end_date, ymin = d$`0.025`, d$`0.975`,
                               color = I("gray80"), name = "95% confidence")
    
    fig <- fig %>% layout(title = graph_title, xaxis = xaxis, yaxis = yaxis, margin = m)
    
    fig$elementId <- NULL
    
    fig
    }
    
  })
  
  output$all_data <- DT::renderDT(all_data, filter = "top")
}
