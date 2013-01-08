function X = NormItti(X)
average = mean(mean(X));
globalmax = max(max(X));
X = (globalmax - average)^2*X;