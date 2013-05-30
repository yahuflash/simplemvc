package simplemvc.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import simplemvc.core.Promise;
	import simplemvc.event.SimpleEvent;
	
	public final class HttpUtil
	{
		/**以http协议加载文本内容*/
		public static function loadText(url:String):Promise{
			var promise:Promise = Promise.create();
			var loader:URLLoader = new URLLoader();
			var req:URLRequest=new URLRequest(url);
			
			function onLoad(e:Event):void{
				e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				e.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				e.target.close();
				promise.dispatchSimpleEvent( SimpleEvent.COMPLETE, e.target.data );
			}
			function onError(e:Event):void{
				e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				e.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				e.target.close();
				promise.dispatchSimpleEvent( SimpleEvent.FAIL, e );
			}
			loader.addEventListener(Event.COMPLETE,onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.load(req);
			
			return promise;
		}
		
		public function HttpUtil()
		{
		}
	}
}