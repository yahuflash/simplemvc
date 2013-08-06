package simplemvc.event
{
	/**
	 * 事件派发器接口
	 * 
	 * 事件监听与派发，使用观察者模式实现。在SimpleMVC中，是最底层的通信机制实现。
	 * 在其上，是封装了通信逻辑的Action。Action之上，是通信文本定义（字符串）。
	 * 
	 * fixed on 2010/06/21 
	 * @author sban
	 * 
	 */
	public interface ISimpleEventDispatcher{
		/**添加事件监听*/
		function addEventListener(type:String, listener:Function, priority:int=0):void;
		/**批量添加事件监听*/
		function addEventListenersTo(types:Array, listener:Function):void;
		/**派发事件*/
		function dispatchEvent(event:SimpleEvent):void;
		/**派发SimpleEvent事件，使用了对象池，优先使用*/
		function dispatchEventWith(type:String, args:Object=null):void;
		/**是否监听了指定事件*/
		function hasListenedTo(type:String):Boolean;
		/**移除事件监听*/
		function removeEventListener(type:String, listener:Function):void;
		/**清除事件监听，一般在release或dispose中用到*/
		function removeEventListeners():void;
		/**清除指定事件类型的所有监听*/
		function removeEventListenersOf(type:String=null):void;
		/**移除以指定字符串开始的事件监听，一般用于移除某个模块的监听*/
		function removeEventListenersStartWith(eventPrefix:String):void;
		/**是否已派发过指定事件*/
		function hasDispatchedEvent(type:String):Boolean;
	}
}