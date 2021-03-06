library(scales)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(readxl)
library(ggthemes)
library(dplyr)

covid_data_tbl <- read_csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv")

# Preparing Data for plotting
covid_data_wrangeled_tbl <- covid_data_tbl %>%
  select(countriesAndTerritories, cases, dateRep, month, year, day) %>%
  relocate(year, month, day) %>%
  filter(year == 2020, month >= 1) %>%
  filter(day != 1) %>%
  filter(countriesAndTerritories == "France" | countriesAndTerritories == "Germany" | countriesAndTerritories == "United_Kingdom" | countriesAndTerritories == "Spain" | countriesAndTerritories == "United_States_of_America") %>%
  group_by(countriesAndTerritories,month) %>%
  summarize(totalcases = sum(cases)) %>%
  ungroup()
    

covid_data_wrangeled_tbl %>%
  ggplot(aes(month ,totalcases, color = countriesAndTerritories)) +
  geom_smooth(method = "loess", span = 0.2) +
  scale_y_continuous(labels = scales::dollar_format(scale  = 1/1e6, 
                                                    prefix = "", 
                                                    suffix = "M")) +
  scale_x_continuous(breaks = seq(1, 11 , by=1),labels= c("January",
                                                          "February",
                                                          "March",
                                                          "April",
                                                          "May",
                                                          "June",
                                                          "July",
                                                          "August",
                                                          "September",
                                                          "October",
                                                          "November")) +

  labs(
    title = ("COVID-19 confirmed cases worldwide"),
    subtitle = ("United States has the highest rate of cases"),
    caption = "",
    x = "(Year 2020)",
    y = "Cumulative Cases",
    color = "Country"
      ) +
  geom_label(aes(label = (totalcases)), 
             hjust = "inward",
             size  = 3,
             color = RColorBrewer::brewer.pal(n = 12, name = "Blues")[8]) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
