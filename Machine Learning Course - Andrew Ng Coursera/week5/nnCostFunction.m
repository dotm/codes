function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%

%FORWARD PROPAGATION

%X 5000 400
X = [ones(m, 1) X];
a1 = X;
%X 5000 401

%size(Theta1) 25 401
%a2 5000 25
z2 = a1 * Theta1';
a2 = sigmoid(z2);
%a2 5000 26
a2 = [ones(m, 1) a2];

%size(Theta2) 10 26
%Output_Layer 5000 10
z3 = a2 * Theta2';
a3 = sigmoid(z3);
Output_Layer = a3;

%y 5000 1
%K (num_labels is scalar 10) 1 1
%m (is scalar 5000) 1 1
y_matrix = repmat(1:num_labels, m, 1);
y_matrix = y_matrix == y;
%y_matrix 5000 10

cost_ifPositiveResult_matrix = (-y_matrix) .* log(Output_Layer);
cost_ifNegativeResult_matrix = (1-y_matrix) .* log(1-Output_Layer);
cost_matrix = cost_ifPositiveResult_matrix - cost_ifNegativeResult_matrix;
sum_of_cost = sum(sum(cost_matrix));
total_cost = sum_of_cost / m;

J = total_cost;

%WITH REGULARIZATION
firstLayerTheta_withoutBiasUnit = Theta1(:, 2:end);
secondLayerTheta_withoutBiasUnit = Theta2(:, 2:end);
squared_firstLayerTheta = firstLayerTheta_withoutBiasUnit .^ 2;
squared_secondLayerTheta = secondLayerTheta_withoutBiasUnit .^ 2;
sumSquare_of_firstLayerTheta = sum(sum(squared_firstLayerTheta));
sumSquare_of_secondLayerTheta = sum(sum(squared_secondLayerTheta));
regularization_term = (lambda/(2*m)) * (sumSquare_of_firstLayerTheta + sumSquare_of_secondLayerTheta);

J = J + regularization_term;

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
%d3 5000 10
d3 = Output_Layer - y_matrix;

%z2 5000 25
z2 = [ones(m, 1) z2];
%z2 5000 26

%size(Theta2) 10 26
%d2 5000 26
d2 = (d3 * Theta2) .* sigmoidGradient(z2);

%a1 5000 401
%size(Theta1) 25 401
%accumulatedDelta_firstLayer 25 401
accumulatedDelta_firstLayer = (d2(:, 2:end))' * a1;

%a2 5000 26
%d3 5000 10
%size(Theta2) 10 26
%accumulatedDelta_secondLayer 10 26
accumulatedDelta_secondLayer = d3' * a2;

Theta1_grad = accumulatedDelta_firstLayer / m;
Theta2_grad = accumulatedDelta_secondLayer / m;

% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
regularizationTerm_Theta1 = (lambda/m) * Theta1(:, 2:end);
Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + regularizationTerm_Theta1;

regularizationTerm_Theta2 = (lambda/m) * Theta2(:, 2:end);
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + regularizationTerm_Theta2;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
