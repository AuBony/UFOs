setwd("E:/Cours/M2_Stat/UFOs")

# Data ----
library(readr)
complete <- read_csv("complete.csv", col_types = cols(city = col_character(), 
                                                      country = col_character(), datetime = col_datetime(format = "%m/%d/%Y %H:%M"), 
                                                      `duration (seconds)` = col_number(), 
                                                      latitude = col_number(), longitude = col_number(), 
                                                      shape = col_character(), state = col_character()))

# Data modifications -----

names(complete)[6] <- "duration"
names(complete)[7] <- "durationH"
names(complete)[9] <- "date_posted"

complete$country <- as.factor(complete$country)

ec <- na.omit(complete)

index <- sample(1:nrow(ec), 500)
data <- ec[index, ]


# Test ----
require(ggplot2)

ggplot(data[data$duration < 20000,], aes(x = duration, color = country)) +
  geom_density()

ggplot(data[data$duration < 20000,], aes(x = duration, color = state)) +
  geom_density()

ggplot(data[data$duration < 1000,], aes(x = duration, color = shape)) +
  geom_density()



require(plotluck)
plotluck(duration ~ longitude + latitude , data = data)

ggplot(data, aes(x = duration, ))

plotluck(data, formula = datetime ~ .)

plot(data$`duration (seconds)`, data$latitude)
barplot(data$shape)

complete$comments[6]
data$
str(complete)
data <- sample()
head(complete)
