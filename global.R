# Provides a shiny dashboard to explore the processed data

# From https://github.com/reichlab/covid19-forecast-hub 

library("tidyverse")
library("shiny")
library("DT")
library("rmarkdown")
library("MMWRweek")
library("tidyr")
library("readr")

options(DT.options = list(pageLength = 25))

mortality_filename = "data-truth/truth-incident-deaths.csv"

# Get truth 
truth = bind_rows(
  read_csv(mortality_filename) %>% 
    mutate(inc_cum = "inc", unit = "day"),
  
  read_csv(mortality_filename) %>% 
    dplyr::mutate(week = MMWRweek::MMWRweek(date)$MMWRweek) %>%
    dplyr::group_by(location,week) %>%
    dplyr::summarize(date = max(date),
                     value = sum(value, na.rm = TRUE)) %>%
    dplyr::mutate(inc_cum = "inc", unit = "wk") 
) %>%
mutate(death_cases = "death",
       simple_target = paste(unit, "ahead", inc_cum, death_cases)) 

# Get predictions 

read_my_csv = function(f, into) {
  readr::read_csv(f,
                  col_types = readr::cols(
                    forecast_date   = readr::col_date(format = ""),
                    target          = readr::col_character(),
                    target_end_date = readr::col_date(format = ""),
                    location        = readr::col_character(),
                    type            = readr::col_character(),
                    quantile        = readr::col_double(),
                    value           = readr::col_double()
                  ))  %>%
    dplyr::mutate(file = f) %>%
    tidyr::separate(file, into, sep="/") 
}

read_my_dir = function(path, pattern, into, exclude = NULL) {
  files = list.files(path       = path,
                     pattern    = pattern,
                     recursive  = TRUE,
                     full.names = TRUE) %>%
    setdiff(exclude)
  plyr::ldply(files, read_my_csv, into = into)
}

# above from https://gist.github.com/jarad/8f3b79b33489828ab8244e82a4a0c5b3
#############################################################################

all_data = read_my_dir("data-processed", "*.csv",
                       into = c("folder","team_model",
                                "filename")) %>%
  dplyr::select(team_model, forecast_date, type, location, target, quantile, value, target_end_date)



# Further process the processed data for ease of exploration
all_data <- all_data %>% 
  tidyr::separate(target, into=c("n_unit","unit","ahead","inc_cum","death_cases"),
                  remove = FALSE) %>%
  filter(quantile %in% c(.025,.25,.5,.75,.975) | type == "point") %>%
  mutate(quantile = ifelse(type == "point", "point", quantile),
         simple_target = paste(unit,ahead,inc_cum, death_cases)) %>%
  select(-type) %>%
  tidyr::pivot_wider(
    names_from = quantile,
    values_from = value
  )
