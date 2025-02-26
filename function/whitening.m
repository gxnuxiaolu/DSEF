function [x] = whitening(X,s,d,u)
epsilon = 1*10^(-5);
xPCAWhite = X * diag(1./((diag(s)+epsilon) .^ (1/2.5)));
xPCAWhite(isnan(xPCAWhite)) = 0;
x = xPCAWhite(:,1:d);
end

