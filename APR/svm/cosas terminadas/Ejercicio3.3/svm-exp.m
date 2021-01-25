#! /snap/bin/octave -qf
addpath('libreria');
%carga de datos
%load ../datos/mini/trSep.dat;
%load ../datos/mini/trSeplabels.dat;
load ../datos/mnist/train-images-idx3-ubyte.mat.gz
load ../datos/mnist/train-labels-idx1-ubyte.mat.gz
%Entrenamiento modelo

C = [1 10 100 500 1000 2000];
grados = [1 2 3 4 5 6 7];
trper = 90;
dvper = 10;


N=rows(X);
seed=23; rand("seed",seed); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);


filename = "Resultados.out";
fid = fopen(filename,"w");

fprintf(fid,"Grados \tC \t Acierto\n");
for i=1:length(grados)
  for j=1:length(C)
    args = cstrcat('-t 1 -d -c 100',num2str(grados(i)), ' -c ', num2str(C(j)));
    res = svmtrain(xltr,Xtr,args);
    test = svmpredict(xldv,Xdv,res);
    error = sum(test==xldv)/length(xldv) * 100;
    fprintf(fid,"%.1d \t%4.d \t%6.3f\n",grados(i),C(j),error);
    end
end


fclose(fid);