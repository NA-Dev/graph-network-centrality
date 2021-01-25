# Hollywood Network Centrality





## Executive Summary

In graph networks, it is often desired to find the most central figure in the group. However, there are many choices of how to define and calculate centrality. Using the Hollywood network of actors and recent films as an example network we give a detailed discussion on seven different options, letting you know when to choose and how to interpret each centrality score. Finally, we also discuss how incorporating edge weights can change these calculations. In Hollywood, we came to the conclusion that Charlize Theron is the most central figure in recent years by a variety of the centrality types.

**Access full report at https://htmlpreview.github.io/?https://github.com/NA-Dev/graph-network-centrality/blob/main/FinalProject.html**

## Data Sources

Film and actor data from IMDB was put into a MySQL database. A subset of this set was used, retrieved with a query specified in the final report writeup.

https://www.imdb.com/interfaces/



Supplemental data on film finacials were added by fetching programmatically from the following API.

https://www.themoviedb.org/



### File List

SaveDataBase.R - script to save IMDB data files to a database

Queries.R - queries to retrieve desired data subset

hollywood_dataset.csv - final dataset (queried dataset supplemented with API data)

FinalProject.Rmd - Code and writeup