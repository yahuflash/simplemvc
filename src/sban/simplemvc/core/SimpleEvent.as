package sban.simplemvc.core
{
	import flash.events.Event;
	
	/**
	 * 基于flash event的基本事件类
	 *  
	 * @author sban
	 * 
	 */	
	public final class SimpleEvent extends Event
	{
		public function SimpleEvent(type:String,args:Object=null)
		{
			super(type, false, false);
			this.Args = args;
		}
		
		/**
		 * 参数对象 
		 */		
		public var Args:Object;
		
		/**
		 * 在全局事件派发器上派发该事件 
		 * 
		 */		
		public function DispatchInGlobal():void {
			$.GED.dispatchEvent(this);
		}
	}
}