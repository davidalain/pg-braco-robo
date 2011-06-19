package {
	import br.poli.computacaonatural.events.RoboticArmEvent;
	import br.poli.computacaonatural.RoboticArm;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import org.ricardoteix.network.ControleServerSocket;
	import org.ricardoteix.network.events.ControleServerSocketEvent;
	
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class Main extends Sprite {
		
		private var serverSocket:ControleServerSocket;
		private var arm:RoboticArm;
		
		public function Main():void {
			this.addEventListener (Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.serverSocket = new ControleServerSocket ();
			this.serverSocket.addEventListener (ControleServerSocketEvent.ESCUTANDO, onEscuta);
			this.serverSocket.addEventListener (ControleServerSocketEvent.CONECTADO, onConectado);
			this.serverSocket.addEventListener (ControleServerSocketEvent.DADO_CLIENTE, onDadoCliente);
			this.serverSocket.iniciar ();
			
			this.arm = new RoboticArm ();
			this.arm.addEventListener (RoboticArmEvent.END_ROTATE, onEndRotate);
			this.addChild (this.arm);
			
			Key.initialize (this.stage);
						
			this.stage.addEventListener (Event.ENTER_FRAME, onKeyDown);
		}
		
		private function onEndRotate(e:RoboticArmEvent):void {
			trace ("onEndRotate", Math.round (e.distances[0]));
			
			if (e.distances[0] < 40) {
				
			}
		}
		
		private function onDadoCliente(e:ControleServerSocketEvent):void {
			// TODO Criar fila de execução e definir protocolo
			
			var dado:DadoVO = new DadoVO ();
			dado.idPivot = int (e.dado.split (";")[0]);
			dado.valor = Number (e.dado.split (";")[1]);
			
			switch (dado.idPivot) {
				case 0: this.arm.rotateBase (dado.valor); break;
				case 1: this.arm.rotateArm (dado.valor); break;
				case 2: this.arm.rotateSubArm (dado.valor); break;
				//case 3: this.arm.rotateJuncao2 (dado.valor); break;
			}
			
				/*		
			switch (dado.idPivot) {
				case 0: this.arm.rotate (dado.valor); break;
				case 1: this.arm.rotateGeral (dado.valor); break;
				case 2: this.arm.rotateJuncao1 (dado.valor); break;
				case 3: this.arm.rotateJuncao2 (dado.valor); break;
			}*/
			
		}
		
		private function onConectado(e:ControleServerSocketEvent):void {
			trace ("Conectado");
		}
		
		private function onEscuta(e:ControleServerSocketEvent):void {
			trace ("onEscuta");
		}
		
		private function onKeyDown(e:Event):void {
			
			if (Key.isDown (Keyboard.LEFT)) this.arm.rotateBase (2);
			if (Key.isDown (Keyboard.RIGHT)) this.arm.rotateBase ( -2);
			
			if (Key.isDown (Keyboard.A)) this.arm.rotateArm (2);
			if (Key.isDown (Keyboard.S)) this.arm.rotateArm (-2);
			
			if (Key.isDown (Keyboard.D)) this.arm.rotateSubArm (2);
			if (Key.isDown (Keyboard.F)) this.arm.rotateSubArm ( -2);
			
			
			if (Key.isDown (Keyboard.SPACE)) this.arm.release ();
			
			//if (Key.isDown (Keyboard.X)) this.arm.rotateJuncao2 (10);
			//if (Key.isDown (Keyboard.C)) this.arm.rotateJuncao2 (-10);
		}
		
	}
	
}