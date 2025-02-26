function [arr] = DSEF_Representation(X,im)

F = sefm(X,im);

arr = spatial_channel_weight(X,F);

end