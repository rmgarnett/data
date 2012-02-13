#!/bin/bash

DATA_DIRECTORY='../raw'
GRANCH_DATA_DIRECTORY=$DATA_DIRECTORY/'granch-nearest-neighbors'
PROCESSED_DIRECTORY='../processed'
TOP_VENUE_PROCESSED_DIRECTORY='../processed/top_venues'

echo 'creating paper id -> citeseer name index'
bzcat $DATA_DIRECTORY/csx-paperIndex-to-paperId.tsv.bz2 | \
		awk '{print ($1 + 1), $2}' > \
		$PROCESSED_DIRECTORY/paper_ids_to_names

echo 'creating citation edge list'
bzcat $DATA_DIRECTORY/edges_paperIndex2paperIndex.csv.bz2 | \
		awk 'BEGIN {FS = ", "} {print ($1 + 1), ($2 + 1)}' > \
		$PROCESSED_DIRECTORY/edge_list

echo 'creating nips paper id list'
bzcat $DATA_DIRECTORY/nodes_nips-paperIndex.txt.bz2 | \
		awk '{print ($1 + 1)}' > \
		$PROCESSED_DIRECTORY/nips_paper_ids

echo 'creating granch nearest neighbor list'
bzcat $GRANCH_DATA_DIRECTORY/commute-weight-top300.csv.bz2 | \
		awk 'BEGIN {FS = ","} {print ($1 + 1), ($2 + 1), (1 / $3)}' > \
		$PROCESSED_DIRECTORY/granch_nearest_neighbors

echo 'creating top venue edge list'
bzcat $DATA_DIRECTORY/edges_paperIndex2paperIndex_topVenues.tsv.bz2 | \
		awk '{print $1, $2}' > \
		$TOP_VENUE_PROCESSED_DIRECTORY/edge_list
		
echo 'creating list of top venue nodes'
bzcat $DATA_DIRECTORY/edges_paperIndex2paperIndex_topVenues.tsv.bz2 | \
		awk '{nodes[$1] = 1; nodes[$2] = 1} END {for (node in nodes) {print node}}' | \
		sort -n > \
		$TOP_VENUE_PROCESSED_DIRECTORY/top_venue_ids
