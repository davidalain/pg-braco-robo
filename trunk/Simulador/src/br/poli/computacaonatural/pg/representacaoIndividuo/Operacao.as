package br.poli.computacaonatural.pg.representacaoIndividuo
{
	public class Operacao
	{
		
		private var eixo:int;
		private var angulo:int;
		public function Operacao(  vertebra:int,   angulo:int){
			this.eixo = vertebra;
			this.angulo = angulo;
		
		}
		
		public function getEixo():int {
			return eixo;
		}
		
		public function setEixo( eixo:int):void {
			this.eixo = eixo;
		}
		
		public function getAngulo():int {
			return angulo;
		}
		
		public function setAngulo( valor:int):void {
			this.angulo = valor;
		}
	}
}

 
	  