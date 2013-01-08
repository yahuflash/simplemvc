package sban.simplemvc.model.vo
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import sban.simplemvc.model.proxy.MemoryProxy;
	
	/**
	 * VO对于定义应用中的ValueObject 
	 * @author sban
	 * 
	 */	
	public class SimpleVO
	{
		/**
		 *  
		 * @param source
		 * @return 
		 * 
		 */		
		public static function clone(source :Object):Object
		{
			var c :Class = getDefinitionByName( getQualifiedClassName(source) ) as Class;
			var r :Object = new c;
			
			for(var s :String in source)
			{
				r[s] = source[s];
			}
			
			return r;
		}
		
		public static function toXML(source :Object):XML
		{
			var qname :String = getQualifiedClassName(source);
			var r :XML = <vo qname={qname}/>;
			
			for(var s :String in source)
			{
				r.appendChild(<{s}>{source[s]}</{s}>);
			}
			
			return r;
		}
		
		public static function fromXML(source :XML, dest :Object = null):Object
		{
			dest = dest ? dest : {};
			
			for(var s :String in source)
			{
				dest[s] = source[s];
			}
			
			return dest;
		}
		
		public static function toJSON(source :Object):String
		{
			return JSON.stringify(source);
		}
		
		public static function fromJSON(source :String, dest :Object = null):Object
		{
			dest = dest ? dest : {};
			var jsonObj :Object = JSON.parse(source);
			
			for(var s :String in jsonObj)
			{
				dest[s] = jsonObj[s];
			}
			
			return dest;
		}
		
		public static function toAMF(source :Object):Object
		{
			var r :Object = {};
			
			for(var s :String in source)
			{
				r[s] = source[s];
			}
			
			return r;
		}
		
		public static function fromAMF(source :Object, dest :Object = null):Object
		{
			dest = dest ? dest : {};
			
			for(var s :String in source)
			{
				dest[s] = source[s];
			}
			
			return dest;
		}
		
		public function SimpleVO()
		{
		}
		
		protected var _name :String;
		protected var _type :Class;

		public function get type():Class
		{
			if(!_type)
			{
				_type = getDefinitionByName( getQualifiedClassName(this) ) as Class;
			}
			return _type;
		}
		
		public function get name():String
		{
			if(!_name)
			{
				_name = getQualifiedClassName(this);
				if(_name.indexOf("::") > -1)
					_name = _name.split("::")[1];
			}
			return _name;
		}
		
		public function get memory():MemoryProxy
		{
			return MemoryProxy.single;
		}
		
		public function clone():SimpleVO
		{
			return SimpleVO.clone(this) as SimpleVO;
		}
		
		public function toXML():XML
		{
			return SimpleVO.toXML(this);
		}
		
		public function fromXML(source :XML):void
		{
			SimpleVO.fromXML(source, this);
		}
		
		public function toJSON():String
		{
			return SimpleVO.toJSON(this);
		}
		
		public function fromJSON(source :String):void
		{
			SimpleVO.fromJSON(source, this);
		}
		
		public function toAMF():Object
		{
			return SimpleVO.toAMF(this);
		}
		
		public function fromAMF(source :Object):void
		{
			SimpleVO.fromAMF(source, this);
		}
		
		
		
	}
}