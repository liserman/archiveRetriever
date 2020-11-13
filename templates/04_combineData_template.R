# TEMPLATE 04: COMBINING DATASETS

############################################################
# INSTRUCTIONS:                                            #
#                                                          #
#   - specify years [15]                                   #
#   - specify papers [16]                                  #
#   - specify country [27]                                 #
#                                                          #
############################################################


# Load packages
library(tidyverse)

years <- seq(2016,2019)
papers <- c("lemonde", "lefigaro", "liberation")



for (p in 1:length(papers)) {
  
for (i in 1:length(years)) {


# Specify source folder
country <- "FR"



#------------------ NO CHANGES NEEDED FROM HERE --------------------------------------


ordner <- years[i]
paper <- papers[p]

# Set working directory
wd <- paste0("/home/ubuntu/database/", country, "/", paper, "/", ordner)

# Specify target file
daten <- paste0("/home/ubuntu/database/", country, "/", paper, "_", ordner, ".RData")


# Set working directory
setwd(wd)

# Combine all .RData files in directory
tmp <- list.files(pattern = "*.RData")

Files <- lapply(tmp, function(x){get(load(x,.GlobalEnv))})

content <- do.call("rbind", Files)

#Only keep latest version of the article
content <- content %>% 
  arrange(desc(date)) %>% 
  distinct(title, .keep_all = TRUE)

# Save data
save(content, file = daten)

}
}
