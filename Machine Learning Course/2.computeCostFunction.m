function J = computeCost(X, y, theta)
%COMPUTECOST Compute cost for linear regression
%   J = COMPUTECOST(X, y, theta) computes the cost of using theta as the
%   parameter for linear regression to fit the data points in X and y
%   X is already injected with x_0 as ones vector to represent the intercept

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta
%               You should set J to the cost.
expectedResult_vector = (theta' * X')';
actualResult_vector = y;
error_vector = expectedResult_vector - actualResult_vector;
squareError_vector = error_vector .^ 2;
sumSquareError = sum(squareError_vector);
cost = sumSquareError / (2*m);

J = cost;
% =========================================================================

end
