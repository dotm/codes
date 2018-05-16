data = [
  1   2;
  3   6;
  10  20;
  30  60;
  100 200
  ];
input_vector = data(:, 1);
output_vector = data(:, 2);

total_trainingExample = length(output_vector);
input_matrix = [ones(total_trainingExample, 1), input_vector];
[m,n] = size(input_matrix)
theta = zeros(n, 1); % initialize fitting parameters to zeros

% Some gradient descent settings
iterations = 15;
alpha = 0.0003;

[result_theta, cost_history] = gradientDescent(input_matrix, output_vector, theta, alpha, iterations);