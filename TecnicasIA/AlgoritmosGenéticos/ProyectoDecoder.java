package proyecto;

import java.util.ArrayList;

import org.opt4j.core.genotype.IntegerGenotype;
import org.opt4j.core.problem.Decoder;

public class ProyectoDecoder implements Decoder<IntegerGenotype,ArrayList<Integer>>{
	@Override
	public ArrayList<Integer> decode(IntegerGenotype genotipo){
		ArrayList<Integer> fenotipo = new ArrayList<Integer>();
		
		for (int i = 0; i < genotipo.size(); i++) {
			fenotipo.add(genotipo.get(i));
		}
		return fenotipo;
	}
}
