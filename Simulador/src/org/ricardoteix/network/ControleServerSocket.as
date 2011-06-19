package org.ricardoteix.network {
	import org.ricardoteix.network.events.ControleServerSocketEvent;
	import flash.desktop.InteractiveIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * Controla inicia o serviço e controla as conexões.
	 * @author Ricardo Teixeira
	 */
	public class ControleServerSocket extends EventDispatcher {
		
		private var clientes:Vector.<Socket>;		
		private var server:ServerSocket;
		private var _numeroConexoes:int;
		private var _qtdConectados:int;
		private var porta:int;
		
		public function ControleServerSocket (porta:int = 6667, tipo:String = "string") {
			this.porta = porta;
			this._numeroConexoes = 0;
			this.clientes = new Vector.<Socket> ();
		}
		
		/**
		 * Inicia o servidor socket e escuta as conexões.
		 */
		public function iniciar ():void{
			
			this.server = new ServerSocket ();			
			this.server.addEventListener (Event.CONNECT, onConnect);
			
			try {
				this.server.bind (this.porta);
				this.server.listen();
				var evento:ControleServerSocketEvent = new ControleServerSocketEvent (ControleServerSocketEvent.ESCUTANDO);
				this.dispatchEvent (evento);
				trace ("#ESCUTANDO");
			} catch (e:Error) {
				trace (e.message, "Error");
			}			
		}
		
		/**
		 * Envia o dado do cliente:Socket para todos os clientes conectados.
		 * @param	cliente	Socket
		 */
		public function broadcast (cliente:Socket):void {
			var buffer:ByteArray = new ByteArray();
			var clientSocket:Socket = cliente;
            clientSocket.readBytes( buffer, 0, clientSocket.bytesAvailable );
			
			var id:int = this.clientes.indexOf (cliente);
			//	/*this.clientes.splice (id, 1);*/
			
			var evento:ControleServerSocketEvent = new ControleServerSocketEvent (ControleServerSocketEvent.DADO_CLIENTE, cliente, id, buffer.toString());
			this.dispatchEvent (evento);
			/*
			for (var i:int = 0; i < this.clientes.length; i++) {
				clientSocket = this.clientes[i] as Socket;
				clientSocket.writeUTFBytes (buffer.toString());
				clientSocket.flush ();
			}*/
		}
		
		/**
		 * Envia o dado do cliente:Socket para todos os clientes conectados.
		 * @param	cliente	Socket
		 */
		public function broadcastMsg (msg:String, s:Socket=null):void {
			var clientSocket:Socket;	
			 /*
			for (var i:int = 0; i < sala.usuarios.length; i++) {
				clientSocket = sala.usuarios[i].socket as Socket;
				if (clientSocket != s) {
					clientSocket.writeUTFBytes (msg);
					clientSocket.flush ();
				}
				
			}*/
			
			trace ("broadcast");
		}
		
		
		/**
		 * Manipulador do evento Event.CONNECT do servidor socket.
		 * @param	e
		 */
		private function onConnect(e:ServerSocketConnectEvent):void {
			var cliente:Socket = Socket (e.socket);
			this.clientes.push (cliente);
			cliente.addEventListener (ProgressEvent.SOCKET_DATA, onData);
			cliente.addEventListener (Event.CLOSE, onCloseCliente);
			cliente.addEventListener (IOErrorEvent.IO_ERROR, onErrorCliente);
			cliente.addEventListener (SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			trace ("Conectou");
			
			var evento:ControleServerSocketEvent = new ControleServerSocketEvent (ControleServerSocketEvent.CONECTADO, cliente);
			this.dispatchEvent (evento);
			
			this._numeroConexoes ++;
			
			//this.broadcastMsg ("<dado tipo='conectado' info='qtdConexoes:" + this.clientes.length + "' />");
		}
		
		/**
		 *  Manipulador do evento Event.CLOSE do cliente.
		 * @param	e
		 */
		private function onCloseCliente(e:Event):void {
			var cliente:Socket = e.target as Socket;
			var id:int = this.clientes.indexOf (cliente);
			this.clientes.splice (id, 1);
			
			var evento:ControleServerSocketEvent = new ControleServerSocketEvent (ControleServerSocketEvent.DESCONECTADO, cliente, id);
			this.dispatchEvent (evento);
			trace ("Desconectou:", cliente);
		}
		
		/**
		 * Manipulador do evento ProgressEvent.SOCKET_DATA do cliente.
		 * @param	e
		 */
		private function onData(e:ProgressEvent):void {
			var cliente:Socket = Socket (e.target);
			this.broadcast (cliente);
		}
		
		private function onErrorCliente(e:IOErrorEvent):void {
			trace ("#Socket Error: onErrorCliente");
			var evento:ControleServerSocketEvent = new ControleServerSocketEvent (ControleServerSocketEvent.ERRO);
			this.dispatchEvent (evento);
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void {			
			trace ("#Socket Error: onSecurityError");
			var evento:ControleServerSocketEvent = new ControleServerSocketEvent (ControleServerSocketEvent.ERRO_SEGURANCA);
			this.dispatchEvent (evento);
		}
		
		public function get numeroConexoes():int { return _numeroConexoes; } 
		
		public function get qtdConectados():int { return this.clientes.length; }
		
	}

}