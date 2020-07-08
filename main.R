# Zipcode data is downloaded  from http://download.geonames.org/export/zip/
# Creative Commons Attribution 3.0 License
# By Mahdi Sahfiei 2020-07-08

require('dplyr')
require('ggmap')
require('ggplot2')

# use your own google API; see https://cran.r-project.org/web/packages/ggmap/readme/README.html
register_google(key = "[google APT key]")

# read the US zipcode data and extract needed data
us_data <- read.delim('./Data/US/US.txt')
us_data <- select(us_data, c(2,10,11))
us_data <- rename(us_data, zip = X99553, y = X54.143, x = X.165.7854)

zipcodes <- read.csv('./Data/zipcodes.csv')
zipcodes <- rename(zipcodes, zip = x)

# shows invalid zipcodes in our data set
# subset(zipcodes, !(zipcodes$zip %in% us_data$zip))

# merging the dara zip and x,y data
merged_data <- merge(zipcodes, us_data, by = 'zip')
merged_data$zip <- factor(merged_data$zip)

freqs <- data.frame(table(merged_data$zip))
freqs$zip <- factor(freqs$Var1)
freqs <- select(freqs, -Var1)
merged_data$zip <- factor(merged_data$zip)
data <- unique(left_join(freqs, merged_data, by = 'zip'))


# get US map
us <- c(left = -127, bottom = 24, right = -60, top = 50)
us_map <- get_stamenmap(us, zoom=4, maptype = "terrain")

ggmap(us_map) + geom_point(
  aes(x=x, y=y, show_guide = TRUE, colour=Freq), 
  data=data, alpha=.5, na.rm = T)  + 
  scale_color_gradient(low="blue", high="red") +
  labs(x = "Longitude", y = "Latidute", title = 'Geographical Distribution of Subjects')
  


