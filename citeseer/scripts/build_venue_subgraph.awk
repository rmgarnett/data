BEGIN {
	while ((getline < venues_to_keep_file) > 0) {
		venues_to_keep[$0] = 1
	}

	while ((getline < positive_venues_file) > 0) {
		positive_venues[$0] = 1
	}

	while ((getline < id_file) > 0) {
		ids[$2] = $1
	}

	while ((getline < venue_file) > 0) {
		if (venues_to_keep[$2]) {
			new_id++
			new_ids[ids[$1]] = new_id
			nodes_to_keep[ids[$1]] = 1
		}
		if (positive_venues[$2]) {
			print new_ids[ids[$1]] > positive_node_ids_file
		}
	}
}

(nodes_to_keep[$1] && nodes_to_keep[$2]) {
	print new_ids[$1], new_ids[$2]
}
