package simplemvc.event
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import simplemvc.core.IDisposable;
	
	public final class SimpleEvent extends Event implements IDisposable
	{
		public static const DISPOSE:String = "dispose";
		public static const COMPLETE:String = "complete";
		public static const FAIL:String = "fail";
		
		public static function create(type:String, ...args):SimpleEvent{
			var r:SimpleEvent = new SimpleEvent(type);
			r.args=args;
			return r;
		}
		
		public function SimpleEvent(type:String, ...args)
		{
			super(type);
			this.args =args;
		}
		
		public var args:Array;
		
		public function dispatch(target:IEventDispatcher=null):void{
			(target ||= GlobalEventDispatcher.sharedInstance()).dispatchEvent(this);
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}