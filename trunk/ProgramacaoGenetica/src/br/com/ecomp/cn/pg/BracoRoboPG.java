package br.com.ecomp.cn.pg;
import br.com.ecomp.cn.pg.operadores.Operadores;
import br.com.ecomp.cn.pg.representacaoIndividuo.Individuo;
import br.com.ecomp.cn.pg.representacaoIndividuo.Operacao;


/**
 * @authors David Alain e Leandro Honorato 
 *
 */
public class BracoRoboPG {

	public static final int NUMERO_MAXIMO_OPERACOES = 400;
	public static final int TAMANHO_POPULACAO = 30;
	public static final int NUMERO_MAXIMO_GERACOES = 4000;
	public static final int ANGULO_MAXIMO = 20;
	
	public static final String IP_SERVIDOR = "192.168.0.103";
	public static final int PORTA_SERVIDOR = 6667;
	
	private Individuo[] populacao;
	private Individuo melhor;
	private int numeroGeracoes;
	
	private void inicializaPopulacao(){
		populacao = new Individuo[TAMANHO_POPULACAO];
		
		for(int i = 0 ; i < TAMANHO_POPULACAO ; ++i){
			populacao[i] = gerarIndividuo();
		}
		
		melhor = populacao[0];
	}
	
	private Individuo gerarIndividuo() {
		
		Individuo novo = new Individuo();
		int quantidadeOperacoes = Math.round(new Float(Math.random() * (NUMERO_MAXIMO_OPERACOES - 1)).floatValue());
		
		for(int i = 0 ; i < quantidadeOperacoes ; ++i){
			novo.getListaOperacoes().add(this.gerarOperacao());
		}
		
		return novo;
	}

	private Operacao gerarOperacao() {
		int vertebra =  Math.round(new Float(Math.random() * 2).floatValue());
		int angulo = Math.round(new Float(Math.random() * (ANGULO_MAXIMO + ANGULO_MAXIMO)).floatValue()) - ANGULO_MAXIMO;
		return new Operacao(vertebra, angulo);
	}

	public Individuo buscarSolucao(){
		
		//inicializar População
		this.inicializaPopulacao();
		System.out.println("Inicializou a população");
		
		//calcular Fitness da População
		this.avaliarPopulacao();
		System.out.println("avaliou a população");
		
		while ( !this.atingiuCondicaoParada() ) // enquanto não atingir uma condição de parada
		{
			
			//seleciona dois indivíduos
			//decide se vai fazer mutação ou recombinação
			//executa a operação
			
			int indice1 = (int) (Math.random() * (populacao.length - 1));
			int indice2 = (int) (Math.random() * (populacao.length - 1));
			Individuo individuo1 = populacao[indice1];
			Individuo individuo2 = populacao[indice2];
			System.out.println("Escolheu os individuos "+indice1+" e "+indice2);
			
			Individuo[] novos = new Individuo[2];
			int condicaoMutacaoRecombinacao = (int) (Math.random() * 1000);
			
			if(condicaoMutacaoRecombinacao%2 == 0){
				System.out.println("Aplicou mutação");
				novos[0] = Operadores.mutacao(individuo1);
				novos[1] = Operadores.mutacao(individuo2);
			}else{
				System.out.println("Aplicou recombinação");
				novos = Operadores.recombinacao(individuo1, individuo2);
			}
			numeroGeracoes++;
			
			Individuo[] ordenados = this.ordenaPeloFitness(individuo1,individuo2,novos[0],novos[1]);
			
			populacao[indice1] = ordenados[0];
			populacao[indice2] = ordenados[1];
			System.out.println("Fez a seleção");
			
			this.avaliarPopulacao();
			System.out.println("Avaliou a população");
		}
		
		return melhor;
	}

	private Individuo[] ordenaPeloFitness(Individuo... individuos) {
		
		//Algoritmo Selection Sort
		int indiceMelhor;
		
		for(int i = 0 ; i < individuos.length ; ++i){
			
			indiceMelhor = i;
			Individuo melhorIndividuo = individuos[i];
			System.out.println("i = "+i);
			
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
		return((melhor.avaliarIndividuo()[0] <= 0.01) && (numeroGeracoes == NUMERO_MAXIMO_GERACOES));
	}

	private void avaliarPopulacao() {

		for(int i = 0 ; i < TAMANHO_POPULACAO ; ++i){
			Individuo atual = populacao[i];
			if(temFitnessMelhor(melhor, atual)){
				melhor = atual;
			}
		}
		
	}

	
}
