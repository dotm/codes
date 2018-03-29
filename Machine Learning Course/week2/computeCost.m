function J = computeCost(X, y, theta)
  %COMPUTECOST Compute cost for linear regression
  %   J = COMPUTECOST(X, y, theta) computes the cost of using theta as the
  %   parameter for linear regression to fit the data points in X and y
  %   X is already injected with x_0 as ones vector to represent the intercept

  m = length(y); % number of training examples
  J = 0;

  % Compute the cost of a particular choice of theta
  expectedResult_vector = X * theta;
  actualResult_vector = y;
  error_vector = expectedResult_vector - actualResult_vector;
  squareError_vector = error_vector .^ 2;
  sumSquareError = sum(squareError_vector);
  cost = sumSquareError / (2*m);

  J = cost;
end
