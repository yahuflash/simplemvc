package sban.simplemvc.event
{
	import flash.events.Event;
	
	/**
	 * 与flash使用同源的事件对象，使其可以在flash与simplemvc中穿行成为可能 
	 * @author sban
	 * 
	 */	
	public final class SimpleEvent extends Event
	{
		public function SimpleEvent(type:String, ...args)
		{
			super(type);
			this.Args = args;
		}
		
		public var Args:Array;
		private var stopedPropagation:Boolean = false;
		
		/**是否已停止事件流的继续派发*/
		public function StopedPropagation():Boolean {
			return stopedPropagation;
		}
		/**停止事件流的继续派发*/
		public function StopPropagation():void {
			stopedPropagation = true;
			super.stopPropagation();
			super.stopImmediatePropagation();
		}
		
		override public function stopImmediatePropagation():void
		{
			// TODO Auto Generated method stub
			stopedPropagation = true;
			super.stopImmediatePropagation();
		}
		
		override public function stopPropagation():void
		{
			// TODO Auto Generated method stub
			stopedPropagation = true;
			super.stopPropagation();
		}
		
	}
}