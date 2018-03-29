function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters)
  %GRADIENTDESCENT Performs gradient descent to learn theta
  %   theta = GRADIENTDESCENT(X, y, theta, alpha, num_iters) updates theta by 
  %   taking num_iters gradient steps with learning rate alpha

  m = length(y); % number of training examples
  J_history = zeros(num_iters, 1);

  for iter = 1:num_iters

      % Perform a single gradient step on the parameter vector theta.
      oldTheta_vector = theta;
      expectedResult_vector = X * theta;
      actualResult_vector = y;
      error_vector = expectedResult_vector - actualResult_vector;

      summation_vector = X' * error_vector;
      costFunctionDerivative_vector = (alpha/m) * summation_vector;
      newTheta_vector = oldTheta_vector - costFunctionDerivative_vector;

      theta = newTheta_vector;

      % Save the cost J in every iteration    
      J_history(iter) = computeCost(X, y, theta);

  end

end