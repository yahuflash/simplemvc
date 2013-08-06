package simplemvc.event
{
	import simplemvc.common.IReusable;
	import simplemvc.common.ObjectPool;

	/**
	 * 该类用于在派发器中对事件句柄进行优先级排序 
	 * @author sban
	 * 
	 */	
	public final class PriorityHandler implements IReusable
	{
		public static function create(func:Function,priority:int=0):PriorityHandler{
			var r:PriorityHandler = ObjectPool.sharedObjectPool().retrieveNew(PriorityHandler) as PriorityHandler;
			r.func = func;
			r.priority=priority;
			return r;
		}
		
		public var priority:int=0;
		public var func:Function;
		
		public function release():void{
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
	}
}