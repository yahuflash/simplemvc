package us.sban.simplemvc.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import us.sban.simplemvc.controller.SimpleApplicationController;
	import us.sban.simplemvc.core.ISimpleApplication;
	import us.sban.simplemvc.core.ISimpleEventDispatcher;
	import us.sban.simplemvc.core.ISimpleObject;
	import us.sban.simplemvc.core.SimpleApplication;
	import us.sban.simplemvc.core.SimpleEvent;
	import us.sban.simplemvc.core.SimpleEventHandlers;
	import us.sban.simplemvc.core.simplemvc_internal;
	import us.sban.simplemvc.model.SimpleModel;
	import us.sban.simplemvc.service.SimpleService;
	
	use namespace simplemvc_internal;
	
	[SWF(backgroundColor="#333333")]
	public final class SimpleApplicationView extends Sprite implements ISimpleView
	{
		public function SimpleApplicationView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,
				function(e:Event):void{
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					init();
				}
			);
		}
		
		protected function get application():ISimpleApplication{return SimpleApplication.application;};
		private var _eventDispatchr :ISimpleEventDispatcher = $.eventDispatcher();
		
		protected function init():void{
			initApplication();
		}
		
		protected function initApplication():void{
			application.init(new SimpleModel, this, new SimpleApplicationController, new SimpleService);
			application.c.takeOn();
		}
		
		public function release():ISimpleObject
		{
			return this;
		}
		
		public function addSimpleEventListener(type:String, listener:Function, priority:int=0):void
		{
			// TODO Auto Generated method stub
			_eventDispatchr.addSimpleEventListener(type,listener,priority);
		}
		
		public function dispatchSimpleEvent(event:SimpleEvent):void
		{
			// TODO Auto Generated method stub
			_eventDispatchr.dispatchSimpleEvent(event);
		}
		
		public function dispatchSimpleEventWith(type:String, ...args):void
		{
			// TODO Auto Generated method stub
			_eventDispatchr.dispatchSimpleEventWith.apply(_eventDispatchr, [type].concat(args));
		}
		
		public function get eventHandlers():SimpleEventHandlers
		{
			// TODO Auto Generated method stub
			return _eventDispatchr.eventHandlers;
		}
		
		public function hasSimpleEventListener(type:String):Boolean
		{
			// TODO Auto Generated method stub
			return _eventDispatchr.hasSimpleEventListener(type);
		}
		
		public function removeSimpleEventListener(type:String, listener:Function):void
		{
			// TODO Auto Generated method stub
			_eventDispatchr.removeSimpleEventListener(type,listener);
		}
		
		public function removeSimpleEventListeners(type:String=null):void
		{
			// TODO Auto Generated method stub
			_eventDispatchr.removeSimpleEventListeners(type);
		}
		
		public function get ui():Object
		{
			// TODO Auto Generated method stub
			return this;
		}
		
		
	}
}