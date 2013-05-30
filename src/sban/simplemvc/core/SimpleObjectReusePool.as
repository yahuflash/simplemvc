package sban.simplemvc.core
{
	import flash.utils.getQualifiedClassName;
	
	import sban.simplemvc.interfaces.IReusable;

	public final class SimpleObjectReusePool
	{
		private static var instance:SimpleObjectReusePool;
		public static function get sharedInstance():SimpleObjectReusePool{
			return (instance ||= new SimpleObjectReusePool);
		}
		public function SimpleObjectReusePool()
		{
		}
		private var objVecPool:Object = {};
		
		/**将对象推入对象池，如果是IReusable对象，将使用reuseKey，如果不是，使用对象类型字符串
		 * 如果池中已存在同一对象，不推入
		 * 如果是Ireusable对象，在推入之前，调用dispose方法
		 * @return 如果不存在，推入成功，否则返回fase*/
		public function push(obj:Object):Boolean{
			var reuseKey:String = this.reuseKeyOf(obj);
			var vec:Vector.<Object> = (objVecPool[reuseKey] ||= new <Object>[]);
			if(vec.indexOf(obj) < 0){
				if(obj is IReusable) (obj as IReusable).dispose();
				vec.push( obj );
				return true;
			}
			return false;
		}
		
		/**从对象池中拉出可复用对象，如果没有，返回null
		 * @param reuseKey，可复用对象的key*/
		public function pull(reuseKey:String):Object{
			var vec:Vector.<Object> =(objVecPool[reuseKey] ||= new <Object>[]);
			if(vec.length > 0)
				return vec.shift();
			return null;
		}
		
		/**返回对象的复用key
		 * 三种返回类型：
		 * <pre>
		 * 1,simplemvc_as3_test_by_sban
		 * 2,sban.simplemvc.core::SimpleEvent::someEventType
		 * 3,flash.events::EventDispatcher</pre>*/
		public function reuseKeyOf(obj:Object):String{
			if(obj is IReusable)
				return (obj as IReusable).reuseKey;
			return flash.utils.getQualifiedClassName(obj);
		}
		
	}
}