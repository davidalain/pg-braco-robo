package {
	import away3d.core.stats.Tasks;
	import br.poli.computacaonatural.events.RoboticArmEvent;
	import br.poli.computacaonatural.RoboticArm;
	import br.poli.computacaonatural.Task;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import org.ricardoteix.network.ControleServerSocket;
	import org.ricardoteix.network.events.ControleServerSocketEvent;
	
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class Main extends Sprite {
		
		private var tasks:Vector.<Task>;
		private var serverSocket:ControleServerSocket;
		private var arm:RoboticArm;
		private var timer:Timer;
		private var interval:TextField;
		private var timerInterval:Number;
		
		public function Main():void {
			this.timerInterval = 1000;
			this.timer = new Timer (this.timerInterval);
			this.timer.addEventListener (TimerEvent.TIMER, onTimer);
			this.tasks = new Vector.<Task>();
			this.addEventListener (Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			this.interval = new TextField ();
			this.interval.x = 10;
			this.interval.y = 10;
			this.interval.width = 50;
			this.interval.height = 25;
			this.interval.background = true;
			this.interval.restrict = "0-9";
			this.interval.type = TextFieldType.INPUT;
			this.interval.text = this.timerInterval.toString ();
			this.addChild (this.interval);
			
			/* Simulação
			for (var i:int = 0; i < 500; i++) {
				var a:int = Math.round (Math.random () * 2);
				var d:Number = Math.round (Math.random () * (10 - (-10)) + (-10));
				var task:Task = new Task (a, d);
				this.tasks.push (task);
			}*/
			
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
			
			this.timer.start ();
			
			this.stage.addEventListener (Event.ENTER_FRAME, onKeyDown);
		}
		
		private function onTimer(e:TimerEvent):void {
			//Simulação
			var a:int = Math.round (Math.random () * 2);
			var d:Number = Math.round (Math.random () * (10 - (-10)) + (-10));
			var t:Task = new Task (a, d);
			this.tasks.push (t);
			
			if (this.tasks.length > 0) {
				var task:Task = this.tasks.shift ();
				switch (task.axis) {
					case 0: this.arm.rotateBase (task.degree); break;
					case 1: this.arm.rotateArm (task.degree); break;
					case 2: this.arm.rotateSubArm (task.degree); break;
				}
			}
		}
		
		private function onEndRotate(e:RoboticArmEvent):void {
			trace ("onEndRotate", Math.round (e.distances[0]));
			
			if (e.distances[0] < 40) {
				
			}
		}
		
		private function onDadoCliente(e:ControleServerSocketEvent):void {
			// TODO Criar fila de execução e definir protocolo
			
			var task:Task = new Task ();
			task.axis = int (e.dado.split (";")[0]);
			task.degree = Number (e.dado.split (";")[1]);
			
			this.tasks.push (task);
			
			/*switch (task.axis) {
				case 0: this.arm.rotateBase (dado.degree); break;
				case 1: this.arm.rotateArm (dado.degree); break;
				case 2: this.arm.rotateSubArm (dado.degree); break;
			}*/
			
		}
		
		private function onConectado(e:ControleServerSocketEvent):void {
			trace ("Conectado");
		}
		
		private function onEscuta(e:ControleServerSocketEvent):void {
			trace ("onEscuta");
		}
		
		private function onKeyDown(e:Event):void {
			
			if (Key.isDown (Keyboard.UP)) {
				this.timerInterval += 1;
				this.timer.delay = this.timerInterval;
				this.interval.text = this.timerInterval.toString ();
			}
			if (Key.isDown (Keyboard.DOWN)) {
				this.timerInterval -= 1;
				this.timer.delay = this.timerInterval;
				this.interval.text = this.timerInterval.toString ();
			}
			
			if (Key.isDown (Keyboard.ENTER)) {
				this.timerInterval = Number (this.interval.text);
				this.timer.delay = this.timerInterval;
			}
			
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