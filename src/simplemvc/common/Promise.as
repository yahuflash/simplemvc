package simplemvc.common
{
	import simplemvc.event.SimpleDispatcher;
	
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
		
	}
}