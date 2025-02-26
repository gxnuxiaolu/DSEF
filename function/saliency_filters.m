function S= saliency_filters(im,SN)

[hei,wid,~] = size(im);

S = zeros(hei,wid);
hei1 = round(hei / 2);
wid1 = round(wid / 2);
[L,N] = superpixels(im,SN);

count =  zeros(1,N);
csumX =  zeros(1,N);
csumY =  zeros(1,N);
colorareas = zeros(N,3);


for k=1:N
    
    [row,col] = find(L==k);
    
    numRow=size(row,1);
    
    count(k) = numRow;

    for m=1:numRow
        
        colorareas(k,1) =colorareas(k,1)+ im(row(m),col(m),1);
        colorareas(k,2) =colorareas(k,2)+ im(row(m),col(m),2);
        colorareas(k,3) =colorareas(k,3)+ im(row(m),col(m),3);

    end
    csumX(1,k) = (max(col) - min(col)+1) / wid;
    csumY(1,k) = (max(row) - min(row)+1) / hei;
end



colorareas = bsxfun(@rdivide,colorareas,count');




sal = zeros(1,N);

for m=1:N
    for n=1:N
        T00 = (colorareas(m,1) - colorareas(n,1)).^2;
        T11 = (colorareas(m,2) - colorareas(n,2)).^2;
        T22 = (colorareas(m,3) - colorareas(n,3)).^2;
     
        dist =((csumX(1,m) - csumX(1,n)).^2 + (csumY(1,m)- csumY(1,n)).^2) .^ (1/2);


        dist1 = (hei.^2 + wid.^2) .^ (1/2);
        wei = dist1 - log(dist+1);
       
       sal(1,m) = sal(1,m)+ wei * max(log((T00 + T11 + T22).^2), 0.0);
 
       
    end
    wmc = ((csumX(1,m) - wid1).^2 + (csumY(1,m)- hei1).^2) .^ (1/2);


    dist1 = (hei1.^2 + wid1.^2) .^ (1/2);
    mic = dist1 - log(wmc+1);
    sal(1,m) = sal(1,m)*mic ;

end



for k=1:N
    [row,col] = find(L==k);
    numRow=size(row,1);
    for m=1:numRow
        S(row(m),col(m)) = sal(1,k);
    end
end

end