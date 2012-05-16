#!/bin/bash

RAW_DIRECTORY='../raw'
PROCESSED_DIRECTORY='../processed'
VENUE_SUBGRAPH_DIRECTORY='../processed/venue_subgraph'

echo 'creating paper id -> citeseer name index'
bzcat ${RAW_DIRECTORY}/csx-paperIndex-to-paperId.tsv.bz2 | \
		awk '{print ($1 + 1), $2}' \
		> ${PROCESSED_DIRECTORY}/paper_ids_to_names

echo 'creating citation edge list'
bzcat ${RAW_DIRECTORY}/edges_paperIndex2paperIndex.csv.bz2 | \
		awk 'BEGIN {FS = ", "} {print ($1 + 1), ($2 + 1)}' \
		> ${PROCESSED_DIRECTORY}/edge_list

echo 'creating top venue edge list'
mawk \
		-f build_venue_subgraph.awk \
		-v 'venues_to_keep_file='venues_to_keep \
		-v 'positive_venues_file='positive_venues \
		-v 'id_file='${PROCESSED_DIRECTORY}/paper_ids_to_names \
		-v 'positive_node_ids_file='${VENUE_SUBGRAPH_DIRECTORY}/positive_node_ids \
		-v 'venue_file'=${PROCESSED_DIRECTORY}/paper_ids_to_normalized_venues \
		${PROCESSED_DIRECTORY}/edge_list \
		> ${VENUE_SUBGRAPH_DIRECTORY}/edge_list

echo 'preparing matlab venue subgraph file'
matlab -nodisplay -r 'prepare_venue_subgraph; exit;'

echo 'done!'