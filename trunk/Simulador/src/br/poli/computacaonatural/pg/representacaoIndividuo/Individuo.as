package br.poli.computacaonatural.pg.representacaoIndividuo
{
	
	import br.poli.computacaonatural.pg.AlgoritmoPG;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Fitness;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Operacao;
	import br.poli.computacaonatural.simulador.Modelo3D;
	
	
	public class Individuo
	{
		
		 
		private var listaOperacoes:Vector.<Operacao> ;
		
		private var avaliado:Boolean ;
		private var _fitness:Fitness;
		
		private var possuiOperacaoInvalida:Boolean;
		
		public function Individuo(vec:Vector.<Operacao> = null)
		{
			avaliado = false;
			possuiOperacaoInvalida = false;
			listaOperacoes = (vec)?vec : new Vector.<Operacao>();
			_fitness = new Fitness();
		}
		
		
		 
		
		public function get lista():Array {
			var arr:Array = new Array()
			for (var i:int = 0; i < this.listaOperacoes.length; i++) {
				arr.push( this.listaOperacoes[i].toString() );
			}
			return arr;
		}
		
		public function get fitness():Fitness{
			
			if(!this.avaliado){
				
				avaliado = true;
				_fitness.distanciaFinal = 0;
				_fitness.somaDistancias = 0;
				
				Modelo3D.reset();
				
				for (var i:int = 0 ; i < this.listaOperacoes.length ; i++) { 
					
					var op:Operacao = this.listaOperacoes[i];
					var sucesso:int = Modelo3D.executarOperacao(op);
					if(sucesso == 0){
						possuiOperacaoInvalida = true;
						
						op.setAngulo(-Math.round(op.getAngulo()/2));
						//this.avaliado = false;
						//break;
						i--
					}
					else
					_fitness.somaDistancias += Modelo3D.calculaDistancia();
				}
 
/*
				if(possuiOperacaoInvalida){
					_fitness.distanciaFinal = Number.MAX_VALUE;
				}else{
					
				}
				*/
				_fitness.distanciaFinal = Modelo3D.calculaDistancia();
			}
			
			return _fitness;
		}
		
		
		
		
		public function isIndividuoValido ():Boolean //Para depois tratar restrições
		{
			return ((!this.possuiOperacaoInvalida) && (this.listaOperacoes.length <= AlgoritmoPG.OPERACOES_MAX));
		}
		
		
		
		public function adicionarOperacao(op:Operacao ):void{
			this.listaOperacoes.push(op);
			this.avaliado = false;
		}
		
		public function getOperacao( indice:int):Operacao{
			return this.listaOperacoes[(indice)];
		}
		
		public function quantidadeOperacoes():int{
			return this.listaOperacoes.length;
		}
		
		public function clone():Individuo{
			var novaLista:Vector.<Operacao> = this.listaOperacoes.concat();
			return new Individuo(novaLista);
		}
		
		
	}
}

 
	 

	  