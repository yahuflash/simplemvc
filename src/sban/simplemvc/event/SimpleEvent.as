package sban.simplemvc.event
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import sban.simplemvc.core.simplemvc_internal;
	
	/**
	 * 使用SimpleEvent作为应用中唯一的事件类
	 * 
	 * 在匿名函数内部移除事件监听的简易语句：
	 * <pre>
	 * e.currentTarget.removeEventListener(e.type, arguments.callee); 
	 * </pre>
	 * @author sban
	 * 
	 */	
	public class SimpleEvent extends Event
	{
		/**
		 * 在Socket收到数据时派发
		 * args:{mid:int, bytes:ByteArray} 
		 */		
		public static const SOCKET_DATA :String = "socketData";
		/**
		 * 在（AMF）连接后派发
		 */		
		public static const CONNECT :String = "connect";
		/**
		 *在操作完成后派发 
		 */		
		public static const COMPLETE :String = "complete";
		
		public static const CHANGE :String = "Change";
		
		public function SimpleEvent(type:String, data :Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data ? data : {};
		}
		
		public var data :Object;
		
		public function dispatch(target :IEventDispatcher):void
		{
			target.dispatchEvent(this);
		}
		
		public function globalDispatch():void
		{
			this.dispatch(SimpleEventDispatcher.simplemvc_internal::globalEventDispatcher);
		}
	}
}