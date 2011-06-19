package  {
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class DadoVO {
		
		private var _idPivot:int = 0;
		private var _valor:Number = 0;
		
		public function DadoVO() {
			
		}
		
		public function get valor():Number {
			return _valor;
		}
		
		public function set valor(value:Number):void {
			_valor = value;
		}
		
		public function get idPivot():int {
			return _idPivot;
		}
		
		public function set idPivot(value:int):void {
			_idPivot = value;
		}
		
	}

}