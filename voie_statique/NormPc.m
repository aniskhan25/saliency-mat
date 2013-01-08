function X = NormPc(X,pc)
% pc = 0.1;
M = max(X(:));
level = pc*M;
X(find(X<=level)) = 0;
X(find(X>level)) = (X(find(X>level)) - level)/(M-level)*M;