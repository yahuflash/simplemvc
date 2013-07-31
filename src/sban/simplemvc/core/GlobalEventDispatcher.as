package sban.simplemvc.core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 全局事件派发器
	 *  
	 * @author sban
	 * 
	 */	
	public final class GlobalEventDispatcher extends EventDispatcher
	{
		private static var instance:GlobalEventDispatcher;
		public static function SharedInstance():GlobalEventDispatcher{
			return (instance ||= new GlobalEventDispatcher);
		}
		
		public function GlobalEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * 以参数派发事件，对dispatchEvent API的封装
		 *  
		 * @param type
		 * @param args
		 * 
		 */		
		public function DispatchEventWith(type:String, args:Object=null):void {
			this.dispatchEvent( new SimpleEvent(type, args) );
		}
	}
}