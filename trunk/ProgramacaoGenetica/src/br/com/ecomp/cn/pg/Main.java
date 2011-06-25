package br.com.ecomp.cn.pg;

import br.com.ecomp.cn.pg.representacaoIndividuo.Individuo;
import br.com.ecomp.cn.pg.representacaoIndividuo.Operacao;


public class Main {

	public static void main(String[] args) {
		
		AlgoritmoPG br = new AlgoritmoPG();
		Individuo solucao = br.buscarSolucao();

		System.out.println("\nA melhor solução encontrada foi:\n\n");
		System.out.println("LinkedList<Operacao> operacoes = new LinkedList<Operacao>();");
		for(int i = 0 ; i < solucao.quantidadeOperacoes() ; ++i){
			Operacao op = solucao.getOperacao(i);
			System.out.println("operacoes.add(new Operacao("+op.getEixo()+", "+op.getAngulo()+"));");
		}
		System.out.println("ClientSocket.getInstance().executarOperacoes(operacoes);");
		
	}
	
}
