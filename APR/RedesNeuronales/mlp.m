% Computes the error rate on the evaluation set Y of the 
% neural network classifier trained on X
% Xtr  is a n x d training data matrix 
% xltr is a n x 1 training label vector
% Xdv  is a n x d validation data matrix, when to stop training  
% xldv is a n x 1 validation label vector 
% Y is a m x d evaluation data matrix
% yl is a m x 1 evaluation label vector 
% nHiddens is the number of neurons in the hidden layer
% epochs is the max number of epochs, one epoch is an iteration over all data 
% show is the number of epocchs  done before showing the value of the objective function
% seed is the seed generetor of random numbers


function [errY] = mlp(Xtr,xltr,Xdv,xldv,Y,yl,nHidden,epochs,show,seed)

Xtr = Xtr'; xltr=xltr'; Xdv=Xdv'; xldv=xldv'; Y=Y'; yl=yl';

%Normalice data
[Xtrnorm,Xtrmean,Xtrstd] = prestd(Xtr);
%normaliced validation data
XdvNN.P = trastd(Xdv,Xtrmean,Xtrstd);
XdvNN.T = onehot(xldv);

classes = unique(xltr');
nOutput = length(classes);

%Initialice NN
initNN = newff(minmax(Xtrnorm), [nHidden nOutput], 
{"tansig","logsig"}, "trainlm", "", "mse");
initNN.trainParam.show = show;
initNN.trainParam.epochs = epochs;
rand("seed",seed);

NN = train(initNN,Xtrnorm,onehot(xltr),[],[],XdvNN);

Ynorm = trastd(Y,Xtrmean,Xtrstd);
Yout = sim(NN,Ynorm);

[number,clasification] = max(Yout);

estimation = classes(clasification)';
err = (estimation != yl);
[errY] = mean(err) *100;



