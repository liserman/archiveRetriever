library(ggplot2)
library(lubridate)



ggplot(content, aes(date)) +
  geom_col(aes(x = date, y = 1, colour = factor(month(date)))) +
  theme(
    legend.position = "none"
  )



