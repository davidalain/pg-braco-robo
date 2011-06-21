package br.com.ecomp.cn.pg;
import br.com.ecomp.cn.conexao.ClientSocket;
import br.com.ecomp.cn.pg.operadores.Operadores;
import br.com.ecomp.cn.pg.representacaoIndividuo.Individuo;
import br.com.ecomp.cn.pg.representacaoIndividuo.Operacao;


/**
 * @authors David Alain e Leandro Honorato 
 *
 */
public class BracoRoboPG {

	public static final int NUMERO_MAXIMO_OPERACOES = 400;
	public static final int TAMANHO_POPULACAO = 1000;
	public static final int NUMERO_MAXIMO_GERACOES = 20;
	public static final int ANGULO_MAXIMO = 20;
	public static final int GRAUS_DE_LIBERDADE = 3;
	
	public static final double TAXA_RECOMBINACAO = 0.80;
	public static final double TAXA_MUTACAO = 0.05;
	
	public static final String IP_SERVIDOR = "192.168.0.129";
	public static final int PORTA_SERVIDOR = 6667;
	
	private Individuo[] populacao;
	private int geracaoAtual;
	
	private void inicializaPopulacao(){
		populacao = new Individuo[TAMANHO_POPULACAO];
		
		for(int i = 0 ; i < TAMANHO_POPULACAO ; ++i){
			populacao[i] = gerarIndividuo();
		}
	}
	
	private Individuo gerarIndividuo() {
		
		Individuo novo = new Individuo();
		int quantidadeOperacoes = BracoRoboPG.arredonda(Math.random() * (NUMERO_MAXIMO_OPERACOES - 10)) + 6;
		
		for(int i = 0 ; i < quantidadeOperacoes ; ++i){
			novo.adicionarOperacao(this.gerarOperacao());
		}
		
		return novo;
	}
	
//	private Individuo gerarIndividuo() {
//		
//		Individuo[] novo = new Individuo[GRAUS_DE_LIBERDADE];
//		int quantidadeOperacoes = BracoRoboPG.arredonda(Math.random() * (NUMERO_MAXIMO_OPERACOES - 10)) + 6;
//		
//		for(int i = 0 ; i < novo.length ; ++i){
//			novo[i] = new Individuo();
//		}
//		
//		for(int i = 0 ; i < quantidadeOperacoes ; ++i){
//			
//			for(int j = 0 ; j < novo.length ; ++j){
//				
//				novo[j].adicionarOperacao(this.gerarOperacao(j));
//				novo = this.ordenaPeloFitness(novo);
//				
//				for(int k = 1 ; k < novo.length ; ++k){
//					novo[k] = novo[0];
//				}
//				
//			}
//		}
//		
//		return novo[0];
//	}

	private Operacao gerarOperacao() {
		int vertebra =  BracoRoboPG.arredonda(Math.random() * (GRAUS_DE_LIBERDADE - 1));
		int angulo = BracoRoboPG.arredonda(Math.random() * (ANGULO_MAXIMO + ANGULO_MAXIMO)) - ANGULO_MAXIMO;
		return new Operacao(vertebra, angulo);
	}
	
//	private Operacao gerarOperacao(int vertebra) {
//		int angulo = BracoRoboPG.arredonda(Math.random() * (ANGULO_MAXIMO + ANGULO_MAXIMO)) - ANGULO_MAXIMO;
//		return new Operacao(vertebra, angulo);
//	}

	public Individuo buscarSolucao(){
		
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
			
			int condicaoMutacaoRecombinacao = BracoRoboPG.arredonda(Math.random() * 100);
			
			if(condicaoMutacaoRecombinacao%2 == 0){
				
				int indiceMinMutacao = BracoRoboPG.arredonda(TAMANHO_POPULACAO - TAMANHO_POPULACAO*TAXA_MUTACAO);
				
				for(int i = TAMANHO_POPULACAO - 1 ; i > indiceMinMutacao ; --i){
					populacao[i] = Operadores.mutacao(populacao[i]);
				}
				
			}else{
				
				int indiceMaxRecombinacao = BracoRoboPG.arredonda(TAXA_RECOMBINACAO*TAMANHO_POPULACAO);
				
				for(int i = 0 ; i + 1 < indiceMaxRecombinacao ; ++i){
					Individuo[] novos = Operadores.recombinacao(populacao[i], populacao[i + 1]);
					populacao[i] = novos[0];
					populacao[i + 1] = novos[1];
				}
			}
			
			System.out.println("Geração atual: "+geracaoAtual);
			geracaoAtual++;
			
			this.avaliaPopulacao();
			System.out.println("Avaliou a população");
			double[] fitness = populacao[0].avaliarIndividuo();
			System.out.println("Melhor: fitness = "+fitness[0]+", operações = "+fitness[1]);
		}
		
		return populacao[0];
	}

	private Individuo[] ordenaPeloFitness(Individuo... individuos) {
		
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

	private boolean temFitnessMelhor( Individuo melhorIndividuo, Individuo atual ) {
		
		double[] fitnessMelhor = melhorIndividuo.avaliarIndividuo();
		double[] fitnessAtual = atual.avaliarIndividuo();
		
		boolean menorIgual = true;
		boolean menor = false;
		
		for(int i = 0 ; i < fitnessMelhor.length ; ++i){
			if(fitnessMelhor[i] < fitnessAtual[i]){
				menorIgual = false;
			}
			if(fitnessMelhor[i] > fitnessAtual[i] ){
				menor = true;
			}
		}
		
		return (menorIgual && menor);
		
	}

	private boolean atingiuCondicaoParada() {
		return((populacao[0].avaliarIndividuo()[0] <= 0.01) && (geracaoAtual >= NUMERO_MAXIMO_GERACOES));
	}

	private void avaliaPopulacao() {

		populacao = this.ordenaPeloFitness(populacao);
		
	}
	
	public static int arredonda(double valor){
		return Math.round(new Float(valor).floatValue());
	}

	
}
