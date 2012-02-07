#!/bin/bash

DATA_DIRECTORY='../data'
PROCESSED_DIRECTORY='../processed'
TEMP_DIRECTORY='/tmp'

echo 'creating wikipedia hyperlink edge list'
xzcat $DATA_DIRECTORY/pagelinks.csv.xz | \
		awk -f process_data.awk -v 'index_file='$TEMP_DIRECTORY/page_names_to_ids > \
		$PROCESSED_DIRECTORY/edge_list

echo 'creating page name -> page id index'
sort -n $TEMP_DIRECTORY/page_names_to_ids > $PROCESSED_DIRECTORY/page_names_to_ids

echo 'creating page name -> page title index'
xzcat $DATA_DIRECTORY/page_id_title_ascii.csv.xz | \
		awk -f process_text.awk \
		-v 'id_index_file='$PROCESSED_DIRECTORY/page_names_to_ids > \
		$PROCESSED_DIRECTORY/page_names_to_titles_ascii

xzcat $DATA_DIRECTORY/page_id_title_utf8.csv.xz | \
		awk -f process_text.awk \
		-v 'id_index_file='$PROCESSED_DIRECTORY/page_names_to_ids > \
		$PROCESSED_DIRECTORY/page_names_to_titles_utf8
