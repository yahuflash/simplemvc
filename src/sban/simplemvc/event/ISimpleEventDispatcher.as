package sban.simplemvc.event
{
	import flash.events.IEventDispatcher;
	
	import sban.simplemvc.core.IDisposable;
	
	public interface ISimpleEventDispatcher extends IEventDispatcher, IDisposable
	{
		function removeAllEventListeners(type:String = null, listener:Function = null):Boolean;
		function addEventListeners(target:IEventDispatcher, eventListeners:Array, useCapture:Boolean=false,priority:int=0, useWeakReference:Boolean=true):void;
	}
}