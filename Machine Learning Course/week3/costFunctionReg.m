function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

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
hypothesis_result_vector = sigmoid(X * theta);

cost_ifPositiveResult_vector = -y .* log(hypothesis_result_vector);
cost_ifNegativeResult_vector = (1-y) .* log(1 - hypothesis_result_vector);
summation_forCost = sum(cost_ifPositiveResult_vector - cost_ifNegativeResult_vector);
cost = summation_forCost / m;

nonIntercept_theta = theta(2:length(theta));
summation_forRegularization = sum(nonIntercept_theta .^ 2);
regularization_term = (lambda * summation_forRegularization) / (2*m);

J = cost + regularization_term;

summation_forGradient_vector = X' * (hypothesis_result_vector - y);
grad = summation_forGradient_vector / m;
%add regularization terms derivatives to gradient of nonIntercept_theta
grad(2:length(grad)) += (lambda/m) * theta(2:length(theta));

% =============================================================

end
