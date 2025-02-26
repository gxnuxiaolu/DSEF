function arr = spatial_channel_weight(X,F)

[hei,wid,K] = size(X);

S = zeros(hei,wid,K);

XF = zeros(hei,wid,K);


for i=1:K
    [~, ~, Gv, Gh] = edge(X(:,:,i),'Sobel');
    S(:,:,i) = sqrt(Gv.*Gv + Gh.*Gh);
    XF(:,:,i) = S(:,:,i).*F;  

end

nonzeros = zeros([1,K]);
for i=1:K
    nonzeros(i) = numel(X(:,:,i),X(:,:,i)>F(:,:),X(:,:,i)<S(:,:,i));
end
nzsum = sum(nonzeros);
for i=1:length(nonzeros)
    if nonzeros(i) == 0
        nonzeros(i) = 0;
    else
        nonzeros(i) = log(nzsum/nonzeros(i));
    end
end
%% 特征聚合

Sw = feature_aggregation(XF);


arr = Sw .* nonzeros;


end