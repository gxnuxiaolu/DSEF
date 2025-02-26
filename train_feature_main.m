%% example code
clear;
addpath('function');
image_set = {'Oxford5k';'Paris6k';'Oxford105k';'Paris106k';'Holidays';...
    'roxford5k';'rparis6k';'roxford105k';'rparis106k'};
temp_set = image_set{2};
% The training set of pca should correspond to the test set
if strcmp(temp_set,"Oxford5k")
    load(['../datasets/',temp_set,'/gnd_oxford5k.mat']);
elseif strcmp(temp_set,"Paris6k")
    load(['../datasets/',temp_set,'/gnd_paris6k.mat']);
elseif strcmp(temp_set,"Holidays")
    load(['../datasets/',temp_set,'/gnd_holidays.mat']);
elseif strcmp(temp_set,"Oxford105k")
    load('../datasets/Oxford5k/gnd_oxford5k.mat');
elseif strcmp(temp_set,"Paris106k")
    load('../datasets/Paris6k/gnd_paris6k.mat');
elseif strcmp(temp_set,"rparis6k")
    load('../datasets/Paris6k/gnd_rparis6k.mat');
elseif strcmp(temp_set,"roxford5k")
    load('../datasets/Oxford5k/gnd_roxford5k.mat');
end
net = vgg19;
num = size(feature_name,1);
t = net.Layers(1).InputSize(1);
test_feature = [];
for i = 1:num
    path = ['..\datasets\',temp_set,'\photo\',cell2mat(feature_name(i,1)),'.jpg'];
    this_img = imread(path);
    if size(this_img,1)<t
        t2 = size(this_img,2);
        this_img = imresize(this_img,[t,t2]);
    end
    if size(this_img,2)<t
        t1 = size(this_img,1);
        this_img = imresize(this_img,[t1,t]);
    end
    feature_mat = activations(net,this_img,'pool5','OutputAs','channels');
    train_feature(i,:) = DSEF_Representation(feature_mat,this_img);
end
save('./representation/train_feature.mat','train_feature');



