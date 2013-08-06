package simplemvc.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class URLLoaderUtil
	{
		/**以UrlLoader加载文本内容
		 * callback(result)
		 * 当有错误产生时，result为null
		 * 
		 * @param format text or binary
		 * */
		public static function load(url:String,callback:Function,format:String="text"):void{
			var loader:URLLoader = new URLLoader();
			var req:URLRequest=new URLRequest(url);
			
			function onLoad(e:Event):void{
				e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				e.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				e.target.close();
				callback(e.target.data);
			}
			function onError(e:Event):void{
				e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				e.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				e.target.close();
				callback(null);
			}
			
			loader.dataFormat = format;
			loader.addEventListener(Event.COMPLETE,onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.load(req);
		}
		
		/**如果发生错误，尝试3次*/
		public static function load3times(url:String,callback:Function,format:String="text"):void{
			var times:int = 0;
		    function onResult(result:Object):void{
				if (!result){
					if (times++ < 3) 
						load(url,onResult,format);
					else
						callback(null);
				}else{
					callback(result);
				}
			};
			load(url,onResult,format);
		}
	}
}