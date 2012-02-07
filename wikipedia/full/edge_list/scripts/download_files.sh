#!/bin/bash

PREFIX='https://s3.amazonaws.com/machine_learning_data/wikipedia/edge_list/data/'
DATA_DIRECTORY='../data/'

for file in $(cat file_list)
do
		wget "${PREFIX}${file}" --output-document="${DATA_DIRECTORY}${file}"
done