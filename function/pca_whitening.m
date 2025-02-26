function [X,Q] = pca_whitening(XText,XTrain,XQ,d)

    XText = normalize(XText,2,'norm');
    XTrain = normalize(XTrain,2,'norm');
    temp = isnan(XText);
    XText(temp) = 0;
    temp = isnan(XTrain);
    XTrain(temp) = 0;



    [ mu, s, u, ~ , XT] = p_c_a (XTrain,XText,d);
    X = whitening (XT,s,d);
    X = normalize(X,2,'norm');

    XQ = normalize(XQ,2,'norm');
    xq = (XQ - mu) * u;
    Q = whitening (xq,s,d);
    Q = normalize(Q,2,'norm');

end

