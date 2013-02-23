package us.sban.simplemvc.core
{
	public interface ISimpleEventDispatcher extends ISimpleObject
	{
		function get eventHandlers():SimpleEventHandlers;
		function addSimpleEventListener(type:String, listener:Function,priority:int=0):void;
		function removeSimpleEventListener(type:String, listener:Function):void;
		function removeSimpleEventListeners(type:String=null):void;
		function dispatchSimpleEvent(event:SimpleEvent):void;
		function dispatchSimpleEventWith(type:String, ...args):void;
		function hasSimpleEventListener(type:String):Boolean;
	}
}