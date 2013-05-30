package simplemvc.core
{
	import flash.utils.getQualifiedClassName;
	
	/**对象复用池*/
	public final class SimpleObjectPool
	{
		private static var instance:SimpleObjectPool;
		public static function sharedInstance():SimpleObjectPool{
			return (instance ||= new SimpleObjectPool);
		}
		
		/**返回对象的复用key*/
		public static function reuseKeyOf(obj:Object):String{
			return flash.utils.getQualifiedClassName(obj);
		}
		
		public function SimpleObjectPool(){}
		private var objects:Object = {};
		
		/**将对象推入对象池，如果是IReusable对象，将使用reuseKey，如果不是，使用对象类型字符串
		 * 如果池中已存在同一对象，不推入
		 * @return 如果不存在，推入成功，否则返回fase*/
		public function push(obj:Object):Boolean{
			var reuseKey:String = reuseKeyOf(obj);
			var vec:Vector.<Object> = (objects[reuseKey] ||= new <Object>[]);
			if(vec.indexOf(obj) < 0){
				vec[vec.length]=obj;
				return true;
			}
			return false;
		}
		
		/**从对象池中拉出可复用对象，如果没有，返回new c
		 * @param c，对象类型*/
		public function pull(c:Class):Object{
			var reuseKey:String = reuseKeyOf(c);
			var vec:Vector.<Object> = objects[reuseKey];
			if(vec && vec.length > 0)
				return vec.pop();
			return (new c);
		}
		/**清除某类型的对象*/
		public function clear(c:Class=null):void{
			if(!c){
				objects={};
			}else{
				var reuseKey:String = reuseKeyOf(c);
				var vec:Vector.<Object> = objects[reuseKey];
				if(vec) vec.length=0;
			}
		}
		
		public function toString():String{
//			trace("SimpleObjectReusePool.print:");
			var r:String="";
			for(var reuseKey:String in objects)
			{
				var vec:Vector.<Object> = objects[reuseKey];
				r += "\nreuseKey:"+reuseKey+",count:"+vec.length;
			}
			return r;
		}
		
		
	}
}