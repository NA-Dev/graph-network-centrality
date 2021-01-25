library(tidyverse)
library(RMySQL)

DB ='imdb'
HOST = 'localhost'
USER = 'root'
PASSWORD = 'Passphrase1'

# create / connect to database
con = dbConnect(MySQL(), user=USER, password=PASSWORD, host=HOST)
dbSendStatement(con, sprintf('CREATE DATABASE IF NOT EXISTS %s', DB))
con = dbConnect(MySQL(), user=USER, password=PASSWORD, dbname=DB, host=HOST)

dir = '/home/nadev/Repositories/Data-Science-Masters-Coursework/SYS 6018 -  Data Mining/000 - Project/Data Analysis'
setwd(dir)

# Example code at https://beanumber.github.io/mdsr2e/ch-netsci.html#extended-example-six-degrees-of-kristen-stewart

# Select films
query = "
SELECT COUNT(*)
  FROM imdb.title_basics AS t
    LEFT JOIN imdb.title_ratings AS idx ON idx.tconst = t.tconst
  WHERE t.startYear >= 2015
    AND t.titleType = 'movie'
    AND t.isAdult = 0
    AND idx.numVotes >= 5000"
# Results in 2,411 films

# Select actors connected by being top 20 stars in films
query = "
SELECT actor1, actor2,
    ANY_VALUE(a.ordering * b.ordering) AS orderprod,
    ANY_VALUE(t.tconst) as film_id,
    ANY_VALUE(t.primaryTitle) as film,
    ANY_VALUE(idx.averageRating) AS ratings
  FROM (
        SELECT a.*, a.nconst AS actor1_id, b.primaryName AS actor1
        FROM imdb.title_principals AS a
        LEFT JOIN imdb.name_basics AS b ON a.nconst = b.nconst
    ) AS a
    CROSS JOIN (
        SELECT a.*, a.nconst AS actor2_id, b.primaryName AS actor2
        FROM imdb.title_principals AS a
        LEFT JOIN imdb.name_basics AS b ON a.nconst = b.nconst
    ) AS b USING (tconst)
    LEFT JOIN imdb.title_basics AS t ON a.tconst = t.tconst
    LEFT JOIN imdb.title_ratings AS idx ON idx.tconst = a.tconst
  WHERE t.startYear >= 2015 
    AND t.titleType = 'movie' 
    AND t.isAdult = 0
    AND idx.numVotes >= 5000
    AND a.ordering <= 20 AND b.ordering <= 20
    AND a.category IN ('actor','actress','self') AND b.category IN ('actor','actress','self')
    AND a.nconst < b.nconst
  GROUP BY actor1, actor2, film"
# Results in 14,522 connections

data = dbGetQuery(con, query)
data = data %>% drop_na()
write.csv(data, 'imdb_actors.csv', row.names=FALSE)

# --------- Join Film Data ------------#

# data = read.csv('imdb_actors.csv')
filmdata = read.csv('../Data/scraped_movies_all.csv')

joined = data %>% inner_join(filmdata, by = c("film_id" = "imdb_id"))
joined = joined[,!(names(joined) %in% c("imdb_id.1", "film", "original_title"))]

write.csv(joined, 'full_dataset.csv', row.names=FALSE)