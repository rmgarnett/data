#!/bin/bash

DATA_DIRECTORY='../data'
PROCESSED_DIRECTORY='../processed'
TEMP_DIRECTORY='/tmp'

echo 'creating wikipedia hyperlink edge list'
bzcat $DATA_DIRECTORY/pagelinks-catgory-Computer_science.csv.bz2 | \
		awk -f process_data.awk -v 'index_file='$TEMP_DIRECTORY/page_names_to_ids > \
		$PROCESSED_DIRECTORY/edge_list

echo 'creating page name -> page id index'
sort -n $TEMP_DIRECTORY/page_names_to_ids > $PROCESSED_DIRECTORY/page_names_to_ids

echo 'creating page name -> page title index'
echo 'creating page name -> page id index'
echo 'creating document file -- programming languages'
bzcat $DATA_DIRECTORY/pageIdTitleText-programmingLanguages.csv.bz2 | \
		awk -f process_text.awk \
		-v 'id_index_file='$PROCESSED_DIRECTORY/page_names_to_ids \
		-v 'name_to_title_file='$PROCESSED_DIRECTORY/programming_language_page_names_to_titles \
		-v 'id_to_title_file='$PROCESSED_DIRECTORY/programming_language_page_ids_to_titles \
		-v 'document_type'='programming_languages' \
		-v 'document_file='$TEMP_DIRECTORY/programming_language_page_text

echo 'creating document file -- not programming languages'
bzcat $DATA_DIRECTORY/pageIdTitleText-nonProgrammingLanguages.csv.bz2 | \
		awk -f process_text.awk \
		-v 'id_index_file='$PROCESSED_DIRECTORY/page_names_to_ids \
		-v 'name_to_title_file='$PROCESSED_DIRECTORY/non_programming_language_page_names_to_titles \
		-v 'id_to_title_file='$PROCESSED_DIRECTORY/non_programming_language_page_ids_to_titles \
		-v 'document_type'='non_programming_languages' \
		-v 'document_file='$TEMP_DIRECTORY/non_programming_language_page_text

echo 'stripping bad characters from document file'
tr -cd '\40-\176\ \r\n' < $TEMP_DIRECTORY/programming_language_page_text > \
		$PROCESSED_DIRECTORY/programming_language_page_text
tr -cd '\40-\176\ \r\n' < $TEMP_DIRECTORY/non_programming_language_page_text >> \
		$PROCESSED_DIRECTORY/non_programming_language_page_text

echo 'creating global indices'
cat $PROCESSED_DIRECTORY/programming_language_page_names_to_titles \
		$PROCESSED_DIRECTORY/non_programming_language_page_names_to_titles > \
		$PROCESSED_DIRECTORY/page_names_to_titles
cat $PROCESSED_DIRECTORY/programming_language_page_ids_to_titles \
		$PROCESSED_DIRECTORY/non_programming_language_page_ids_to_titles > \
		$PROCESSED_DIRECTORY/page_ids_to_titles
cat $PROCESSED_DIRECTORY/programming_language_page_ids_to_titles | \
		awk '{print $1}' > \
		$PROCESSED_DIRECTORY/programming_language_page_ids
cat $PROCESSED_DIRECTORY/non_programming_language_page_ids_to_titles | \
		awk '{print $1}' > \
		$PROCESSED_DIRECTORY/non_programming_language_page_ids
