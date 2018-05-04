function idx = findClosestCentroids(X, centroids)
%FINDCLOSESTCENTROIDS computes the centroid memberships for every example
%   idx = FINDCLOSESTCENTROIDS (X, centroids) returns the closest centroids
%   in idx for a dataset X where each row is a single example. idx = m x 1 
%   vector of centroid assignments (i.e. each entry in range [1..K])
%

% Set K
K = size(centroids, 1);

% You need to return the following variables correctly.
idx = zeros(size(X,1), 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Go over every example, find its closest centroid, and store
%               the index inside idx at the appropriate location.
%               Concretely, idx(i) should contain the index of the centroid
%               closest to example i. Hence, it should be a value in the 
%               range 1..K
%
% Note: You can use a for-loop over the examples to compute this.
%

%X 300*2 (m*dimension)
%centroids 3*2 (total_centroid*dimension)
%distance_fromX_toCentroids 300*3
distance_fromX_toCentroids = zeros(size(X,1),size(centroids,1));
for i = 1:size(X,1) %1:300
  distance_from_oneExample_toEachCentroids = zeros(1,size(centroids,1));
  for j = 1:size(centroids,1) %1:3
    distance_from_oneExample_toEachCentroids(j) = norm( X(i,:) - centroids(j,:) );
  end
  distance_fromX_toCentroids(i,:) = distance_from_oneExample_toEachCentroids;
end
%indexOf_min_distance 300 1
[min_value, min_index] = min(distance_fromX_toCentroids,[],2);
idx = min_index;
% =============================================================

end

