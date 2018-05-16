function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%

%Y 5*4
%R 5*4
%Theta 4*3
%X 5*3
expected_rating_matrix = X * Theta';
actual_rating_matrix = Y;
%difference_ofRating_matrix 5*4
difference_ofRating_matrix = (expected_rating_matrix .* R) - actual_rating_matrix;
squared_difference_ofRating_matrix = difference_ofRating_matrix .^ 2;
J = sum(sum(squared_difference_ofRating_matrix)) / 2;

%X_grad 5*3
%difference_ofRating_matrix 5*4
%Theta 4*3
X_grad = difference_ofRating_matrix * Theta;
%Theta_grad 4*3
Theta_grad = difference_ofRating_matrix' * X;

% =============================================================
%  With Regularization
regularization_term = ((lambda/2) * sum(sum(Theta .^ 2))) + ((lambda/2) * sum(sum(X .^ 2)));
J = J + regularization_term;

X_grad = X_grad + (lambda * X);
Theta_grad = Theta_grad + (lambda * Theta);

% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
