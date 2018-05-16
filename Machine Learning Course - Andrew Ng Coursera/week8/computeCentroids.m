function centroids = computeCentroids(X, idx, K)
%COMPUTECENTROIDS returns the new centroids by computing the means of the 
%data points assigned to each centroid.
%   centroids = COMPUTECENTROIDS(X, idx, K) returns the new centroids by 
%   computing the means of the data points assigned to each centroid. It is
%   given a dataset X where each row is a single data point, a vector
%   idx of centroid assignments (i.e. each entry in range [1..K]) for each
%   example, and K, the number of centroids. You should return a matrix
%   centroids, where each row of centroids is the mean of the data points
%   assigned to it.
%

% Useful variables
[m n] = size(X);

% You need to return the following variables correctly.
centroids = zeros(K, n);

% ====================== YOUR CODE HERE ======================
% Instructions: Go over every centroid and compute mean of all points that
%               belong to it. Concretely, the row vector centroids(i, :)
%               should contain the mean of the data points assigned to
%               centroid i.
%
% Note: You can use a for-loop over the centroids to compute this.
%
%X 300x2 (m*dimension)
%centroids 3x2 (total_centroid*dimension)
%idx 300x1
%new_centroids 3x2 (total_centroid*dimension)
new_centroids = zeros(K, n);
for i = 1:size(centroids,1) %1:3
  totalCount_examples_assignedTo_thisCentroid = sum(idx==i);
  sumOfExamples_of_thisCentroid = sum(X .* (idx==i));
  mean_of_thisCentroid = sumOfExamples_of_thisCentroid/totalCount_examples_assignedTo_thisCentroid;
  new_centroids(i,:) = mean_of_thisCentroid;
end

centroids = new_centroids;
% =============================================================


end

