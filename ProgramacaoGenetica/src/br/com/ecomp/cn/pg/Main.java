package br.com.ecomp.cn.pg;

import br.com.ecomp.cn.pg.representacaoIndividuo.Individuo;


public class Main {

	public static void main(String[] args) {
		
		BracoRoboPG br = new BracoRoboPG();
		Individuo solucao = br.buscarSolucao();
		
		System.out.println("\nA melhor solu��o encontrada foi:");
		for(int i = 0 ; i < solucao.quantidadeOperacoes() ; ++i){
			System.out.println(solucao.getOperacao(i).getEixo());
		}
		
	}
	
}
