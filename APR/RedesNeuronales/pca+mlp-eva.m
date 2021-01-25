#!/usr/bin/octave -qf
addpath("nnet_apr");

if (nargin!=8)
printf("Usage: mlp-eva.m <trdata> <trlabels> <tedata> <telabels> <pcaKs> <nHiddens> <%%trper> <%%dvper>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
pcaKs=str2num(arg_list{5});
nHiddens=str2num(arg_list{6});
trper=str2num(arg_list{7});
dvper=str2num(arg_list{8});

load(trdata);
load(trlabs);
load(tedata);
load(telabs);

N=rows(X);
seed=23; rand("seed",seed); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); 
xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);


[m W] = pca(Xtr);

%Los vectores de proyección en W están por columnas
Xtr = Xtr-m;
Xdv = Xdv - m;
Yet= Y-m;

show=10;
epochs=300;

printf("\n  pca   nHiddens    dv-err");
printf("\n-----  ----------  ---------\n");

pcaXtr = Xtr * W(:,1:pcaKs);
pcaXdv = Xdv * W(:,1:pcaKs);
pcaY = Yet * W(:,1:pcaKs);

edv = mlp(pcaXtr,xltr,pcaXdv,xldv,pcaY,yl,nHiddens,epochs,show,seed);
acurancia = (1 -edv /100);
intervalo=1.96*sqrt((edv /100*acurancia)/length(yl));
printf(" Error:%.4d \t Intervalo de confianza [%.4d , %4d]\n",edv,edv - intervalo, edv + intervalo)

