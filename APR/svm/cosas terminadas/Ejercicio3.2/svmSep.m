#! /snap/bin/octave -qf
addpath('libreria');
%carga de datos
load ../datos/mini/trSep.dat;
load ../datos/mini/trSeplabels.dat;
%Entrenamiento modelo
res = svmtrain(xl,X,'-t 0 -c 1000');

%vector de peso
theta = res.sv_coef' * res.SVs;
%peso umbral
theta0= sign(res.sv_coef(1)) - theta * res.SVs(1,:)';

margen = 2 / norm(theta);

%Frontera separación
x1 = [0:7];
x2 = -theta(1)/theta(2)*x1 - theta0/theta(2);
x3 = -theta(1)/theta(2)*x1 - (theta0-1)/theta(2);
x4 = -theta(1)/theta(2)*x1 - (theta0+1)/theta(2);

plot(X(xl==1,1),X(xl==1,2),"sr",X(xl==2,1),X(xl==2,2),"ob",x1,x2,"-k",x1,x3,"-r",x1,x4,"-g",
    res.SVs(:,1),res.SVs(:,2),"xk","markersize",20);
axis([0 7 0 7]);

%Muestra coeficientes arriba
text(res.SVs(:,1), res.SVs(:,2) + 0.2,num2str(abs(res.sv_coef())));
text(0.1,6.5,cstrcat('Margen: ',num2str(margen)));
X(res.sv_indices,:)= [];
text(X(:,1), X(:,2)+0.2,num2str(0.0));

%
print -color -depsc datosSeparables.eps;
