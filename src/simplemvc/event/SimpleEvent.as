package simplemvc.event
{
	import simplemvc.common.IReusable;
	import simplemvc.common.ObjectPool;
	import simplemvc.common.simplemvc_internal;

	use namespace simplemvc_internal;
	
	public final class SimpleEvent implements IReusable{
		
		public static function create(type:String, args:Object=null):SimpleEvent{
			return ObjectPool.sharedObjectPool().retrieveNew(SimpleEvent).init(type,args);
		}
		
		public function SimpleEvent(){}
		
		public var args :Object;
		internal var target:SimpleDispatcher;
		protected var type:String;
		protected var stopsPropagation:Boolean;
		
		public function init(type:String,args:Object=null):SimpleEvent{
			this.type=type;
			this.args = args;
			return this;
		}
		
		public function getType():String{ return type;}
		public function getTarget():SimpleDispatcher { return target; }
		public function hasStoppedPropagation():Boolean { return stopsPropagation; }
		
		public function stopPropagation():void { 
			stopsPropagation=true; 
		}
		
		public function release():void{
			target = null;
			args = null;
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
		
		public function dispatchInGlobal():void{
			SimpleDispatcher.sharedSimpleDispatcher().dispatch(this);
			release();
		}
		
		public function dispatchInModule(moduleName:String):void{
			DispatcherManager.sharedDispatcherManager().retrieveNew(moduleName)
				.dispatch(this);
			release();
		}
	}
}