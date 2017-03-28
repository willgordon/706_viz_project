library("tidyverse")
library("ggplot2")
library("plotly")
library("lubridate")

setwd('/Users/williamgordon/Dropbox (Partners HealthCare)/Classes/BMI706/')
nyc_counties = c('NEW YORK', 'QUEENS', 'BRONX', 'KINGS', 'RICHMOND')

# Load and Filter Data

# Collisions:
collisions <- read_csv(file = 'data/NYPD_Motor_Vehicle_Collisions.csv',
                       col_types = list(DATE = col_date(format="%m/%d/%Y"))
                       )

sum(is.na(collisions$`ZIP CODE`) & is.na(collisions$BOROUGH)) # Too many locations not tagged with borough or zip code

# For now, lets filter out, later we can try and geocode them
collisions_filtered = collisions %>% filter(!(is.na(collisions$`ZIP CODE`) & is.na(collisions$BOROUGH)))

# # Borrowed from stackoverflow, lets get countie from Lat/Long
# 
# #install.packages(c("sp", "maps", "maptools"))
# library(sp)
# library(maps)
# library(maptools)
# 
# latlong2county <- function(pointsDF) {
#   
#   if (is.na(pointsDF[1]) | is.na(pointsDF[2])) {
#     return('NA')
#   }
#   
#   # Prepare SpatialPolygons object with one SpatialPolygon
#   # per county
#   counties <- map('county', fill=TRUE, col="transparent", plot=FALSE)
#   IDs <- sapply(strsplit(counties$names, ":"), function(x) x[1])
#   counties_sp <- map2SpatialPolygons(counties, IDs=IDs,
#                                      proj4string=CRS("+proj=longlat +datum=wgs84"))
#   
#   # Convert pointsDF to a SpatialPoints object 
#   pointsSP <- SpatialPoints(pointsDF, 
#                             proj4string=CRS("+proj=longlat +datum=wgs84"))
#   
#   # Use 'over' to get _indices_ of the Polygons object containing each point 
#   indices <- over(pointsSP, counties_sp)
#   
#   # Return the county names of the Polygons object containing each point
#   countyNames <- sapply(counties_sp@polygons, function(x) x@ID)
#   countyNames[indices]
# }
# 
# collisions$CALC_BOROUGH = apply(collisions, 1, function(x) {
#   if (is.na(x['LONGITUDE']) | is.na(x['LATITUDE'])) {
#     return(NA)
#   }
#   if (!is.na(x['BOROUGH']) | !is.na(x['ZIP CODE'])) {
#     return('NOT NEEDED')
#   } 
#   
#   df_coords <- data.frame('Longitude' = as.numeric(x['LONGITUDE']), 'Latitude' = as.numeric(x['LATITUDE']))
#   result <- latlong2county(df_coords)
#   sprintf("%s results in %s", df_coords, result)
#   return(result)
#   
# })

# NOAA Storm Data:

storms_2013 <- read_csv(file = 'data/StormEvents_details-ftp_v1.0_d2013_c20160223.csv')
storms_2014 <- read_csv(file = 'data/StormEvents_details-ftp_v1.0_d2014_c20161118.csv')
storms_2015 <- read_csv(file = 'data/StormEvents_details-ftp_v1.0_d2015_c20170216.csv')
storms_2016 <- read_csv(file = 'data/StormEvents_details-ftp_v1.0_d2016_c20170317.csv')

all_storms <- rbind(storms_2013, storms_2014, storms_2015, storms_2016)
all_storms_filtered <- all_storms %>% filter(STATE == 'NEW YORK' & 
                                               CZ_NAME %in% nyc_counties)
all_storms_filtered$FULL_DATE <- as.Date(paste0(all_storms_filtered$BEGIN_YEARMONTH, all_storms_filtered$BEGIN_DAY), "%Y%m%d")

# NYPD Complaint Data: 2006-2015
# complaints_all <- read_csv(file = 'data/NYPD_Complaint_Data_Historic.csv',
#                            col_types = list(CMPLNT_FR_DT = col_date(format="%m/%d/%Y"),
#                                             CMPLNT_TO_DT = col_date(format="%m/%d/%Y"))
#                            )
# complaints_2013_2015 <- complaints_all %>% filter(CMPLNT_FR_DT > '2013-01-01')
# 
# complaints_ytd <- read_csv(file = 'data/NYPD_Complaint_Data_Current_YTD.csv',
#                            col_types = list(CMPLNT_FR_DT = col_date(format="%m/%d/%Y"),
#                                             CMPLNT_TO_DT = col_date(format="%m/%d/%Y"))
#                            )
# 
# complaints_2013_2016 <- bind_rows(complaints_2013_2015, complaints_ytd)
# write.csv(complaints_2013_2016, file = 'data/complaints_2013_2016.csv')

complaints_2013_2016 <- read_csv(file = 'data/complaints_2013_2016.csv')

# Zip/Code to Borough Translations:
# https://www.health.ny.gov/statistics/cancer/registry/appendix/neighborhoods.htm

county_nhood_zip <- read_csv(file = 'data/county_nhood_zip.csv',
                             col_names = FALSE
                             )


# Questions to ask
# Weather: - What are the severe weather patterns that affect New York? Seasonality? Severity?
#          - How does this compare to Boston

# Collisions:
# - Where are the accidents?  What types?  Seasonality?  Car types ? Etc

# Arrest/Complaint data:
# - Where are the

# Summary Stats

nrow(collisions)

month_counts <- as.data.frame(table(format.Date(collisions$DATE, "%m")))
ggplot(month_counts, aes(Var1, Freq)) + geom_bar(stat="identity")

borough_counts <- as.data.frame(table(collisions$BOROUGH))
ggplot(borough_counts, aes(Var1, Freq)) + geom_bar(stat="identity")





