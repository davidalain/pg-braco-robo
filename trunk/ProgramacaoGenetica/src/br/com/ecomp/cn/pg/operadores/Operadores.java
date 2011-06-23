package br.com.ecomp.cn.pg.operadores;

import br.com.ecomp.cn.pg.BracoRoboPG;
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
		
		int indice = BracoRoboPG.arredonda(Math.random() * (menorIndice - 1)) + 1;
		
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
		
		int posicaoMutacao1 = BracoRoboPG.arredonda(Math.random() * indiceMaximo);
		int posicaoMutacao2 = BracoRoboPG.arredonda(Math.random() * indiceMaximo);
		
		Operacao op1 = individuoMutado.getOperacao(posicaoMutacao1);
		Operacao op2 = individuoMutado.getOperacao(posicaoMutacao2);
		
		int vertebraTemp = op1.getEixo();
		op1.setEixo(op2.getEixo());
		op2.setEixo(vertebraTemp);
		
		return individuoMutado;
	}
	
}
