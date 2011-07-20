package br.poli.computacaonatural.pg.operadores
{
	
	import br.poli.computacaonatural.pg.AlgoritmoPG;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Fitness;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Individuo;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Operacao;

	public class Operadores
	{
		 
			public static function recombinacao (  individuo1:Individuo,  individuo2:Individuo ):Array
			{
				var novo1:Individuo = new Individuo();
				var novo2:Individuo = new Individuo();
				
				var tamanhoIndividuo1:int = individuo1.quantidadeOperacoes();
				var tamanhoIndividuo2:int = individuo2.quantidadeOperacoes();
				
				var tamanhoMenor:int = tamanhoIndividuo1 < tamanhoIndividuo2 ? tamanhoIndividuo1 : tamanhoIndividuo2;
				
				var indice:int = AlgoritmoPG.arredonda(Math.random() * (tamanhoMenor - 1));
				
				var i:int;
				for(i = 0 ; i < indice ; i++){
					novo1.adicionarOperacao(individuo1.getOperacao(i));
					novo2.adicionarOperacao(individuo2.getOperacao(i));
				}
				for(i = indice ; i < tamanhoIndividuo1 ; i++){
					novo2.adicionarOperacao(individuo1.getOperacao(i));
				}
				for(i = indice ; i < tamanhoIndividuo2 ; i++){
					novo1.adicionarOperacao(individuo2.getOperacao(i));
				}
				/*var arr:Array = new Array();
				arr.push( novo1 );
				arr.push( novo2 );*/
				return [novo1,novo2];/*arr;*/
			}
			
			public static  function mutacao (  individuo:Individuo ):Individuo
			{
				var individuoMutado:Individuo = individuo.clone();
				var indiceMaximo:int = individuoMutado.quantidadeOperacoes() - 1;
				
				var posicaoMutacao1:int = AlgoritmoPG.arredonda(Math.random() * indiceMaximo);
				var posicaoMutacao2:int = AlgoritmoPG.arredonda(Math.random() * indiceMaximo);
				
				var op1:Operacao = individuoMutado.getOperacao(posicaoMutacao1);
				var op2:Operacao = individuoMutado.getOperacao(posicaoMutacao2);
				
				var vertebraTemp:int = op1.getEixo();
				op1.setEixo(op2.getEixo());
				op2.setEixo(vertebraTemp);
				
				return individuoMutado;
			}
			
			public static function selecao(  populacao:Array,
				 							 populacaoIntermediaria:Array):Array {
					
					var todos:Array = new Array();//new Individuo[populacao.length + populacaoIntermediaria.length];
					var saida:Array = new Array();//new Individuo[AlgoritmoPG.TAMANHO_POPULACAO];
					
					var i:int = 0;
					var j:int = 0;
					
					for(j = 0 ; j < populacao.length ; i++, j++){
						todos[i] = populacao[j];
					}
					for(j = 0 ; j < populacaoIntermediaria.length ; i++, j++){
						todos[i] = populacaoIntermediaria[j];
					}
					
					todos = ordenaPeloFitness(todos);
					
					j = 0;
					i = 0;
					
					//Pega os melhores
					var finalMelhores:int = AlgoritmoPG.TAMANHO_POPULACAO;
					for(i = 0 ; i < finalMelhores ; i++, j++){
						saida[j] = todos[i];
					}
					 
					return saida;
				}
			public static function selecao2(  populacao:Array,
				 							 populacaoIntermediaria:Array):Array {
					
					var todos:Array = new Array();//new Individuo[populacao.length + populacaoIntermediaria.length];
					var saida:Array = new Array();//new Individuo[AlgoritmoPG.TAMANHO_POPULACAO];
					
					var i:int = 0;
					var j:int = 0;
					
					for(j = 0 ; j < populacao.length ; i++, j++){
						todos[i] = populacao[j];
					}
					for(j = 0 ; j < populacaoIntermediaria.length ; i++, j++){
						todos[i] = populacaoIntermediaria[j];
					}
					
					//todos = ordenaPeloFitness.apply(null,todos);
					todos = ordenaPeloFitness(todos);
					
					j = 0;
					i = 0;
					
					//Pega os 30% melhores
					//equevale a 60% dos invidiuos da população
					var finalMelhores:int = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.3 * 2);
					for(i = 0 ; i < finalMelhores ; i++, j++){
						saida[j] = todos[i];
					}
					
					//Pega os intermediários entre 40% e 55%
					//equevale a 30% dos invidiuos da população
					var inicioIntermediario:int = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.40 * 2);
					var finalIntermediario:int = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.55 * 2);
					for(i = inicioIntermediario ; i < finalIntermediario ; i++, j++){
						saida[j] = todos[i];
					}
					
					//Pega os piores entre 85% e 90%
					//equevale a 10% dos invidiuos da população
					var inicioPiores:int = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.85 * 2);
					var finalPiores:int = AlgoritmoPG.arredonda(AlgoritmoPG.TAMANHO_POPULACAO * 0.90 * 2);
					
					for(i = inicioPiores ; i < finalPiores ; i++, j++){
						saida[j] = todos[i];
					}
					
					if(j < AlgoritmoPG.TAMANHO_POPULACAO){
						saida[j] = todos[i];
					}
					
					if(saida.length != AlgoritmoPG.TAMANHO_POPULACAO){
						throw( new Error("saida < tamanho da populacao") );
					}
					return saida;
				}
			
			public static function ordenaPeloFitness( individuos:Array  ):Array {
				
				//Algoritmo Selection Sort
				var indiceMelhor:int;
				
				for(var i:int = 0 ; i < individuos.length ; i++){
					
					indiceMelhor = i;
					var melhorIndividuo:Individuo = Individuo(individuos[i]);
					
					for(var j:int = i + 1; j < individuos.length ; j++){
						
						var atual:Individuo = individuos[j];
						
						if(temFitnessMelhor(melhorIndividuo,atual)){
							indiceMelhor = j;
						}
						
					}
					
					if(indiceMelhor != i){
						var aux:Individuo = individuos[indiceMelhor];
						individuos[indiceMelhor] = individuos[i];
						individuos[i] = aux;
					}
				}
				
				return individuos;
			}
			
			public static function temFitnessMelhor(  melhorIndividuo:Individuo,   atual:Individuo ):Boolean {
				
				var fitnessMelhor:Fitness = melhorIndividuo.fitness;
				var fitnessAtual:Fitness = atual.fitness;
				
				var menorIgual:Boolean = false;
				var menor:Boolean = false;
				
				if(	((fitnessAtual.distanciaFinal < fitnessMelhor.distanciaFinal) ||
					(Math.abs(fitnessAtual.distanciaFinal - fitnessMelhor.distanciaFinal) <= AlgoritmoPG.PRECISAO_DISTANCIA)) &&
					(fitnessAtual.somaDistancias <= fitnessMelhor.somaDistancias))
				{
					menorIgual = true;
				}
				
				if(	(fitnessAtual.distanciaFinal < fitnessMelhor.distanciaFinal) ||
					(fitnessAtual.somaDistancias < fitnessMelhor.somaDistancias))
				{
					menor = true;
				}
				
				return (menorIgual && menor);
				
			}
			
		}
	} 