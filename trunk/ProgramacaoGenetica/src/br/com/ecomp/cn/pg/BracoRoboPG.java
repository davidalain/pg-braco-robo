package br.com.ecomp.cn.pg;
import java.util.LinkedList;
import java.util.List;

import br.com.ecomp.cn.conexao.ClientSocket;
import br.com.ecomp.cn.pg.operadores.Operadores;
import br.com.ecomp.cn.pg.representacaoIndividuo.Fitness;
import br.com.ecomp.cn.pg.representacaoIndividuo.Individuo;
import br.com.ecomp.cn.pg.representacaoIndividuo.Operacao;


/**
 * @authors David Alain e Leandro Honorato 
 *
 */
public class BracoRoboPG {

	public static final int NUMERO_MAXIMO_OPERACOES = 10;
	public static final int TAMANHO_POPULACAO = 5;
	public static final int NUMERO_MAXIMO_GERACOES = 5;
	public static final int ANGULO_MAXIMO_INICIAL = 40;
	public static final int GRAUS_DE_LIBERDADE = 3;
	
	public static final double TAXA_RECOMBINACAO = 0.95;
	public static final double PRECISAO_DISTANCIA = 0.1;
	public static final double ERRO_ENTRE_DISTANCIAS = 0.1;
	
	public static final String IP_SERVIDOR = "192.168.0.129";
	public static final int PORTA_SERVIDOR = 6667;
	
	private Individuo[] populacao;
	private Individuo[] populacaoIntermediaria;
	private int geracaoAtual;
	
	private void inicializaPopulacao(){
		populacao = new Individuo[TAMANHO_POPULACAO];
		populacaoIntermediaria = new Individuo[TAMANHO_POPULACAO];
		
		for(int i = 0 ; i < TAMANHO_POPULACAO ; ++i){
			populacao[i] = gerarIndividuo();
		}
	}
	
//	private Individuo gerarIndividuo() {
//		
//		Individuo novo = new Individuo();
//		int quantidadeOperacoes = BracoRoboPG.arredonda(Math.random() * (NUMERO_MAXIMO_OPERACOES - 10)) + 6;
//		
//		for(int i = 0 ; i < quantidadeOperacoes ; ++i){
//			novo.adicionarOperacao(this.gerarOperacao());
//		}
//		
//		return novo;
//	}
	
	private Individuo gerarIndividuo() {
		
		Individuo[] novo = new Individuo[GRAUS_DE_LIBERDADE];
		int quantidadeOperacoes = BracoRoboPG.arredonda(Math.random() * (NUMERO_MAXIMO_OPERACOES - 10)) + 6;
		
		for(int i = 0 ; i < novo.length ; ++i){
			novo[i] = new Individuo();
		}
		
		double dist = Double.MAX_VALUE;
		for(int i = 0 ; (i < quantidadeOperacoes) && (dist > PRECISAO_DISTANCIA) ; ++i){
			
			for(int j = 0 ; j < novo.length ; ++j){
				
				novo[j].adicionarOperacao(this.gerarOperacao(j));
				novo = Operadores.ordenaPeloFitness(novo);
				
				dist = novo[0].avaliarIndividuo().distancia;
				
				for(int k = 1 ; k < novo.length ; ++k){
					novo[k] = novo[0];
				}
				
			}
		}
		
		return novo[0];
	}

	public Operacao gerarOperacao() {
		int vertebra =  BracoRoboPG.arredonda(Math.random() * (GRAUS_DE_LIBERDADE - 1));
		int angulo = BracoRoboPG.arredonda(Math.random() * (ANGULO_MAXIMO_INICIAL + ANGULO_MAXIMO_INICIAL)) - ANGULO_MAXIMO_INICIAL;
		return new Operacao(vertebra, angulo);
	}
	
	private Operacao gerarOperacao(int vertebra) {
		int angulo = BracoRoboPG.arredonda(Math.random() * (ANGULO_MAXIMO_INICIAL + ANGULO_MAXIMO_INICIAL)) - ANGULO_MAXIMO_INICIAL;
		return new Operacao(vertebra, angulo);
	}

	public Individuo buscarSolucao(){
		
		int indiceInter = 0;
		
		//Inicializa o Socket
		ClientSocket.getInstance();
		
		//inicializar População
		this.inicializaPopulacao();
		System.out.println("Inicializou a população");
		
		//calcular Fitness da População
		this.avaliaPopulacao();
		System.out.println("avaliou a população");
		
		while ( !this.atingiuCondicaoParada() ) // enquanto não atingir uma condição de parada
		{
			
			//seleciona dois indivíduos
			//decide se vai fazer mutação ou recombinação
			//executa a operação
			
			int indiceRamdom1 = BracoRoboPG.arredonda(Math.random() * (TAMANHO_POPULACAO - 1));
			int indiceRamdom2 = BracoRoboPG.arredonda(Math.random() * (TAMANHO_POPULACAO - 1));
			
			while ( indiceInter < TAMANHO_POPULACAO )
			{
				double condicaoMutacaoRecombinacao = Math.random();
				
				if((condicaoMutacaoRecombinacao >= TAXA_RECOMBINACAO) || (indiceInter == TAMANHO_POPULACAO - 1)){
				//Aplica mutação
					
					populacaoIntermediaria[indiceInter] = Operadores.mutacao(populacao[indiceRamdom1]);
					indiceInter++;
					
				}else{
				//Aplica recombinação
				
					Individuo[] novos = Operadores.recombinacao(populacao[indiceRamdom1], populacao[indiceRamdom2]);
					populacaoIntermediaria[indiceInter] = novos[0];
					populacaoIntermediaria[indiceInter + 1] = novos[1];
					indiceInter += 2;
					
				}
			}
			
			populacao = Operadores.selecao(populacao,populacaoIntermediaria);
			
			System.out.println("Geração atual: "+geracaoAtual);
			geracaoAtual++;
			
			Fitness fitness = populacao[0].avaliarIndividuo();
			System.out.println("Melhor: distancia = "+fitness.distancia+", operações = "+fitness.quantidadeOperacoes);
		}
		
		return this.posProcessamento(populacao[0]);
	}


	private Individuo posProcessamento(Individuo individuo) {
		
		Individuo saida = new Individuo();
		
		LinkedList<Operacao> listaOperacoes = new LinkedList<Operacao>();
		
		int tamanho = individuo.quantidadeOperacoes();
		for(int i = 0 ; i < tamanho ; ++i){
			listaOperacoes.add(individuo.getOperacao(i));
		}
		
		for(int i = 0 ; i + 1 < tamanho ; ++i){
			
			Operacao op1 = listaOperacoes.get(i);
			Operacao op2 = listaOperacoes.get(i + 1);
			
			if(op1.getEixo() == op2.getEixo()){
				
				listaOperacoes.remove(i);
				listaOperacoes.remove(i + 1);
				
				Operacao novo = new Operacao(op1.getEixo(), op1.getAngulo() + op2.getAngulo());
				listaOperacoes.add(i, novo);
				
				tamanho = listaOperacoes.size();
				--i;
			}
			
		}
		
		return saida;
	}

	private boolean atingiuCondicaoParada() {
		Fitness fitnessMelhor = populacao[0].avaliarIndividuo();
		return((fitnessMelhor.distancia <= 0.01) || (geracaoAtual >= NUMERO_MAXIMO_GERACOES));
	}

	private void avaliaPopulacao() {
		for(int i = 0 ; i < populacao.length ; ++i){
			populacao[i].avaliarIndividuo();
		}
	}
	
	public static int arredonda(double valor){
		return Math.round(new Float(valor).floatValue());
	}

	
}
