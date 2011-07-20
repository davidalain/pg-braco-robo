package {
	import away3d.core.stats.Tasks;
	
	import br.poli.computacaonatural.RoboticArm;
	import br.poli.computacaonatural.RoboticArmDAE;
	import br.poli.computacaonatural.Task;
	import br.poli.computacaonatural.events.RoboticArmEvent;
	import br.poli.computacaonatural.pg.AlgoritmoPG;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Individuo;
	import br.poli.computacaonatural.pg.representacaoIndividuo.Operacao;
	import br.poli.computacaonatural.simulador.Modelo3D;
	
	//import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.ricardoteix.network.ControleServerSocket;
	import org.ricardoteix.network.events.ControleServerSocketEvent;
	
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	[SWF(width="800", height="600" ,frameRate="60")]
	public class Simulador extends Sprite {
		
		private var tasks:Vector.<Task>;
		private var serverSocket:ControleServerSocket;
		private var arm:RoboticArm;
//		private var arm:RoboticArmDAE;
		private var timer:Timer;
		private var interval:TextField;
		private var status:TextField;
		private var timerInterval:Number;
		
		private var cliente:Socket;
		
		public function Simulador():void {
			this.timerInterval = 1;
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
			
			this.status = new TextField ();
			this.status.x = 10;
			this.status.y = this.interval.y + this.interval.height + 10;
			this.status.width = 100;
			this.status.height = 100;
			this.status.background = true;
			this.addChild (this.status);
			
			/* Simulação
			
			
			for (var i:int = 0; i < 500; i++) {
			var a:int = Math.round (Math.random () * 2);
			var d:Number = Math.round (Math.random () * (10 - (-10)) + (-10));
			var task:Task = new Task (a, d);
			this.tasks.push (task);
			}
			*/
			
			// this.tasks.push (new Task (1, 21 ) );this.tasks.push (new Task (0, 7 ) );this.tasks.push (new Task (1, 7 ) );this.tasks.push (new Task (0, -4 ) );this.tasks.push (new Task (1, 6 ) );this.tasks.push (new Task (0, -7 ) );this.tasks.push (new Task (2, 2 ) );
			//this.tasks.push (new Task (2, -5 ) );this.tasks.push (new Task (1, 10 ) );this.tasks.push (new Task (0, 9 ) );this.tasks.push (new Task (1, 9 ) );this.tasks.push (new Task (0, 8 ) );
		//	this.tasks.push (new Task (0, 9 ) );this.tasks.push (new Task (1, 1 ) );this.tasks.push (new Task (0, -1 ) );this.tasks.push (new Task (1, 6 ) );this.tasks.push (new Task (2, 7 ) );this.tasks.push (new Task (1, 3 ) );this.tasks.push (new Task (0, 10 ) );
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//this.serverSocket = new ControleServerSocket ();
			//this.serverSocket.addEventListener (ControleServerSocketEvent.ESCUTANDO, onEscuta);
			//this.serverSocket.addEventListener (ControleServerSocketEvent.CONECTADO, onConectado);
			//this.serverSocket.addEventListener (ControleServerSocketEvent.DADO_CLIENTE, onDadoCliente);
			//this.serverSocket.iniciar ();
			
			//this.arm = new RoboticArmDAE ();
			this.arm = new RoboticArm ();
			
			this.arm.addEventListener (RoboticArmEvent.END_ROTATE, onEndRotate);
			this.arm.addEventListener (RoboticArmEvent.INVALID_ROTATION, onInvalidRotation);
			this.arm.addEventListener (RoboticArmEvent.VALID_ROTATION, onValidRotation);
			this.addChild (this.arm);
			
			Key.initialize (this.stage);
			
			//this.timer.start ();
			
			this.stage.addEventListener (Event.ENTER_FRAME, onKeyDown);
			
			
			
			
			/////////////
			//MonsterDebugger.initialize(this);
			
			Modelo3D.arm = this.arm;
			Modelo3D.tasks = this.tasks;
			
			/*
			*/
			setTimeout(
			function():void{
			
				var algPG:AlgoritmoPG = new AlgoritmoPG();
				var solucao:Individuo = algPG.buscarSolucao();
				
				trace("\nO código pra executar a melhor solução é:\n\n");
				trace("---------------------");
				var RESPOSTA:String= "";
				for(var i:int = 0 ; i < solucao.quantidadeOperacoes() ; ++i){
					var op:Operacao = solucao.getOperacao(i);
					 
					RESPOSTA += ("this.tasks.push (new Task ("+op.getEixo()+", "+op.getAngulo()+" ) );\n");
					 
				}
				//MonsterDebugger.trace(this, RESPOSTA);
				trace(RESPOSTA);
			
			},1000);
				
			
			
			
			
		}
		
		private function onValidRotation(e:RoboticArmEvent):void {
			if (this.cliente != null && this.cliente.connected) {
				this.cliente.writeUTF ("1\n");
				this.cliente.flush ();
			}
		}
		
		private function onInvalidRotation(e:RoboticArmEvent):void {	
			if (this.cliente != null && this.cliente.connected) {
				this.cliente.writeUTF ("0\n");
				this.cliente.flush ();
			}
		}
		
		private function onTimer(e:TimerEvent):void {
			//Simulação
			/*var a:int = Math.round (Math.random () * 2);
			var d:Number = Math.round (Math.random () * (20 - (-20)) + (-20));
			var t:Task = new Task (a, d);
			this.tasks.push (t);*/
			
			if (this.tasks.length > 0) {
				var task:Task = this.tasks.shift ();
				switch (task.axis) {
					case 0: this.arm.rotateBase (task.degree); break;
					case 1: this.arm.rotateArm (task.degree); break;
					case 2: this.arm.rotateSubArm (task.degree); break;
				}
			}
			
			this.status.text = this.arm.toString ();
		}
		
		private function onEndRotate(e:RoboticArmEvent):void {
			//trace ("onEndRotate", Math.round (e.distances[0]));
			
			if (e.distances[0] < 40) {
				
			}
		}
		
		private function onDadoCliente(e:ControleServerSocketEvent):void {
			// TODO Criar fila de execução e definir protocolo
			this.cliente = e.cliente;
			
			
			var lista:Array = e.dado.split ("#");
			lista.shift();
			
			
		 for (var i:int = 0; i < lista.length; i++) 
		 {
			 
			 var comando:String = lista[i].split (";")[0];
			 
			 trace ("onDadoCliente:", comando,lista[i]);
		//	 trace ("dado:", e.dado);
			 
			 if (comando == "dist") {
				 
		//		 trace ("dist:" , String (e.dado));
				 
				 var dist:Number = Number (this.arm.distances ()[0]);
				 
				 trace ("valor:", dist)
				 
				 //e.cliente.writeBytes (ba, 0, ba.bytesAvailable);
				 e.cliente.writeUTF (dist.toString ());
				 e.cliente.writeUTF ("\n");
				 e.cliente.flush ();
				 
				 this.arm.reset ();
				 
			 } else if (lista[i].indexOf (";") != -1) {
				 
				 var task:Task = new Task ();
				 task.axis = int (lista[i].split (";")[0]);
				 task.degree = Number (lista[i].split (";")[1]);
				 
				 this.tasks.push (task);
				 /*
				 e.cliente.writeUTF ("1");
				 e.cliente.writeUTF ("\n");
				 e.cliente.flush ();*/
				 
			 }
			 // 54 11 5246-1500
			 // 6.98.19.31.06
		 }
			
			
			
		}
		
		private function onConectado(e:ControleServerSocketEvent):void {
			trace ("Conectado");
			this.arm.reset ();
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
				if (this.timerInterval <= 0) {
					this.timerInterval = 1;
				}
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
			this.status.text = this.arm.toString ();
			
		//	var v:Vector.<Number> = this.arm.distances ();
			
			//var dist:Number = Number (v[0]);
			
		//	trace ("valor:", v)
		}
		
	}
	
}