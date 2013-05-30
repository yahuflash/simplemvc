package us.sban.simplemvc.core
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	public final dynamic class QueryString extends Proxy
	{
		/**
		 * 将uri地址解析为参数
		 *  
		 * @param url xxx?aa=xx&bb=xx
		 * 
		 */		
		public function QueryString()
		{
		}
		
		protected var _location :String;
		protected var _address :String;
		protected var _parameters :Object = {};

		/**
		 * ?前面的部分 
		 * @return 
		 * 
		 */		
		public function get address():String
		{
			return _address;
		}

		override flash_proxy function getProperty(name:*):*
		{
			// TODO Auto Generated method stub
			return _parameters[name.toString()];
		}
		
		public function parse(location:String):void
		{
			this._location = location;
			if(_location.indexOf("?")>-1)
			{
				this._address = this._location.split("?")[0];
				var pairs :Array = this._location.split("?")[1].split("&");
				
				var pairName:String;
				var pairValue:String;
				
				for (var i:int = 0; i <pairs.length; i++)
				{
					pairName = pairs[i].split("=")[0];
					pairValue = pairs[i].split("=")[1];
					_parameters[pairName] = pairValue;
				}
			}else{
				_address = _location;
			}
		}

		public function toString():String
		{
			return _location;
		}
	}
}