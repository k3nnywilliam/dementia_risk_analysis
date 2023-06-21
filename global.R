if(!require(pacman)) install.packages("pacman")
if(!require(devtools)) install.packages("devtools")

library('pacman')
library('devtools')
pacman::p_load('shiny', 'bs4Dash', 'shinyjs', 'data.table', 'DT', 'shinybusy', 
               'readr', 'ggplot2', 'plotly', 'dplyr', 'tidyr', 'corrplot', 'Hmisc',
               'ggcorrplot', 'waiter')

data_filtered_rv <- reactiveValues(data = NULL)
data_height_filtered_rv <- reactiveValues(data = NULL)
data <- readr::read_csv('data/dataset ICT583 2023.csv') %>% 
  as.data.table() %>% subset(select = -c(`...1`))
