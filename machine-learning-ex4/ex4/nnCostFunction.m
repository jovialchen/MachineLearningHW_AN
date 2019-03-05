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
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.

% recode the y vector
y_matrix = zeros(num_labels,m);
for i=1:m,
	if(y(i)>num_labels)
		disp('wrong input')
		break
	end
	y_matrix(y(i),i) = 1;
end


%compute the cost value
X = [ones(m,1),X];
activation_1 = X';

z2 = Theta1*activation_1;
activation_2 = sigmoid(z2);
activation_2 = [ones(1,m);activation_2];

z3 = Theta2*activation_2;
activation_3 = sigmoid(z3);

h_theta_X = activation_3;

%compute cost function
regTheta1 =  Theta1;
regTheta1(:,1) = zeros(hidden_layer_size,1);
regTheta2 =  Theta2;
regTheta2(:,1) = zeros(num_labels,1);
J = sum(sum((1/m)*(-y_matrix.*log(h_theta_X)-(1.-y_matrix).*log(1.-h_theta_X))))+(lambda/(2*m))*(sum(sum(regTheta1.*regTheta1))+sum(sum(regTheta2.*regTheta2)));


%back propagation
delta_3 = activation_3.-y_matrix;
delta_2 = (Theta2'*delta_3)(2:end,:).* sigmoidGradient(z2);

D_2 = delta_3*activation_2';
D_1 = delta_2*activation_1';

Theta1_grad = (1/m).*(D_1) + (lambda/m).*regTheta1;
Theta2_grad = (1/m).*(D_2) + (lambda/m).*regTheta2;


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
