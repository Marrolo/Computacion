package proyecto;

import java.util.ArrayList;
import java.util.stream.IntStream;

import org.opt4j.core.Objective.Sign;
import org.opt4j.core.Objectives;
import org.opt4j.core.problem.Evaluator;

public class ProyectoEvaluator implements Evaluator<ArrayList<Integer>>
{
	@Override
	public Objectives evaluate(ArrayList<Integer> fenotipo) {
		int coste = 0;
		int joven[] = new int[4];
		int adultos[] = new int[4];
		int mayores[] = new int[5];
		int numVac;
		int numVol = 0;
		boolean todasVac = true;
        int[] todasVacunas = new int[DatosVacunas.NUM_GRUPOS];
		
		for(int i = 0; i < fenotipo.size(); ++i) {
			
			    numVac = fenotipo.get(i);
			    todasVacunas[i] = numVac;
				switch (numVac) {
				case 1:
					coste+= DatosVacunas.matrizCostes[0][i];
					numVol+= DatosVacunas.numeroVoluntarios[i];
					break;
				case 2:
					coste+= DatosVacunas.matrizCostes[1][i];
					numVol+= DatosVacunas.numeroVoluntarios[i];
					break;
				case 3:
					coste+= DatosVacunas.matrizCostes[2][i];
					break;
				}
		}
		
		System.arraycopy(todasVacunas, 0, joven, 0, 4);
		System.arraycopy(todasVacunas, 4, adultos, 0, 4);
		System.arraycopy(todasVacunas, 8, mayores, 0, 5);
		
		todasVac = IntStream.of(joven).anyMatch(x -> x == 1);
		todasVac = todasVac && IntStream.of(joven).anyMatch(x -> x == 2);
		todasVac = todasVac && IntStream.of(joven).anyMatch(x -> x == 3);
		todasVac = todasVac && IntStream.of(adultos).anyMatch(x -> x == 1);
		todasVac = todasVac && IntStream.of(adultos).anyMatch(x -> x == 2);
		todasVac = todasVac && IntStream.of(adultos).anyMatch(x -> x == 3);
		todasVac = todasVac && IntStream.of(mayores).anyMatch(x -> x == 1);
		todasVac = todasVac && IntStream.of(mayores).anyMatch(x -> x == 2);
		todasVac = todasVac && IntStream.of(mayores).anyMatch(x -> x == 3);
		

		if(!todasVac) {
			coste = Integer.MAX_VALUE;
			numVol = Integer.MIN_VALUE;
		}
		
		
		Objectives objectives = new Objectives();
		objectives.add("Valore objetivo-MIN", Sign.MIN, coste);
		objectives.add("Valore objetivo-MAX", Sign.MAX, numVol);
		
		return objectives;
	}
}
