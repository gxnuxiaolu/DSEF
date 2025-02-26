%% example code
clear;
addpath('function');
cnn = 'matlab_vgg19';
image_set = {'Oxford5k';'Paris6k';'Oxford105k';'Paris106k';'Holidays';...
    'roxford5k';'rparis6k';'roxford105k';'rparis106k'};
temp_set = image_set{2};
if strcmp(temp_set,"Oxford5k")
    load(['.\datasets\',temp_set,'\gnd_oxford5k.mat']);
elseif strcmp(temp_set,"Paris6k")
    load(['.\datasets\',temp_set,'\gnd_paris6k.mat']);
elseif strcmp(temp_set,"Holidays")
    load(['..\datasets\',temp_set,'\gh_holidays.mat']);
elseif strcmp(temp_set,"Oxford105k")
    load('.\datasets\Oxford5k\gnd_oxford5k.mat');
elseif strcmp(temp_set,"Paris106k")
    load('.\datasets\Paris6k\gnd_paris6k.mat');
elseif strcmp(temp_set,"rparis6k")
    load('.\datasets\Paris6k\gnd_rparis6k.mat');
elseif strcmp(temp_set,"roxford5k")
    load('.\datasets\Oxford5k\gnd_roxford5k.mat');
end
net = vgg19;
num = size(feature_name,1);
t = net.Layers(1).InputSize(1);
test_feature = [];
for i = 1:num
    path = ['.\datasets\',temp_set,'\photo\',cell2mat(feature_name(i,1)),'.jpg'];
    this_img = imread(path);
    % this_img = imresize(this_img,0.5); holidays
    if size(this_img,1)<t
        t2 = size(this_img,2);
        this_img = imresize(this_img,[t,t2]);
    end
    if size(this_img,2)<t
        t1 = size(this_img,1);
        this_img = imresize(this_img,[t1,t]);
    end
    feature_mat = activations(net,this_img,'pool5','OutputAs','channels');
    test_feature(i,:) = DSEF_Representation(feature_mat,this_img);
end
save('./representation/test_feature.mat','test_feature');

% query
query_num = size(query_list,1);
t = net.Layers(1).InputSize(1);
query_feature = [];
if strcmp(temp_set,'Holidays')
    d = cell2mat(query_list(:,2,:));
    query_feature = test_feature(d,:);
    save('./representation/query_feature.mat','query_feature');
else
    for i = 1:query_num
        path = ['.\datasets\',temp_set,'\photo\',cell2mat(query_list(i,1)),'.jpg'];
        rect = gnd(i).bbx;
        this_img = imread(path);
        this_img = imcrop(this_img, rect);
        if size(this_img,1)<t
            t2 = size(this_img,2);
            this_img = imresize(this_img,[t,t2]);
        end
        if size(this_img,2)<t
            t1 = size(this_img,1);
            this_img = imresize(this_img,[t1,t]);
        end
        feature_mat = activations(net,this_img,'pool5','OutputAs','channels');
        query_feature(i,:) = DSEF_Representation(feature_mat,this_img);
    end
    save('./representation/query_feature.mat','query_feature');
end

% compute mAP 
% Whether to perform  QE. If you execute QE, please set the size of K.
% For example, K is equal to top 10. K = 10;
K = 0;

mAP = zeros(1,3);
dim = [128,256,512];
fprintf('------------------------------------\n');


for i = 1:size(dim,2)
    load('./representation/query_feature.mat');
    load('./representation/test_feature.mat');
    load('./representation/train_feature.mat');
    [test_feature,query_feature] = pca_whitening(test_feature,train_feature,query_feature,dim(i));
    mAP(i) = compute(test_feature,query_feature,K,temp_set);
    fprintf('dim = %d  mAP = %.4f\n',dim(i),mAP(i));
end

rmpath('function');
