library(DT)

server <- function(input, output, session) {
  
  
  #############################################################################
  # Latest viz: Filter data based on user input
  
  latest_t    <- reactive({ latest_plot_data %>% filter(team          == input$team) })
  latest_tm   <- reactive({ latest_t()       %>% filter(model         == input$model) })
  latest_tmt  <- reactive({ latest_tm()      %>% filter(simple_target == input$target) })
  latest_tmtl <- reactive({ latest_tmt()     %>% filter(location    == input$location) })
  
  truth_plot <- reactive({ 
    input_simple_target <- unique(paste(
      latest_tmtl()$unit, "ahead", latest_tmtl()$inc_cum, latest_tmtl()$death_cases))
    
    truth %>% 
      filter(location == input$location,
             grepl(input_simple_target, simple_target))
  })
  
  observe({
    models <- sort(unique(latest_t()$model))
    updateSelectInput(session, "model", choices = models, selected = models[1])
  })
  
  observe({
    targets <- sort(unique(latest_tm()$simple_target))
    updateSelectInput(session, "target", choices = targets, selected = targets[1])
  })
  
  observe({
    locations <- sort(unique(latest_tmt()$location))
    updateSelectInput(session, "location", choices = locations)#, 
                      #selected = ifelse(any("US" == locations), "US", locations[1]))
  })
  
  output$latest_plot      <- shiny::renderPlot({
    d    <- latest_tmtl()
    team <- unique(d$team)
    model <- unique(d$model)
    forecast_date <- unique(d$forecast_date)
    
    ggplot(d, aes(x = target_end_date)) + 
      geom_ribbon(aes(ymin = `0.025`, ymax = `0.975`, fill = "95%")) +
      #geom_ribbon(aes(ymin = `0.25`, ymax = `0.75`, fill = "50%")) +
      scale_fill_manual(name = "", values = c("95%" = "lightgray", "50%" = "gray")) +
      
      #geom_point(aes(y=`0.5`, color = "median")) + geom_line( aes(y=`0.5`, color = "median")) + 
      geom_point(aes(y=point, color = "point")) + geom_line( aes(y=point, color = "point")) + 
      scale_color_manual(name = "", values = c("median" = "slategray", "point" = "black")) +
      
      geom_line(data = truth_plot(), aes(x = date, y = value), color = "green") + 
      
      labs(y="value", title = forecast_date) +
      theme_bw() +
      theme(plot.title = element_text(color = ifelse(Sys.Date() - forecast_date > 6, "red", "black")))
  })
  
  output$all_data <- DT::renderDT(all_data, filter = "top")
}
