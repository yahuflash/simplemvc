package simplemvc.manager
{
	import flash.text.engine.TextBaseline;
	
	import simplemvc.util.URLLoaderUtil;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * 加载一个key=value配置文件,并把配置信息写入settings，完成之后派发complete事件 
	 * @author sban
	 * 
	 */	
	public final class SettingManager extends EventDispatcher
	{
		private static var instance:SettingManager;
		public static function getInstance():SettingManager{
			return (instance ||= new SettingManager);
		}
		public function SettingManager()
		{
			super();
		}
		
		public var settings:Object = {};
		
		public function load(initFilePath:String):SettingManager{
			URLLoaderUtil.load3times(initFilePath,load_onResult,"text");
			return this;
		}
		
		protected function load_onResult(result:String):void{
			var reg:RegExp = /\r\n|\n|\r/;
			var dateArray:Array=result.split(reg);
			for(var i:uint=0;i<dateArray.length;i++){
				var str:String=dateArray[i];
				var index:uint=dateArray[i].indexOf("=");
				var key:String = str.substring(0,index);
				var value:String = str.substring(index+1,str.length);
				settings[key]=value;
			}
			dispatchEventWith(Event.COMPLETE);
		}
		
		public function toString():String{
			var r:String = "";
			for (var key:String in settings){
				r += key+"="+settings[key];
				r += "\n";
			}
			return r;
		}
	}
}