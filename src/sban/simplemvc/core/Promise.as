package sban.simplemvc.core
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import sban.simplemvc.event.SimpleEventDispatcher;
	
	use namespace flash_proxy;
	
	public dynamic final class Promise extends Proxy
	{
		public function Promise()
		{
			super();
		}
		
		private var dispacher:SimpleEventDispatcher = new SimpleEventDispatcher();
		private var eventDispatchedMap:Dictionary = new Dictionary();
		
		flash_proxy override function getProperty(name:*):*{
			name = name.localName;
			return eventDispatchedMap[name];
		}
		
		/**xxx.complete = null
		 * xxx.complete = listener
		 * */
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
				eventDispatchedMap[name] = args;
				dispacher.DispatchEventWithTypeAndArgs(name, args);
			}
			return this;
		}
		
	}
}