package br.poli.computacaonatural {
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class Task {
		
		private var _axis:int = 0;
		private var _degree:Number = 0;
		
		public function Task(axis:int = 0, degree:Number = 0) {
			this._axis = axis;
			this._degree = degree;
		}
		
		public function get axis():int {
			return _axis;
		}
		
		public function set axis(value:int):void {
			_axis = value;
		}
		
		public function get degree():Number {
			return _degree;
		}
		
		public function set degree(value:Number):void {
			_degree = value;
		}
		
	}

}