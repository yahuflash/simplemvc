package sban.simplemvc.core
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import sban.simplemvc.event.SimpleEventDispatcher;
	import sban.simplemvc.interfaces.IDisposable;
	
	use namespace flash_proxy;
	
	public dynamic final class Promise extends Proxy implements IDisposable
	{
		public function Promise()
		{
			super();
		}
		
		private var dispacher:SimpleEventDispatcher = new SimpleEventDispatcher();
		private var eventDispatchedMap:Dictionary = null;
		
		flash_proxy override function getProperty(name:*):*{
			var map:Dictionary = (eventDispatchedMap ||= new Dictionary);
			name = name.localName;
			return map[name];
		}
		
		flash_proxy override function setProperty(name:*, value:*):void{
			name = name.localName;
			if (value == null){
				dispacher.RemoveEventListenerWithType(name);
			}else if (value is Function){
				dispacher.AddEventListener(name, value);
			}
		}
		
		flash_proxy override function callProperty(name:*, ...args):*{
			name = name.localName;
			var arg :* = (args.length > 0) ? args[0] : null;
			if (arg && (arg is Function)){
				dispacher.AddEventListener(name, arg);
			}else{
				var map:Dictionary = (eventDispatchedMap ||= new Dictionary);
				map[name] = args;
				dispacher.DispatchEventWithTypeAndArgs(name, args);
			}
			return this;
		}
		
		public function Dispose():void
		{
			// TODO Auto Generated method stub
			dispacher.Dispose();
			eventDispatchedMap = null;
		}
		
		
	}
}