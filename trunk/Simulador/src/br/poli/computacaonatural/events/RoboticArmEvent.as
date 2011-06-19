package br.poli.computacaonatural.events {

	import br.poli.computacaonatural.model3d.ElementModel;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class RoboticArmEvent extends Event {
		
		public static const END_ROTATE:String = "endRotate";
		public static const COLLISION:String = "collision";
		
		private var _distances:Vector.<Number>;
		private var _object:ElementModel;
		
		public function RoboticArmEvent(type:String, distances:Vector.<Number> = null, object:ElementModel = null, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this._distances = distances;
			this._object = object;
		} 
		
		public override function clone():Event { 
			return new RoboticArmEvent(type, this._distances, this._object, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("RoboticArmEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get distances():Vector.<Number> {
			return _distances;
		}
		
		public function get object():ElementModel {
			return _object;
		}
		
	}
	
}