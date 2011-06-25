package br.com.ecomp.cn.pg.operadores;

import br.com.ecomp.cn.pg.AlgoritmoPG;
import br.com.ecomp.cn.pg.representacaoIndividuo.Fitness;
import br.com.ecomp.cn.pg.representacaoIndividuo.Individuo;
import br.com.ecomp.cn.pg.representacaoIndividuo.Operacao;
/**
 * @authors David Alain e Leandro Honorato 
 *
 */
public class Operadores {

	public static Individuo[] recombinacao ( Individuo individuo1, Individuo individuo2 )
	{
		Individuo novo1 = new Individuo();
		Individuo novo2 = new Individuo();
		
		int tamanhoIndividuo1 = individuo1.quantidadeOperacoes();
		int tamanhoIndividuo2 = individuo2.quantidadeOperacoes();
		
		int menorIndice = tamanhoIndividuo1 < tamanhoIndividuo2 ? tamanhoIndividuo1 : tamanhoIndividuo2;
		
		int indice = AlgoritmoPG.arredonda(Math.random() * (menorIndice - 1)) + 1;
		
		for(int i = 0 ; i < indice ; ++i){
			novo1.adicionarOperacao(individuo1.getOperacao(i));
			novo2.adicionarOperacao(individuo2.getOperacao(i));
		}
		for(int i = indice ; i < tamanhoIndividuo1 ; ++i){
			novo2.adicionarOperacao(individuo1.getOperacao(i));
		}
		for(int i = indice ; i < tamanhoIndividuo2 ; ++i){
			novo1.adicionarOperacao(individuo2.getOperacao(i));
		}
		
		return new Individuo[]{novo1,novo2};
	}
	
	public static Individuo mutacao ( Individuo individuoMutado )
	{
//		Individuo individuoMutado = individuo.clone();
		int indiceMaximo = individuoMutado.quantidadeOperacoes() - 1;
		
		int posicaoMutacao1 = AlgoritmoPG.arredonda(Math.random() * indiceMaximo);
		int posicaoMutacao2 = AlgoritmoPG.arredonda(Math.random() * indiceMaximo);
		
		Operacao op1 = individuoMutado.getOperacao(posicaoMutacao1);
		Operacao op2 = individuoMutado.getOperacao(posicaoMutacao2);
		
		int vertebraTemp = op1.getEixo();
		op1.setEixo(op2.getEixo());
		op2.setEixo(vertebraTemp);
		
		return individuoMutado;
	}

	public static Individuo[] selecao(Individuo[] populacao,
			Individuo[] populacaoIntermediaria) {
		
		Individuo[] todos = new Individuo[populacao.length + populacaoIntermediaria.length];
		Individuo[] saida = new Individuo[AlgoritmoPG.TAMANHO_POPULACAO];
		
		int i = 0, j = 0;
		
		for(j = 0 ; j < populacao.length ; ++i, ++j){
			todos[i] = populacao[j];
		}
		for(j = 0 ; j < populacaoIntermediaria.length ; ++i, ++j){
			todos[i] = populacaoIntermediaria[j];
		}
		
		todos = ordenaPeloFitness(todos);
		
		j = 0;
		i = 0;
		
		//Pega os 30% melhores
		//equevale a 60% dos invidiuos da população
		int finalMelhores = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.3 * 2);
		for(i = 0 ; i < finalMelhores ; ++i, ++j){
			saida[j] = todos[i];
		}
		
		//Pega os intermediários entre 40% e 55%
		//equevale a 30% dos invidiuos da população
		int inicioIntermediario = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.40 * 2);
		int finalIntermediario = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.55 * 2);
		for(i = inicioIntermediario ; i < finalIntermediario ; ++i, ++j){
			saida[j] = todos[i];
		}
		
		//Pega os piores entre 85% e 90%
		//equevale a 10% dos invidiuos da população
		int inicioPiores = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.85 * 2);
		int finalPiores = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.90 * 2);
		for(i = inicioPiores ; i < finalPiores ; ++i, ++j){
			saida[j] = todos[i];
		}
		
		return saida;
	}
	
	public static Individuo[] ordenaPeloFitness(Individuo... individuos) {
		
		//Algoritmo Selection Sort
		int indiceMelhor;
		
		for(int i = 0 ; i < individuos.length ; ++i){
			
			indiceMelhor = i;
			Individuo melhorIndividuo = individuos[i];
			
			for(int j = i + 1; j < individuos.length ; ++j){
				
				Individuo atual = individuos[j];
				
				if(temFitnessMelhor(melhorIndividuo,atual)){
					indiceMelhor = j;
				}
				
			}
			
			if(indiceMelhor != i){
				Individuo aux = individuos[indiceMelhor];
				individuos[indiceMelhor] = individuos[i];
				individuos[i] = aux;
			}
		}
		
		return individuos;
	}
	
	public static boolean temFitnessMelhor( Individuo melhorIndividuo, Individuo atual ) {
		
		Fitness fitnessMelhor = melhorIndividuo.fitness();
		Fitness fitnessAtual = atual.fitness();
		
		boolean menorIgual = false;
		boolean menor = false;
		
		if(	((fitnessAtual.distanciaFinal < fitnessMelhor.distanciaFinal) ||
			(Math.abs(fitnessAtual.distanciaFinal - fitnessMelhor.distanciaFinal) <= AlgoritmoPG.PRECISAO_DISTANCIA)) &&
			(fitnessAtual.somaDistancias <= fitnessMelhor.somaDistancias))
		{
			menorIgual = true;
		}
		
		if(	(fitnessAtual.distanciaFinal < fitnessMelhor.distanciaFinal) ||
			(fitnessAtual.somaDistancias < fitnessMelhor.somaDistancias))
		{
			menor = true;
		}
		
		return (menorIgual && menor);
		
	}
	
}
