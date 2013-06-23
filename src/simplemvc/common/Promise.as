package simplemvc.common
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import simplemvc.event.SimpleDispatcher;
	
	use namespace flash_proxy;
	
	/**
	 * 动态的事件监听、派发对象
	 * 以此实现promise编程，形如action(x).done(y).fail(z)
	 * 
	 * 该类不充许被继承。如需继承，可用SimpleEventDispatcher代替。
	 * 
	 * fixed on 2013/06/21
	 * @author sban
	 * 
	 */	
	public final dynamic class Promise extends SimpleDispatcher implements IReusable
	{
		public static function create():Promise{
			return ObjectPool.sharedObjectPool().retrieveNew(Promise) as Promise;
		}
		public function Promise(){}
		
		/**是否已经派发过某事件
		 * @param 事件名*/
		flash_proxy override function getProperty(name:*):*{
			return hasDispatched(name.localName);
		}
		
		/**xxx.complete = null
		 * xxx.complete = listener
		 * */
		flash_proxy override function setProperty(name:*, value:*):void{
			name = name.localName;
			if (value == null){
				removeListenersStartWith(name);
			}else if (value is Function){
				listenTo(name,value);
			}
		}
		
		/**xxx.complete(obj)*/
		flash_proxy override function callProperty(name:*, ...args):*
		{
			dispatchWith(name.localName,(args.length > 0) ? args[0] : null);
		}
		
	}
}