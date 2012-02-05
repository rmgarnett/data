BEGIN {
	while ((getline < id_index_file) > 0)
		ids[$2] = $1

	FS = ", "
} 

(ids[$1] != "") {
	print ids[$1], $2
}