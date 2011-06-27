package br.poli.computacaonatural.pg
{
	import br.poli.computacaonatural.pg.AlgoritmoPG;
	import br.poli.computacaonatural.pg.operadores.Operadores;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Fitness;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Individuo;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Operacao;
	
	import com.demonsters.debugger.MonsterDebugger;
	

	public class AlgoritmoPG
	{
		public static const  OPERACOES_MAX:int = 10;
		
		public static const  OPERACOES_MIN:int = 10;
		
		public static const  TAMANHO_POPULACAO:int = 40;
		
		public static const  GERACOES_MAX:int = 30;
		
		//public static const  ANGULO_MAXIMO_INICIAL:int = 60;KD?
		public static const  ANGULO_MAXIMO_INICIAL:Array = [0,0,0];
		public static const  ANGULO_MAXIMO_FINAL:Array = [-190,90,120];
		
		public static const  GRAUS_DE_LIBERDADE:int = ANGULO_MAXIMO_INICIAL.length;
		
		public static const  TAXA_RECOMBINACAO:Number = 0.95;
		
		public static const  PRECISAO_DISTANCIA:Number = 50;
		
		public static const  ERRO_ENTRE_DISTANCIAS:Number = 0.1;
		
		//public static const  IP_SERVIDOR:String = "192.168.0.129";
		//public static const  PORTA_SERVIDOR:int = 6667;
		
		private var populacao:Array;
		private var populacaoIntermediaria:Array;
		private var geracaoAtual:int;
		
		public function AlgoritmoPG(){
			
		}
		public static function arredonda( valor:Number):int{
			var val:int = Math.round(valor);
//			return (val<0)?0:val;
			return val;
		}
		
		
		private function inicializaPopulacao():void{
			populacao = new Array();
			populacaoIntermediaria = new Array();
			
			for(var i:int = 0 ; i < TAMANHO_POPULACAO ; i++){
				populacao[i] = this.gerarIndividuo();
			}
		}
		
		
		
		private function gerarIndividuo():Individuo {
					
					var novo:Individuo = new Individuo();
					var quantidadeOperacoes:int = OPERACOES_MAX;// AlgoritmoPG.arredonda(Math.random() * (OPERACOES_MAX - 10)) + 6;
					
					for(var i:int = 0 ; i < quantidadeOperacoes ; ++i){
						novo.adicionarOperacao(this.gerarOperacao());
					}
					
					return novo;
				}
		
		
		private function gerarIndividuo2():Individuo {
			
			var novo:Array = new Array();
			var quantidadeOperacoes:int = AlgoritmoPG.arredonda(Math.random() * (OPERACOES_MAX - OPERACOES_MIN)) + OPERACOES_MIN;
			
			for(var i:int = 0 ; i < GRAUS_DE_LIBERDADE ; ++i){
				novo.push( new Individuo() );
			}
			
			//Gera um indivíduo enviesado pra o caminho correto
			//Com uma quantidade de operações com tamanho aleatório ou
			//que possua uma distanciaFinal menor que o valor de PRECISAO_DISTANCIA
			var dist:Number = Number.MAX_VALUE;//Double.MAX_VALUE;
	//		for(var i:int = 0 ; (i < quantidadeOperacoes) && (dist > PRECISAO_DISTANCIA) ; ++i){
			for(var i:int = 0 ; (i < quantidadeOperacoes) && (dist > PRECISAO_DISTANCIA) ; ++i){
				
				for(var j:int = 0 ; j < GRAUS_DE_LIBERDADE ; ++j){
					Individuo(novo[j]).adicionarOperacao(this.gerarOperacao(j));
				}
				
				novo = Operadores.ordenaPeloFitness.apply(null,novo);			
				
				for(var k:int = 1 ; k < novo.length ; ++k){
					novo[k] = novo[0].clone();
				}
				
				dist = Individuo(novo[0]).fitness.distanciaFinal;
			}
			
			return novo[0];
		}
		
		private function avaliaPopulacao():void {
			for(var i:int = 0 ; i < this.populacao.length ; i++){
				this.populacao[i].fitness;
			}
		}
		
		
		private function atingiuCondicaoParada():Boolean {
			var fitnessMelhor:Fitness = this.populacao[0].fitness;
			return((fitnessMelhor.distanciaFinal <= AlgoritmoPG.PRECISAO_DISTANCIA) && (this.geracaoAtual >= AlgoritmoPG.GERACOES_MAX));
		}
		
		
		public function gerarOperacao(vert:int = -1):Operacao {
			var vertebra:int;
			if(vert==-1){ 
				vertebra =  AlgoritmoPG.arredonda(Math.random() * (GRAUS_DE_LIBERDADE - 1)); 
			}else{
				vertebra =  vert; 
			}
			//var angulo:int = AlgoritmoPG.arredonda(Math.random() * (ANGULO_MAXIMO_INICIAL + ANGULO_MAXIMO_INICIAL)) - ANGULO_MAXIMO_INICIAL;
			
			
			var ang:int = this.randRange(ANGULO_MAXIMO_INICIAL[vertebra],ANGULO_MAXIMO_FINAL[vertebra]);
			var angulo:int = (Math.random()*10 )%2==1? -1*ang : ang ;
			return new Operacao(vertebra, angulo);
		}
		 
		
		private function randRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		public function buscarSolucao():Individuo{
			MonsterDebugger.trace(this, "buscarSolucao" );
			var indiceInter:int = 0;
			
			//inicializar População
			this.inicializaPopulacao();
			//trace("Inicializou a população");
			
			MonsterDebugger.trace(this, "Inicializou a população" );
			
			//calcular Fitness da População
			this.avaliaPopulacao();
			//trace("avaliou a população");
			MonsterDebugger.trace(this, "Avaliou a população" );
			
			while ( !this.atingiuCondicaoParada() ) // enquanto não atingir uma condição de parada
			{
				
				//seleciona dois indivíduos
				//decide se vai fazer mutação ou recombinação
				//executa a operação
				
				var indiceRamdom1:int = AlgoritmoPG.arredonda(Math.random() * (AlgoritmoPG.TAMANHO_POPULACAO - 1));
				var indiceRamdom2:int = AlgoritmoPG.arredonda(Math.random() * (AlgoritmoPG.TAMANHO_POPULACAO - 1));
				
				indiceInter = 0;
				while ( indiceInter < TAMANHO_POPULACAO )
				{
					var condicaoMutacaoRecombinacao:Number = Math.random();
					
					if((condicaoMutacaoRecombinacao >= TAXA_RECOMBINACAO) || (indiceInter == TAMANHO_POPULACAO - 1)){
						//Aplica mutação
					//	MonsterDebugger.trace( this, "mutação")
						this.populacaoIntermediaria[indiceInter] = Operadores.mutacao(this.populacao[indiceRamdom1]);
						indiceInter++;
						
					}else{
						//Aplica recombinação
					//	MonsterDebugger.trace( this, "recombinação")
						var novos:Array = Operadores.recombinacao(this.populacao[indiceRamdom1], this.populacao[indiceRamdom2]);
						this.populacaoIntermediaria[indiceInter] = novos[0];
						this.populacaoIntermediaria[indiceInter + 1] = novos[1];
						indiceInter += 2;
						
					}
				}
				
				this.populacao = Operadores.selecao(this.populacao,this.populacaoIntermediaria);
			//	this.populacao = this.populacaoIntermediaria;
				
				//trace("Geração atual: "+geracaoAtual);
				
				MonsterDebugger.trace(this, "Geração atual: "+geracaoAtual );
				this.geracaoAtual++;
				var fitness:Fitness = this.populacao[0].fitness;
				MonsterDebugger.trace( this,this.populacao[0] )
				MonsterDebugger.trace(this,"Melhor: distancia = "+fitness.distanciaFinal+", operações = "+fitness.somaDistancias);
			}
			
//			return this.posProcessamento(this.populacao[0]);
			return  (this.populacao[0]);
		}
		
		
		
		
		private  function posProcessamento( individuo:Individuo):Individuo {
			MonsterDebugger.trace(this, "posProcessamento" );
			var listaOperacoes:Vector.<Operacao> = new Vector.<Operacao>();
			
			var tamanho:int = individuo.quantidadeOperacoes();
			for(var i:int = 0 ; i < tamanho ; ++i){
				var op:Operacao = individuo.getOperacao(i);
				if(op.getAngulo() != 0){
					listaOperacoes.push(op);
				} 
			}
			
			for(var i:int = 0 ; i + 1 < tamanho ; ++i){
				
				var op1:Operacao = listaOperacoes[i];
				if(listaOperacoes[i + 1]){
					var op2:Operacao = listaOperacoes[i + 1];
				}
				
				
				if(op1.getEixo() == op2.getEixo()){
					
					listaOperacoes.splice(i,1);
					listaOperacoes.splice(i,1);
					
					var novo:Operacao = new Operacao(op1.getEixo(), op1.getAngulo() + op2.getAngulo());
					listaOperacoes[i] = novo;
					
					tamanho = listaOperacoes.length;
					--i;
				}
			}
 
			return new Individuo(listaOperacoes);
		}
		 
		 
		
	}
}
