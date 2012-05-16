venue_subgraph_directory = '../processed/venue_subgraph/';

load([venue_subgraph_directory 'edge_list']);
load([venue_subgraph_directory 'positive_node_ids']);

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
positive_node_ids = reverse_map(positive_node_ids);
connected_positive_node_ids = positive_node_ids(positive_node_ids > 0);

save([venue_subgraph_directory 'venue_subgraph'], 'A', 'num_components', ...
     'assignments', 'connected', 'positive_node_ids', ...
     'connected_positive_node_ids', 'reverse_map');

num_observations = size(connected, 1);
num_principal_components = 20;

D = sum(connected);
L = diag(D) - connected;

[u, s] = svds(L, num_principal_components + 1, 0);

u = u(:, 1:num_principal_components);
s = s(1:num_principal_components, 1:num_principal_components);

data = u / s;

save([venue_subgraph_directory '/connected_venue_graph_pca_vectors'], 'data');
