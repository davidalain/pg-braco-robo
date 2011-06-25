package br.com.ecomp.cn.pg.representacaoIndividuo;

import java.util.LinkedList;

import br.com.ecomp.cn.pg.AlgoritmoPG;
import br.com.ecomp.cn.simulador.Modelo3D;

/**
 * @authors David Alain e Leandro Honorato 
 *
 */
public class Individuo {
	
	private LinkedList<Operacao> listaOperacoes;
	
	private boolean avaliado;
	private Fitness fitness;
	
	private boolean possuiOperacaoInvalida;

	public Individuo() {
		avaliado = false;
		possuiOperacaoInvalida = false;
		listaOperacoes = new LinkedList<Operacao>();
		fitness = new Fitness();
	}
	
	public Individuo(LinkedList<Operacao> operacoes) {
		avaliado = false;
		possuiOperacaoInvalida = false;
		listaOperacoes = operacoes;
		fitness = new Fitness();
	}

	public Fitness fitness (){
		
		if(!avaliado){
			
			avaliado = true;
			fitness.distanciaFinal = 0.0d;
			fitness.somaDistancias = 0.0d;
			
			Modelo3D.reset();
			
			for(Operacao op : listaOperacoes){
				
				int sucesso = Modelo3D.executarOperacao(op);
				if(sucesso == 0){
					possuiOperacaoInvalida = true;
				}
				
				fitness.somaDistancias += Modelo3D.calculaDistancia();
			}
			
			fitness.distanciaFinal = Modelo3D.calculaDistancia();
		}
		
		return fitness;
	}
	
	public boolean isIndividuoValido () //Para depois tratar restrições
	{
		return ((!possuiOperacaoInvalida) && (listaOperacoes.size() <= AlgoritmoPG.NUMERO_MAXIMO_OPERACOES));
	}
	
//	public LinkedList<Operacao> getListaOperacoes() {
//		return listaOperacoes;
//	}
	
	public void adicionarOperacao(Operacao op){
		listaOperacoes.add(op);
		avaliado = false;
	}
	
	public Operacao getOperacao(int indice){
		return listaOperacoes.get(indice);
	}
	
	public int quantidadeOperacoes(){
		return listaOperacoes.size();
	}

//	public void setListaOperacoes(LinkedList<Operacao> listaOperacoes) {
//		this.listaOperacoes = listaOperacoes;
//		avaliado = false;
//	}
	
//	public Individuo clone(){
//		
//		Individuo individuoClone = new Individuo();
//		for(Operacao op : this.listaOperacoes){
//			individuoClone.listaOperacoes.add(op);
//		}
//		
//		return individuoClone;
//	}
	
}
