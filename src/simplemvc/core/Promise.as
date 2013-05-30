package simplemvc.core
{
	import simplemvc.event.SimpleEvent;
	import simplemvc.event.SimpleEventDispatcher;
	
	/**
	 * 以此实现promise编程，action(x).done(y).fail(z); 
	 * @author sban
	 * 
	 */	
	public final class Promise extends SimpleEventDispatcher implements IReusable
	{
		public static function create():Promise{
			return SimpleObjectPool.sharedInstance().pull(Promise) as Promise;
		}
		public function Promise(){}
		
		public function complete(clourse:Function):Promise
		{
			// TODO Auto Generated method stub
			function onComplete(e:SimpleEvent):void{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				clourse.apply(null, e.args);
			}
			addEventListener(SimpleEvent.COMPLETE, onComplete);
			return this;
		}
		
		public function fail(clourse:Function):Promise
		{
			// TODO Auto Generated method stub
			function onFail(e:SimpleEvent):void{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				clourse.apply(null, e.args);
			}
			addEventListener(SimpleEvent.FAIL, onFail);
			return this;
		}
	}
}