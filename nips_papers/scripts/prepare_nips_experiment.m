clear;

processed_directory = '../processed/';
top_venues_directory = '../processed/top_venues/';

load([processed_directory 'edge_list']);
load([processed_directory 'nips_paper_ids']);
load([processed_directory 'granch_nearest_neighbors']);
load([top_venues_directory 'top_venue_ids']);

num_nodes = max(edge_list(:));
num_edges = size(edge_list, 1);

A = sparse(edge_list(:, 1), edge_list(:, 2), ones(num_edges, 1), ...
           num_nodes, num_nodes);
A = (A + A') > 0;

[num_components, assignments] = graphconncomp(A, 'Directed', false);
component_sizes = histc(assignments, 1:num_components);
[size_largest, largest] = max(component_sizes);

to_keep = find(assignments == largest);
connected = A(to_keep, to_keep);

reverse_map = zeros(num_nodes, 1);
reverse_map(to_keep) = 1:size_largest;
nips_index = reverse_map(nips_paper_ids);
nips_index = nips_index(nips_index > 0);

W = sparse(granch_nearest_neighbors(:, 1), granch_nearest_neighbors(:, 2), ...
           granch_nearest_neighbors(:, 3), num_nodes, num_nodes);
W = W - diag(diag(W));

connected_W = W(to_keep, to_keep);

save([processed_directory '/nips_graph'], 'A', 'num_components', ...
     'assignments', 'connected', 'nips_paper_ids', 'nips_index', ...
     'reverse_map', 'W', 'connected_W');

A = A(top_venue_ids, top_venue_ids);

num_nodes = size(A, 1);

[num_components, assignments] = graphconncomp(A, 'Directed', false);
component_sizes = histc(assignments, 1:num_components);
[size_largest, largest] = max(component_sizes);

to_keep = find(assignments == largest);
connected = A(to_keep, to_keep);

reverse_map(:) = 0;
reverse_map(top_venue_ids) = 1:length(top_venue_ids);
nips_paper_ids = reverse_map(intersect(top_venue_ids, nips_paper_ids));

reverse_map = zeros(num_nodes, 1);
reverse_map(to_keep) = 1:length(to_keep);
nips_index = reverse_map(nips_paper_ids);
nips_index = nips_index(nips_index > 0);

W = W(top_venue_ids, top_venue_ids);
connected_W = W(to_keep, to_keep);

save([top_venues_directory '/top_venues_graph'], 'A', 'num_components', ...
     'assignments', 'connected', 'nips_paper_ids', 'nips_index', ...
     'reverse_map', 'W', 'connected_W');

num_observations = size(connected, 1);
num_components = 20;

D = sum(connected);
L = diag(D) - connected;

[u s] = svds(L, num_components + 1, 0);

u = u(:, 1:num_components);
s = s(1:num_components, 1:num_components);

data = u / s;

save([top_venues_directory '/nips_graph_pca_vectors'], 'data');