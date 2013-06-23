package simplemvc.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import simplemvc.common.AsyncDataObject;
	import simplemvc.common.ErrorObject;
	
	public class URLLoaderUtil
	{
		/**以UrlLoader加载文本内容
		 * callback(AsyncDataObject)
		 * 
		 * @param format text or binary
		 * */
		public static function load(url:String,callback:Function,format:String="text"):void{
			var loader:URLLoader = new URLLoader();
			var req:URLRequest=new URLRequest(url);
			var r:AsyncDataObject = AsyncDataObject.create();
			
			function onLoad(e:Event):void{
				e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				e.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				e.target.close();
				r.result=e.target.data;
				r.status=1;
				callback(r);
			}
			function onError(e:Event):void{
				e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				e.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				e.target.close();
				r.error = ErrorObject.create().setMessage(e.type);
				r.status=-1;
				callback(r);
			}
			
			loader.dataFormat = format;
			loader.addEventListener(Event.COMPLETE,onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.load(req);
		}
	}
}