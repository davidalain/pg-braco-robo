package org.ricardoteix.network.events {
	import flash.events.Event;
	import flash.net.Socket;
	
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class ControleServerSocketEvent extends Event{
		
		public static const ESCUTANDO:String = "escutando";		
		public static const DADO_CLIENTE:String = "dadoCliente";		
		public static const CONECTADO:String = "conectado";		
		public static const DESCONECTADO:String = "desconectado";		
		public static const ERRO:String = "erro";		
		public static const ERRO_SEGURANCA:String = "erroSeguranca";		
		
		private var _cliente:Socket;
		private var _clienteId:int;
		private var _dado:String;
		
		public function ControleServerSocketEvent(type:String, cliente:Socket = null, clienteId:int = -1, dado:String = "", bubbles:Boolean = false, cancelable:Boolean = false) {
			super (type, bubbles, cancelable);
			
			this._dado = dado;
			this._cliente = cliente;
			this._clienteId = clienteId;
		}
		
		public function get cliente():Socket { return _cliente; }
		
		public function get clienteId():int { return _clienteId; }
		
		public function get dado():String { return _dado; }
		
	}

}