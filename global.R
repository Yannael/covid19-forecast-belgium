# Provides a shiny dashboard to explore the processed data

# From https://github.com/reichlab/covid19-forecast-hub 

library("tidyverse")
library("shiny")
library("DT")
library("rmarkdown")
library("MMWRweek")

options(DT.options = list(pageLength = 25))

source("get_next_saturday.R")
source("read_processed_data.R")

# Get truth 
truth = bind_rows(
  read_csv("data-truth/truth-incident-deaths-sciensano.csv") %>% 
    mutate(inc_cum = "inc", unit = "day"),
  
  read_csv("data-truth/truth-incident-deaths-sciensano.csv") %>% 
    dplyr::mutate(week = MMWRweek::MMWRweek(date)$MMWRweek) %>%
    dplyr::group_by(location,week) %>%
    dplyr::summarize(date = max(date),
                     value = sum(value, na.rm = TRUE)) %>%
    dplyr::mutate(inc_cum = "inc", unit = "wk") %>%
    dplyr::select(-week)#,
  
  #read_csv("data-truth/truth-Cumulative Deaths.csv") %>% 
  #  mutate(inc_cum = "cum", unit = "wk") %>%
  #  dplyr::filter(weekdays(date) == "Saturday"),
  
  #read_csv("data-truth/truth-Cumulative Deaths.csv") %>% 
  #  mutate(inc_cum = "cum", unit = "day")
) %>%
mutate(death_cases = "death",
       simple_target = paste(unit, "ahead", inc_cum, death_cases)) 

# Further process the processed data for ease of exploration
latest <- all_data %>% 
  filter(!is.na(forecast_date)) %>%
  group_by(team, model) %>%
  dplyr::filter(forecast_date == max(forecast_date)) %>%
  ungroup() %>%
  tidyr::separate(target, into=c("n_unit","unit","ahead","inc_cum","death_cases"),
                  remove = FALSE)

  
###############################################################################
# Create shiny latest plot
latest_plot_data <- latest %>%
  filter(quantile %in% c(.025,.25,.5,.75,.975) | type == "point") %>%
  
  mutate(quantile = ifelse(type == "point", "point", quantile),
         simple_target = paste(unit,ahead,inc_cum, death_cases)) %>%
  select(-type) %>%
  tidyr::pivot_wider(
    names_from = quantile,
    values_from = value
  )



