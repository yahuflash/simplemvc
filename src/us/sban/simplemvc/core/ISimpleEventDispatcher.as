package us.sban.simplemvc.core
{
	import starling.events.Event;

	public interface ISimpleEventDispatcher extends ISimpleObject
	{
		function get eventHandlers():SimpleEventHandlers;
		function addEventListener(type:String,listener:Function):void;
		function removeEventListener(type:String, listener:Function):void;
		function removeEventListeners(type:String=null):void;
		function dispatchEvent(event:Event):void;
		function dispatchEventWith(type:String, bubbles:Boolean=false, data:Object=null):void;
		function hasEventListener(type:String):Boolean;
	}
}