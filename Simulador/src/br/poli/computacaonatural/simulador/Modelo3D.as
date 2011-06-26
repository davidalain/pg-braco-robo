package br.poli.computacaonatural.simulador
{
	import br.poli.computacaonatural.RoboticArm;
	import br.poli.computacaonatural.Task;
	import br.poli.computacaonatural.model3d.Arm;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Operacao;

	public class Modelo3D
	{
		public static var arm:RoboticArm; 
		public static var tasks:Vector.<Task>; 
		
		public function Modelo3D()
		{
		}
		
		
		 
		public static function reset():void
		{
			arm.reset();
		}
		
		public static function calculaDistancia():Number
		{
			var dist:Number = arm.distances();//[0]
			return dist;
		}
		public static function executarOperacao(op:Operacao):int
		{
			var task:Task = new Task (op.getEixo(), op.getAngulo());
			//tasks.push (task);
			var retorno:int;
			
			switch (task.axis) {
				case 0: retorno = arm.rotateBase (task.degree); break;
				case 1: retorno = arm.rotateArm (task.degree); break;
				case 2: retorno = arm.rotateSubArm (task.degree); break;
			}
			
			
			return retorno;
		}
		
		
	}
}
 
	
