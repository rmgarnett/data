#!/bin/bash

PROCESSED_DIRECTORY='../processed'
TEMP_DIRECTORY='/tmp'

MALLET_DIRECTORY='/Volumes/raidy/Users/roman/work/tools/mallet/bin'
TOPICS_DIRECTORY='../processed/topics'

echo 'importing documents for mallet'
$MALLET_DIRECTORY/mallet import-file \
		--input $PROCESSED_DIRECTORY/page_text \
		--remove-stopwords \
		--keep-sequence \
		--output $TOPICS_DIRECTORY/wikipedia_documents

echo 'training topic model'
$MALLET_DIRECTORY/mallet train-topics \
		--input $TOPICS_DIRECTORY/wikipedia_documents \
		--num-topics 200 \
		--optimize-interval 50 \
		--num-threads 16 \
		--output-topic-keys $TOPICS_DIRECTORY/wikipedia_topic_keys \
		--output-doc-topics $TOPICS_DIRECTORY/wikipedia_topic_vectors

echo 'creating topic vectors'
awk -f make_topic_vectors.awk \
		-v 'document_file='$PROCESSED_DIRECTORY/page_text \
		$TOPICS_DIRECTORY/wikipedia_topic_vectors > \
		$TOPICS_DIRECTORY/sparse_wikipedia_topic_vectors