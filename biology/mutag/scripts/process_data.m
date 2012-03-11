data_directory      = '../data/';
processed_directory = '../processed/';

load([data_directory 'MUTAG'], 'MUTAG');

raw_data = MUTAG;
clear MUTAG;

num_graphs = numel(raw_data);

total_nodes = 0;
graph_ind = [];
responses = [];

for i = 1:num_graphs
  node_labels = raw_data(i).nl.values;
  num_nodes = numel(node_labels);
  total_nodes = total_nodes + num_nodes;
  graph_ind = [graph_ind; i * ones(num_nodes, 1)];
  responses = [responses; node_labels];
end

data = sparse(total_nodes, total_nodes);

for i = 1:num_graphs
  ind = (graph_ind == i);
  data(ind, ind) = sparse(raw_data(i).am);
end

save([processed_directory 'mutag'], 'data', 'responses', 'graph_ind');