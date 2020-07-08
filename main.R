# Zipcode data is downloaded  from http://download.geonames.org/export/zip/
# Creative Commons Attribution 3.0 License
# By Mahdi Sahfiei 2020-07-08

require('dplyr')
require('ggmap')
require('ggplot2')

# read the US zipcode data and extract needed data
us_data <- read.delim('./Data/US/US.txt')
us_data <- select(us_data, c(2,10,11))
us_data <- rename(us_data, zip = X99553, x = X54.143, y = X.165.7854)

zipcodes <- read.csv('./Data/zipcodes.csv')
zipcodes <- rename(zipcodes, zip = x)

# shows invalid zipcodes in our data set
# subset(zipcodes, !(zipcodes$zip %in% us_data$zip))

merged_data <- merge(zipcodes, us_data, by = 'zip')
merged_data$zip <- factor(merged_data$zip)

freqs <- data.frame(table(merged_data$zip))
freqs$zip <- factor(freqs$Var1)
freqs <- select(freqs, -Var1)
merged_data$zip <- factor(merged_data$zip)
data <- unique(left_join(freqs, merged_data, by = 'zip'))


# get US map
us_map <- get_map(location='united states', zoom=4, maptype = "terrain", source='google',color='color')

ggmap(us_map) + geom_point(
  aes(x=merged_data$x, y=merged_data$y, show_guide = TRUE, colour=Median), 
  data=census, alpha=.5, na.rm = T)  + 
  scale_color_gradient(low="beige", high="blue")


