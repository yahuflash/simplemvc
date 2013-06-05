package simplemvc.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import simplemvc.core.Promise;
	import simplemvc.event.SimpleEvent;
	
	public class LoadUtil
	{
		/**以UrlLoader加载文本内容*/
		public static function loadTextViaURLLoader(url:String):Promise{
			var promise:Promise = Promise.create();
			var loader:URLLoader = new URLLoader();
			var req:URLRequest=new URLRequest(url);
			
			function onLoad(e:Event):void{
				e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				e.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				e.target.close();
				promise.dispatchSimpleEvent( SimpleEvent.COMPLETE, e.target.data );
				promise.dispose();
			}
			function onError(e:Event):void{
				e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				e.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				e.target.close();
				promise.dispatchSimpleEvent( SimpleEvent.FAIL, e.type );
				promise.dispose();
			}
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE,onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.load(req);
			
			return promise;
		}
	}
}