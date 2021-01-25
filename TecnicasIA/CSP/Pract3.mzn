% Use this editor as a MiniZinc scratch book
int: desplazamiento = 1;
int: vuelo = 20;
var 0..36: M;
var 0..36: salidaAdan; 
var 0..36: salidaEva;
var 0..36: llegadaAdan; 
var 0..36: llegadaEva;
var 0..36: holgura;
var 0..36: llegaAeropuerto;
array [1..4] of var int: duracionA;
duracionA = [1, 2, 1, 4];
array [1..3] of var int: duracionE;
duracionE = [M, 2, 4];
array [1..4] of var int: Iadan;
array [1..4] of var int: Fadan;
array [1..3] of var int: Ieva;
array [1..3] of var int: Feva;


constraint forall (i in 1..4) ((Fadan[i] - Iadan[i]) == duracionA[i]);

constraint forall (i in 1..3) ((Feva[i] - Ieva[i]) == duracionE[i]);

%No solapamiento
constraint forall (i,j in 1..4 where i !=j)
          ((Iadan[i] >= (Fadan[j] + desplazamiento)) \/ (Fadan[i] <= (Iadan[j] - desplazamiento)));
            
%No solapamineto            
constraint forall (i,j in 1..3 where i !=j)
           ((Ieva[i] >= (Feva[j] + desplazamiento)) \/ (Feva[i] <= (Ieva[j] - desplazamiento)));




%Vemos cual es la tarea final y le sumamos 30 para ver la llegada
constraint if forall (j in 1..4) 
                      (Fadan[1]>= Fadan[j])
                      then (llegaAeropuerto == Fadan[1] + desplazamiento) endif;
                      
constraint if forall (j in 1..4) 
                      (Fadan[2]>= Fadan[j])
                      then (llegaAeropuerto == Fadan[2] + desplazamiento) endif;                      
                      
constraint if forall (j in 1..4) 
                      (Fadan[3]>= Fadan[j])
                      then (llegaAeropuerto == Fadan[3] + desplazamiento) endif;                      
                      
constraint if forall (j in 1..4) 
                      (Fadan[4]>= Fadan[j])
                      then (llegaAeropuerto == Fadan[4] + desplazamiento) endif;                                            


constraint holgura >= 1;
constraint holgura == vuelo - llegaAeropuerto; 

%Eva sale a las 12:00                        
constraint salidaEva >= 4;
constraint llegadaEva > 4;


%cada tarea no empieza antes de que salga de casa Adan
constraint forall(i in 1..4) (Iadan[i]>= salidaAdan + desplazamiento);
%cada tarea no empieza antes de que salga de casa Eva
constraint forall(i in 1..3) (Ieva[i]>= salidaEva + desplazamiento);

%cada tarea no acaba despues de que salga de casa Adan
constraint forall(i in 1..4) (Fadan[i]<= llegaAeropuerto - desplazamiento);
%cada tarea no acaba despues de que salga de casa Eva
constraint forall(i in 1..3) (Feva[i]<= llegadaEva - desplazamiento);

%Restricciones del enunciado
constraint Iadan[1] >= -2 \/ Iadan[1] >= 14;
constraint Fadan[1] <= 7 \/ Fadan[1] <= 21;
constraint Iadan[2] >= 4 \/ Iadan[2] >= 13;
%constraint Fadan[2] <= 9 \/ Fadan[2] <= 17;
constraint Iadan[3] >= 8 \/ Iadan[3] >= 16;
%constraint Fadan[3] <= 14 \/ Fadan[3] <= 23;
constraint Iadan[4] >= -2;
%constraint Fadan[4] <= 22; 

constraint if Ieva[1] <= 14 then M >= 5
                            else M == 4 endif;                                            
constraint Ieva[2] <= 4 \/ Ieva[2] <= 15;
constraint Feva[2] <= 9 \/ Feva[2] <= 19;
constraint Iadan[4] == Ieva[3];
constraint Fadan[4] == Feva[3];
                        
%constraint Feva[2] <= Iadan[2] - 8;                          
%constraint Feva[2] <= Iadan[2] - 10;                         
                            
                            
solve satisfy;
%solve maximize holgura;
%solve minimize llegadaEva;
%solve maximize salidaAdan;

output["SOLUCIONES. Desde las 10, unidades de 30 minutos", "\n", "ADAN",show(Iadan),show(Fadan),"\n", "EVA",show(Ieva),show(Feva), "\n", 
"Adan sale de casa a las ", show(salidaAdan), " llega al aeropuerto a las ", show(llegaAeropuerto),
" con holgura ", show(holgura), "\n",
"Eva sale de casa a las ", show(salidaEva), " y vuelve a casa a las ", show(llegadaEva)];                            