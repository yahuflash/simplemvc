package simplemvc.event
{
	import simplemvc.core.IDisposable;
	import simplemvc.core.SimpleObjectPool;

	internal final class EventListener implements IDisposable
	{
		public static function create(type:String,listener:Function,capture:Boolean=false,priority:int=0):EventListener{
			var r:EventListener = SimpleObjectPool.sharedInstance().pull(EventListener) as EventListener;
			r.init(type, listener, capture, priority);
			return r;
		}
		
		public function EventListener(){}
		public var type:String;
		public var listener:Function;
		public var capture:Boolean=false;
		public var priority:int=0;
		
		public function init(type:String,listener:Function,capture:Boolean=false,priority:int=0):void{
			this.type=type;
			this.listener = listener;
			this.capture=capture;
			this.priority = priority;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			SimpleObjectPool.sharedInstance().push(this);
		}
	}
}