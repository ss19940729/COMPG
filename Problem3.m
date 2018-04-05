clc;clear;close all;
%load data 
load('x_train.mat');
load('y_train.mat');

X = double(x_train);
Y = double(y_train);
%fit and get predict_CTR 
mdl = fitglm(X,Y);
avg_CTR = 0.0737562325662;
preCTR = predict(mdl,X);
%% plot 
figure;
subplot(1,2,1);
bar(preCTR);
subplot(1,2,2);
bar(Y);

bid_base = 1:20;
budget = 6250;
click = Y;
pay_price = X(:,5);
sum_click = zeros(length(bid_base),1);
impressions = zeros(length(bid_base),1);

CTR = zeros(length(bid_base),1);
CPM = zeros(length(bid_base),1);
CPC = zeros(length(bid_base),1);
%find the best base bid
for j= 1:length(bid_base)
    budget = 6250;
    for i =1:size(preCTR)
      if budget>0
          bid_price = bid_base(j) * (preCTR(i) / avg_CTR);
          
          if budget > bid_price && bid_price > pay_price(i)
              sum_click(j) = sum_click(j)+click(i);
              impressions(j) = impressions(j)+1;
              budget = budget - pay_price(i);
          end
      else
          break;
      end
    end
    if impressions(j)==0
        CTR(j) = 0;
        CPM(j) = 0;
    else
        CTR(j) = (sum_click(j)/ impressions(j));
        CPM(j) = (6250-budget)/impressions(j);
    end
    if sum_click(j) == 0
        CPC(j) = 0;
    else 
        CPC(j) = (6250-budget)/sum_click(j);
    end
   
end
figure;
plot(bid_base,sum_click);
xlabel('Base Bid');
ylabel('Click');
[max_click, max_index] = max(sum_click)
CPC(max_index)
CPM(max_index)