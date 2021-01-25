package proyecto;

import org.opt4j.core.problem.Creator;
import org.opt4j.core.genotype.IntegerGenotype;
import java.util.Random;

public class ProyectoCreator implements Creator<IntegerGenotype>
{
	public IntegerGenotype create()
	{
		IntegerGenotype genotipo = new IntegerGenotype(1, DatosVacunas.NUM_VACUNAS);
		
		genotipo.init(new Random(), DatosVacunas.NUM_GRUPOS);
		return genotipo;
	}
}
