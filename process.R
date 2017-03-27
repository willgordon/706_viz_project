library("dplyr")
library("readr")
library("ggplot2")
library("plotly")

# Collisions:

collisions <- read_csv(file = 'Dropbox (Partners HealthCare)/Classes/BMI706/project/NYPD_Motor_Vehicle_Collisions.csv')

# NOAA Storm Data:

# Unintentional Injuries
injuries <- read_csv(file = 'Dropbox (Partners HealthCare)/Classes/BMI706/project/unintentional_injuries.csv')

# Actual arrest data: http://www.criminaljustice.ny.gov/crimnet/ojsa/arrests/index.htm by county

summary(collisions)

p <- plot_ly(
  x = c("giraffes", "orangutans", "monkeys"),
  y = c(20, 14, 23),
  name = "SF Zoo",
  type = "bar"
)

# Questions to ask
# Weather: - What are the severe weather patterns that affect New York? Seasonality? Severity?
#          - How does this compare to Boston

# Collisions:
# - Where are the accidents?  What types?  Seasonality?  Car types ? Etc

# Arrest data:
# - Where are the










