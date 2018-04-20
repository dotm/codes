function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%

expectedResult_vector = X * theta;
actualResult_vector = y;
error_vector = expectedResult_vector - actualResult_vector;
squareError_vector = error_vector .^ 2;
sumSquareError = sum(squareError_vector);
cost = sumSquareError / (2*m);

theta_withoutIntercept = theta(2:end, :);
squareTheta = theta_withoutIntercept .^ 2;
sumSquareTheta = sum(squareTheta);
regularization_term = (sumSquareTheta * lambda)/ (2*m);

J = cost + regularization_term;

% size(error_vector) 12 1
% X 12 2
% grad 2 1
derivative_vector = (X' * error_vector) / m;
grad = derivative_vector;
regularizationDerivative_vector = (lambda * theta_withoutIntercept)/m;
grad(2:end, :) = grad(2:end, :) + regularizationDerivative_vector;

% =========================================================================

grad = grad(:);

end
