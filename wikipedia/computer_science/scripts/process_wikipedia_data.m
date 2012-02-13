processed_directory = '../processed/topics/';
load([processed_directory 'sparse_wikipedia_topic_vectors']);

num_neighbors = 100;

data = sparse(sparse_wikipedia_topic_vectors(:, 1), ...
              sparse_wikipedia_topic_vectors(:, 2), ...
              sparse_wikipedia_topic_vectors(:, 3));
data = full(data);

num_pages = size(data, 1);

neighbors = zeros(num_pages, num_neighbors);
similarities = zeros(num_pages, num_neighbors);

block_size = 1000;

norms = sqrt(sum(data.^2, 2));

for i = 1:floor(num_pages / block_size)
  tic;

  range = (1 + (i - 1) * block_size):min(i * block_size, num_pages);
  this_pages = data(range, :);
  
  dot_products = data * this_pages' ./ ...
                 repmat(norms, 1, block_size) ./ ...
                 repmat(norms(range)', num_pages, 1);

  [this_similarities this_neighbors] = sort(dot_products, 'descend');

  similarities(range, :) = this_similarities(2:(num_neighbors + 1), :)';
  neighbors(range, :) = this_neighbors(2:(num_neighbors + 1), :)';

  elapsed = toc;
  disp(['done ' num2str(max(range)) ' of ' num2str(num_pages) ' (' ...
        num2str(max(range) / num_pages * 100) '%), took: ' num2str(elapsed) 's.']);
end

save([processed_directory '/wikipedia_topic_vectors'], 'similarities', ...
     'neighbors', 'data');

format_string = [repmat('%i ', 1, num_neighbors) '\n'];

fid = fopen([processed_directory '/neighbors'], 'w');
fprintf(fid, format_string, neighbors');
fclose(fid);

format_string = [repmat('%f ', 1, num_neighbors) '\n'];

fid = fopen([processed_directory '/similarities'], 'w');
fprintf(fid, format_string, similarities');
fclose(fid);
