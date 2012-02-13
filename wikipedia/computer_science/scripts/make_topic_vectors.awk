BEGIN {
	line = 0
	while ((getline < document_file) > 0) {
		line++
		pages[line] = $2
	}
}

(NR > 1) {
	for (i = 3; i < NF; i+= 2) 
		print pages[NR - 1], ($i + 1), $(i + 1)
}