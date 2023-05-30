library(igraph)
library(stringr)
library(data.table)
library(easyPubMed)
library(ggraph)
library(tidygraph)
library(ggsci)

sandy_names <- c('Schwartz, J. Sanford', 'Schwartz, Sandy')

my_query <- 'Schwartz JS[AU]'

my_entrez_id <- get_pubmed_ids(my_query)

pmd <- fetch_pubmed_data(my_entrez_id)

pmd_df <- setDT(article_to_df(pmd))

all_ids <- fetch_all_pubmed_ids(my_entrez_id)
# Increase return max
# Increase date range