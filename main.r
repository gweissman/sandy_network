library(igraph)
library(data.table)
library(RISmed) # Quick reference: https://datascienceplus.com/search-pubmed-with-rismed/
library(ggraph)


# Get PubMed data
# Note these are only publications that match to Sandy
# and not shared publications among his co-authors who also publish together without Sandy
my_query <- 'Schwartz JS[AU]'
res <- EUtilsSummary(my_query, type="esearch", db="pubmed", datetype='pdat', mindate=1973, maxdate=2023, retmax=500)
author_list <- Author(EUtilsGet(res))

# Clean up pubmed data to get an edgelist of authors
extract_author_edgelist <- function(dd) {
    tmp <- setDT(dd)
    al <- with(tmp, paste0(LastName, Initials)) 
    if (length(al) == 1 | length(al) > 400) return(NULL)
    else return(al |> combn(2) |> t() |> as.data.table())
}

author_el <- rbindlist(lapply(author_list, extract_author_edgelist), fill = TRUE)
setnames(author_el, c('ego', 'alter'))

# First make plot of just Sandy's collaborators
g_sandy <- graph_from_data_frame(author_el['SchwartzJS' == ego | 'SchwartzJS' == alter])
ggraph(g_sandy) +
geom_node_point() +
geom_edge_link(width = 0.05) +
theme_void() +
coord_fixed() +
ggtitle(paste0('Sandy and ', length(V(g_sandy)) - 1, 'co-authors'))
ggsave('graph_sandy.png')

# Now make the graph of everyoneg_sandy <- graph_from_data_frame(author_el['SchwartzJS' == ego | 'SchwartzJS' == alter])
g_all <- graph_from_data_frame(author_el)
ggraph(g_all) +
geom_node_point() +
geom_edge_link(width = 0.05) +
theme_void() +
coord_fixed() +
ggtitle('Sandy and the collaborations among his co-authors')
ggsave('graph_all.png')
