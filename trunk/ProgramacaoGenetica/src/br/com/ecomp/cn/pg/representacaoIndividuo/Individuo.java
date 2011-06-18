package br.com.ecomp.cn.pg.representacaoIndividuo;

import java.util.LinkedList;

import br.com.ecomp.cn.conexao.ClientSocket;
import br.com.ecomp.cn.pg.BracoRoboPG;

public class Individuo {
	
	private LinkedList<Operacao> listaOperacoes;
	
	private boolean avaliado;
	private double fitness;
	
	private boolean possuiOperacaoInvalida;

	public Individuo() {
		avaliado = false;
		possuiOperacaoInvalida = false;
		listaOperacoes = new LinkedList<Operacao>();
	}

	public double avaliarIndividuo () //É o fitness
	{
		for(Operacao op : listaOperacoes){
			int sucesso = ClientSocket.getInstance().executarOperacao(op);
			if(sucesso == 0){
				possuiOperacaoInvalida = true;
				return Double.MAX_VALUE;
			}
		}
		
		if(!avaliado){
			fitness = ClientSocket.getInstance().calcularDistancia();
			avaliado = true;
		}
		
		return fitness;
	}
	
	public boolean isIndividuoValido () //Para depois tratar restrições
	{
		return ((!possuiOperacaoInvalida) && (listaOperacoes.size() <= BracoRoboPG.NUMERO_MAXIMO_OPERACOES));
	}
	
	public LinkedList<Operacao> getListaOperacoes() {
		return listaOperacoes;
	}

	public void setListaOperacoes(LinkedList<Operacao> listaOperacoes) {
		this.listaOperacoes = listaOperacoes;
	}
	
	public Individuo clone(){
		
		Individuo individuoClone = new Individuo();
		for(Operacao op : this.listaOperacoes){
			individuoClone.listaOperacoes.add(op);
		}
		
		return individuoClone;
	}
	
}
