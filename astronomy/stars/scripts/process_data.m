data_directory = '../raw/';
processed_directory = '../processed/';

load([data_directory 'simbad'], 'obj_type', 'spec_ids');

responses = obj_type;
labeled = spec_ids;

load([data_directory 'feature_Mask']);

mask = bitand(uint32(feature), 464977934);

load([data_directory 'feature_Spectrum']);

[~, small_ind, big_ind] = intersect(labeled, spec_ids);

feature(feature < 0) = 0;
feature(mask > 0) = 0;

feature = bsxfun(@rdivide, feature, sum(feature, 2));
data = feature(big_ind, :);
responses = responses(small_ind);

save([processed_directory 'stars'], 'data', 'responses');