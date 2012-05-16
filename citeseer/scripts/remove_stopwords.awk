BEGIN {
	while ((getline < "stopwords") > 0) {
		stopwords[$0] = 1
	}
}

{
	filtered_line = " "
	
	for (i = 1; i <= NF; i++) 
		if (!stopwords[$i]) 
			filtered_line = filtered_line $i " "

	print filtered_line
}