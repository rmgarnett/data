BEGIN {
	while ((getline < id_index_file) > 0)
		ids[$2] = $1

	FS = ", "
} 

/wiki:title/ {
	gsub("wiki:title:", "")
	if (ids[$1] != "") {
		print $1, $2 > name_to_title_file
		print ids[$1], $2 > id_to_title_file
	}
}

/wiki:text/ {
	gsub("wiki:text:", "")
	if (ids[$1] != "") {
		id = ids[$1]
		$1 = ""
		sub(" ", "")
		print document_type, id, $0 > document_file
	}
}