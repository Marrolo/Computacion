#!/usr/bin/octave -qf
addpath("nnet_apr");

if (nargin!=6)
printf("Usage: pca+mlp-exp.m <trdata> <trlabels> <pcaKs> <nHiddens> <%%trper> <%%dvper>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
pcaKs = str2num(arg_list{3});
nHiddens = str2num(arg_list{4});
trper=str2num(arg_list{5});
dvper=str2num(arg_list{6});

load(trdata);
load(trlabs);

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

show=10;
epochs=300;

printf("\n  pca   nHiddens    dv-err");
printf("\n-----  ----------  ---------\n");

for k =1:length(pcaKs)
  pcaXtr = Xtr * W(:,1:pcaKs(k));
  pcaXdv = Xdv * W(:,1:pcaKs(k));
  for j=1:length(nHiddens)
    edv = mlp(pcaXtr,xltr,pcaXdv,xldv,pcaXdv,xldv,nHiddens(j),epochs,show,seed);
    printf("%3d %3d %6.3f\n",pcaKs(k),nHiddens(j),edv);
  end
end
