package br.com.ecomp.cn.pg.operadores;

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
		
		int tamanhoIndividuo1 = individuo1.getListaOperacoes().size();
		int tamanhoIndividuo2 = individuo2.getListaOperacoes().size();
		
		int indiceMedio = tamanhoIndividuo1 < tamanhoIndividuo2 ? tamanhoIndividuo1 : tamanhoIndividuo2;
		indiceMedio /= 2;
		
		int indice = (int) Math.random() * indiceMedio;
		
		for(int i = 0 ; i < tamanhoIndividuo1 ; ++i){
			if(i <= indice){
				novo1.getListaOperacoes().add(individuo1.getListaOperacoes().get(i));
			}else{
				novo2.getListaOperacoes().add(individuo1.getListaOperacoes().get(i));
			}
		}
		
		for(int i = 0 ; i < tamanhoIndividuo2 ; ++i){
			if(i <= indice){
				novo1.getListaOperacoes().add(individuo2.getListaOperacoes().get(i));
			}else{
				novo2.getListaOperacoes().add(individuo2.getListaOperacoes().get(i));
			}
		}
		
		return new Individuo[]{novo1,novo2};
	}
	
	public static Individuo mutacao ( Individuo individuo )
	{
		
		Individuo individuoMutado = individuo.clone();
		int indiceMaximo = individuoMutado.getListaOperacoes().size() - 1;
		
		int posicaoMutacao1 = Math.round( new Float( Math.random() * indiceMaximo ).floatValue());
		int posicaoMutacao2 = Math.round( new Float( Math.random() * indiceMaximo ).floatValue());
		
		Operacao op1 = individuoMutado.getListaOperacoes().get(posicaoMutacao1);
		Operacao op2 = individuoMutado.getListaOperacoes().get(posicaoMutacao2);
		
		int vertebraTemp = op1.getVertebra();
		op1.setVertebra(op2.getVertebra());
		op2.setVertebra(vertebraTemp);
		
		return null;
	}
	
}
