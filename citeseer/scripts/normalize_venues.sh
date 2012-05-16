#!/bin/bash

RAW_DIRECTORY='../raw'
PROCESSED_DIRECTORY='../processed'

TEMP_DIRECTORY='/tmp'

bzcat ${RAW_DIRECTORY}/citeseer_paper_id_venue.ascii.tsv.bz2 | \
		mawk 'BEGIN {FS = "\t"} {print $2}' | \
		tr 'A-Z' 'a-z' | \
		tr -cd 'a-z[:space:]' | \
		mawk -f remove_stopwords.awk | \
		sed 's/\<in\>//g' | \
		sed 's/\<j\>/journal/g' | \
		sed 's/\<jour\>/journal/g' | \
		sed 's/\<anns?\>/annuls/g' | \
		sed 's/\<lett\>/letters/g' | \
		sed 's/\<univ\>/university/g' | \
		sed 's/\<dept\>/department/g' | \
		sed 's/\<usa\>//g' | \
		sed 's/\<ieee\>//g' | \
		sed 's/\<siam\>//g' | \
		sed 's/\<rev\>/review/g' | \
		sed 's/\<acmieee\>/ieeeacm/g' | \
		sed 's/\<proc\>/proceedings/g' | \
		sed 's/\<trans\>/transactions/g' | \
		sed 's/\<symp\>/symposium/g' | \
		sed 's/\<conf\>/conference/g' | \
		sed 's/\<workshop\>/conference/g' | \
		sed 's/\<convention\>/conference/g' | \
		sed 's/\<intl\>/international/g' | \
		sed 's/\<annu\>/annual/g' | \
		sed 's/\<annl\>/annual/g' | \
		sed 's/annual\>//g' | \
		sed 's/\<accepted\>//g' | \
		sed 's/\<submitted\>//g' | \
		sed 's/\<preprint\>//g' | \
		sed 's/\<press\>//g' | \
		sed 's/\<appear\>//g' | \
		sed 's/phys\>/physics/g' | \
		sed 's/\<sci\>/science/g' | \
		sed 's/biol\>/biology/g' | \
		sed 's/\<biom\>/biomedical/g' | \
		sed 's/\<clin\>/clinical/g' | \
		sed 's/\<mol\>/molecular/g' | \
		sed 's/stat\>/statistics/g' | \
		sed 's/\<mech\>/mechanical/g' | \
		sed 's/\<func\>/functional/g' | \
		sed 's/\<anal\>/analysis/g' | \
		sed 's/chem\>/chemistry/g' | \
		sed 's/\<math\>/mathematics/g' | \
		sed 's/\<soft\>/software/g' | \
		sed 's/\<prob\>/probabilitiy/g' | \
		sed 's/\<evol\>/evolution/g' | \
		sed 's/\<comb\>/combinatorics/g' | \
		sed 's/\<inf\>/information/g' | \
		sed 's/\<syst?\>/systems/g' | \
		sed 's/\<geom\>/geometry/g' | \
		sed 's/\<phil\>/philosophical/g' | \
		sed 's/\<eng\>/engineering/g' | \
		sed 's/\<theor\>/theoretical/g' | \
		sed 's/\<commun\>/communication/g' | \
		sed 's/\<comm\>/communication/g' | \
		sed 's/\<comput\>/computing/g' | \
		sed 's/\<inform\>/information/g' | \
		sed 's/\<comp\>/computing/g' | \
		sed 's/\<numer\>/numerical/g' | \
		sed 's/\<appl\>/applied/g' | \
		sed 's/\<ai\>/artificial intelligence/g' | \
		sed 's/\<res\>/research/g' | \
		sed 's/\<amer\>/american/g' | \
		sed 's/\<soc\>/society/g' | \
		sed 's/\<roy\>/royal/g' | \
		sed 's/\<ass\>/association/g' | \
		sed 's/\<assc\>/association/g' | \
		sed 's/\<assoc\>/association/g' | \
		sed 's/\<plos\>/public library science/g' | \
		sed 's/\<ams\>/american mathematics society/g' | \
		sed 's/\<acm\>/assocation computing machinery/g' | \
		sed 's/\<monwearev\>/monthly weather review/g' | \
		sed 's/\<pami\>/pattern analysis machine intelligence/g' | \
		sed 's/\<jmlr\>/journal machine learning research/g' | \
		sed 's/\<jair\>/journal artificial intelligence research/g' | \
		sed 's/\<pnas\>/proceedings national academy science usa/g' | \
		sed 's/our\>/or/g' | \
		sed 's/ise\>/ize/g' | \
		sed 's/\<vol\>//g' | \
		sed 's/\<jan>//g' |\
		sed 's/\<january>//g' |\
		sed 's/\<feb>//g' |\
		sed 's/\<february>//g' |\
		sed 's/\<mar>//g' |\
		sed 's/\<march>//g' |\
		sed 's/\<apr>//g' |\
		sed 's/\<april>//g' |\
		sed 's/\<may>//g' |\
		sed 's/\<june?>//g' |\
		sed 's/\<july?>//g' |\
		sed 's/\<aug>//g' |\
		sed 's/\<august>//g' |\
		sed 's/\<sep>//g' |\
		sed 's/\<september>//g' |\
		sed 's/\<oct>//g' |\
		sed 's/\<october>//g' |\
		sed 's/\<nov>//g' |\
		sed 's/\<november>//g' |\
		sed 's/\<dec>//g' |\
		sed 's/\<december>//g' |\
		sed 's/\<st\>//g' | \
		sed 's/\<nd\>//g' | \
		sed 's/\<rd\>//g' | \
		sed 's/\<th\>//g' | \
		sed 's/proceedings//g' | \
		sed 's/transactions//g' | \
		mawk -f normalize_venues.awk | \
		sed 's/[[:space:]]//g' \
		> ${TEMP_DIRECTORY}/normalized_venues

bzcat ${RAW_DIRECTORY}/citeseer_paper_id_venue.ascii.tsv.bz2 | \
		mawk 'BEGIN {FS = "\t"} {print $1}' | \
		paste -d' ' - ${TEMP_DIRECTORY}/normalized_venues > \
		${PROCESSED_DIRECTORY}/paper_ids_to_normalized_venues

sort ${TEMP_DIRECTORY}/normalized_venues | \
		uniq -c | \
		sort -nr | \
		mawk '(NR > 1) {print $2}' > \
		${PROCESSED_DIRECTORY}/venues_sorted_by_count
