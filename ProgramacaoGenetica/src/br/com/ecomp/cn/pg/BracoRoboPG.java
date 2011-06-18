package br.com.ecomp.cn.pg;
import java.util.LinkedList;
import java.util.List;

import br.com.ecomp.cn.conexao.ClientSocket;
import br.com.ecomp.cn.pg.operadores.Operadores;
import br.com.ecomp.cn.pg.representacaoIndividuo.Individuo;



/**
 * 
 */

/**
 * @author Leandro Honorato
 *
 */
public class BracoRoboPG {

	public static final int NUMERO_MAXIMO_OPERACOES = 0;
	private List<Individuo> populacao;
	private Individuo melhorIndividuo;
	private double melhorFitness;
	
	private void inicializaPopulacao(){
		this.melhorIndividuo = null;
		this.melhorFitness = Double.MAX_VALUE;
		this.populacao = new LinkedList<Individuo>();
	}
	
	public void iniciarAlgoritmo(){
		
		ClientSocket.iniciarSocket();
		
		//inicializar População
		this.inicializaPopulacao();
		
		//calcular Fitness da População
		this.avaliarPopulacao();
		
		while ( !this.atingiuCondicaoParada() ) // enquanto não atingir uma condição de parada
		{
			
			//seleciona dois indivíduos
			//decide se vai fazer mutação ou recombinação
			//executa a operação
			
			int indice1 = (int) (Math.random() * (populacao.size() - 1));
			int indice2 = (int) (Math.random() * (populacao.size() - 1));
			Individuo individuo1 = populacao.get(indice1);
			Individuo individuo2 = populacao.get(indice2);
			
			int condicaoMutacaoRecombinacao = (int) (Math.random() * 1000);
			
			Individuo[] novos = new Individuo[2];
			if(condicaoMutacaoRecombinacao%2 == 0){
				novos[0] = Operadores.mutacao(individuo1);
				novos[1] = Operadores.mutacao(individuo2);
			}else{
				novos = Operadores.recombinacao(individuo1, individuo2);
			}
			
			
			double fitnessNovo0 = novos[0].avaliarIndividuo();
			double fitnessNovo1 = novos[1].avaliarIndividuo();
			if(fitnessNovo0 < ){
				
			}
			
		}
	}

	private boolean atingiuCondicaoParada() {
		return (melhorFitness == 0.0);
	}

	private void avaliarPopulacao() {
		
		for(Individuo individuo : populacao){
			double fitness = individuo.avaliarIndividuo(); 
			if(fitness < melhorFitness){
				melhorFitness = fitness;
				melhorIndividuo = individuo;
			}
		}
		
	}
	
}
