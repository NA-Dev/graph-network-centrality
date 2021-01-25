library(tidyverse)
library(RMySQL)

DB ='imdb'
HOST = 'localhost'
USER = 'root'
PASSWORD = 'yourpassword'

# create / connect to database
con = dbConnect(MySQL(), user=USER, password=PASSWORD, host=HOST)
dbSendStatement(con, sprintf('CREATE DATABASE IF NOT EXISTS %s', DB))
con = dbConnect(MySQL(), user=USER, password=PASSWORD, dbname=DB, host=HOST)

dir = '/home/nadev/Repositories/Data-Science-Masters-Coursework/SYS 6018 -  Data Mining/000 - Project/Data'
setwd(dir)

# Data downloaded from https://datasets.imdbws.com/
files <- list.files(path=dir, recursive = F, full.names = T)

for (file in files) {
  # break path into parts
  path = unlist(strsplit(file, "/"))
  
  # last part is filename
  filename = path[length(path)]
  print(filename)
  
  # read frst line of data into dataframe
  data=read.table(file = paste(dir, filename, sep="/"), sep = '\t', header = TRUE, fill = TRUE, nrows=1)
  
  # ------- save to mysql database ---------#
  
  # use filename as table name
  table_name = sub('.', '_', substr(filename,1,nchar(filename)-4), fixed=TRUE)
  
  # create table with columns and insert first row of data
  dbWriteTable(con, table_name, data, overwrite = TRUE, row.names=FALSE) 
  # insert remaining rows from file
  query = sprintf("LOAD DATA LOCAL INFILE '%s' INTO TABLE %s FIELDS TERMINATED BY '\t' IGNORE 2 LINES", filename, table_name)
  dbSendStatement(con, query)
}
