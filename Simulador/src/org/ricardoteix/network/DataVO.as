package New Folder.ricardoteix.network {
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public dynamic class DataVO{
		
		private var _dataType:String; 
		private var _data:Object;
		
		public function DataVO(dataType:String = "Object", data:Object = null) {
			this._dataType = dataType;
			this._data = data;
		}
		
		public function get dataType():String { return _dataType; }
		
		public function set dataType(value:String):void {
			_dataType = value;
		}
		
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		public function toString ():String {
			return "DataVO [dataType: " + this._dataType + ", data: " + this._data + "]";
		}
	}

}