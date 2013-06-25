package simplemvc.event
{
	import simplemvc.common.IReusable;
	import simplemvc.common.ObjectPool;
	import simplemvc.common.simplemvc_internal;

	use namespace simplemvc_internal;
	
	public final class SimpleEvent implements IReusable{
		
		public static function create(type:String, args:Object=null):SimpleEvent{
			var e:SimpleEvent = ObjectPool.sharedObjectPool().retrieveNew(SimpleEvent) as SimpleEvent;
			e.type = type;
			e.args = args;
			return e;
		}
		
		public function SimpleEvent(){}
		
		public var args :Object;
		public var type:String;
		public var target:SimpleEventDispatcher;
		public var stopsPropagation:Boolean;
		
		public function stopPropagation():void { 
			stopsPropagation=true; 
		}
		
		public function release():void{
			target = null;
			args = null;
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
		
		public function dispatchInGlobal():void{
			SimpleEventDispatcher.sharedSimpleDispatcher().dispatch(this);
			release();
		}
		
		public function dispatchInModule(moduleName:String):void{
			DispatcherManager.sharedDispatcherManager().retrieveNew(moduleName)
				.dispatch(this);
			release();
		}
	}
}