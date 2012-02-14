data_directory = '../raw/';
processed_directory = '../processed/';

load([data_directory 'sdss_data_Spectrum'], 'X', 'group_id');

data = X;
responses = group_id;

save([processed_directory 'galaxy_clusters'], 'data', 'responses');