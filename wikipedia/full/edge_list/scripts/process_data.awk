BEGIN {
	FS = ", "
} 

(ids[$1] == "") {
	id++
	ids[$1] = id
} 

(ids[$2] == "") {
	id++
	ids[$2] = id
} 

{
	print ids[$1], ids[$2]
}

END {
	for (id in ids)
		print ids[id], id > index_file
}
