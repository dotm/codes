function [J, grad] = costFunction(theta, X, y)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
%
% Note: grad should have the same dimensions as theta
%
hypothesis_result_vector = sigmoid(X * theta);

cost_ifPositiveResult_vector = -y .* log(hypothesis_result_vector);
cost_ifNegativeResult_vector = (1-y) .* log(1 - hypothesis_result_vector);
summation_forCost = sum(cost_ifPositiveResult_vector - cost_ifNegativeResult_vector);
cost = summation_forCost / m;
J = cost;

summation_forGradient_vector = X' * (hypothesis_result_vector - y);
grad = summation_forGradient_vector / m;
% =============================================================

end
