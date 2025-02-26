function [sw] = feature_aggregation(x)

[h,w,~] = size(x);

t = (h^2+w^2)^(1/2);
c = zeros(h,w);
for i = 1:h
    y1 = (i-h/2)^2;
    for j = 1:w
        x1 = (j-w/2)^2;
        c(i,j) = exp(-((y1+x1)^(1/2))/t);
    end
end
x = x.*c;
sw = permute(sum(x,[1,2]),[1,3,2]);
end

