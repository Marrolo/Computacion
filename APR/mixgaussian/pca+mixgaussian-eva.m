#! /snap/bin/octave -qf

if (nargin!=7)
printf("Usage: pca+mixgaussian-eva.m <trdata> <trlabels> <pcaKs> <Ks> <alphas>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
pcaKs = str2num(arg_list{5});
K = str2num(arg_list{6});
alpha=str2num(arg_list{7});


load(trdata);
load(trlabs);
load(tedata);
load(telabs);

printf("\n  alpha  pca  Ks  dv-err");
printf("\n-------  ---  --- ------\n");

[m,trDataPCA] = pca(X);
proyX = (X -m) * trDataPCA(:,1:pcaKs);
proyY = (Y-m)*trDataPCA(:,1:pcaKs);

edv = mixgaussian(proyX,xl,proyY,yl,K,alpha);
printf("%.1e %3d %3d %6.3f\n\n\n",alpha,pcaKs,K,edv);

acurancia = (1 -edv /100);
intervalo=1.96*sqrt((edv /100*acurancia)/length(yl));
printf(" Error:%.4d \t Intervalo de confianza [%.4d , %4d]\n",edv,edv - intervalo, edv + intervalo);