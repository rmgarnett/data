#!/bin/bash

PREFIX='http://dumps.wikimedia.org/enwiki/20120104/'
DATA_DIRECTORY='../data/'

for file in $(cat file_list)
do
		wget "${PREFIX}${file}" --output-document="${DATA_DIRECTORY}${file}"
done