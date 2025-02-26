function [F] = sefm(X,im)

[hei,wid,~] = size(X);

imdata = imresize(im, [hei wid]);

data = 200;
if hei*wid <data
    data = hei*wid;
end

CV = saliency_filters(imdata,data);

[~, ~, Gv, Gh] = edge(CV,'Sobel');

grad = sqrt(Gv.*Gv + Gh.*Gh);

F = log(1+grad);


end
