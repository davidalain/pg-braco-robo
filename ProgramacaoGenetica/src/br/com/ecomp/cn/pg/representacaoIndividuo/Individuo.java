package br.com.ecomp.cn.pg.representacaoIndividuo;

import java.util.LinkedList;

import br.com.ecomp.cn.conexao.ClientSocket;
import br.com.ecomp.cn.pg.BracoRoboPG;

/**
 * @authors David Alain e Leandro Honorato 
 *
 */
public class Individuo {
	
	private LinkedList<Operacao> listaOperacoes;
	
	private boolean avaliado;
	private double[] fitness;
	
	private boolean possuiOperacaoInvalida;

	public Individuo() {
		avaliado = false;
		possuiOperacaoInvalida = false;
		listaOperacoes = new LinkedList<Operacao>();
		fitness = new double[2];
	}

	public double[] avaliarIndividuo () //É o fitness
	{
		
		if(!avaliado){
			
			avaliado = true;
//			for(Operacao op : listaOperacoes){
//				int sucesso = ClientSocket.getInstance().executarOperacao(op);
//				if(sucesso == 0){
//					possuiOperacaoInvalida = true;
//					//fitness[0] = Double.MAX_VALUE;
//					System.out.println("Houve Operação Inválida");
//				}
//			}
			
			int erro = ClientSocket.getInstance().executarOperacoes(listaOperacoes);
			if(erro != -1){
				possuiOperacaoInvalida = true;
			}
			
			if(!possuiOperacaoInvalida){
				fitness[0] = ClientSocket.getInstance().calcularDistancia();
			}
			
			fitness[1] = new Double(listaOperacoes.size());
		}
		
		//System.out.println("fitness: dist = " + fitness[0]+", operacoes = "+fitness[1]);
		
		return fitness;
	}
	
	public boolean isIndividuoValido () //Para depois tratar restrições
	{
		return ((!possuiOperacaoInvalida) && (listaOperacoes.size() <= BracoRoboPG.NUMERO_MAXIMO_OPERACOES));
	}
	
//	public LinkedList<Operacao> getListaOperacoes() {
//		return listaOperacoes;
//	}
	
	public void adicionarOperacao(Operacao op){
		listaOperacoes.add(op);
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
	
	public Individuo clone(){
		
		Individuo individuoClone = new Individuo();
		for(Operacao op : this.listaOperacoes){
			individuoClone.listaOperacoes.add(op);
		}
		
		return individuoClone;
	}
	
}
