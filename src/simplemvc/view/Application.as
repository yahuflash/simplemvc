package simplemvc.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.getTimer;
	
	import simplemvc.common.AsyncDataObject;
	import simplemvc.common.Director;
	import simplemvc.common.IApplication;
	import simplemvc.common.simplemvc_internal;
	import simplemvc.module.IModule;
	import simplemvc.module.ModuleFactory;
	import simplemvc.parser.ApplicationXMLData;
	import simplemvc.parser.ModuleXMLData;
	import simplemvc.util.URLLoaderUtil;
	
	use namespace simplemvc_internal;
	
	public class Application extends Sprite implements IApplication{
		public function Application()
		{
			Security.allowDomain("*");
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private var appXMLData:ApplicationXMLData = new ApplicationXMLData();
		private var modules:Vector.<IModule> = new Vector.<IModule>();
		private var currentTime:Number;
		
		public function startApplication():void{
			
		}
		
		protected function init(e:Event=null):void{
			if (e) e.currentTarget.removeEventListener(e.type, arguments.callee);
			this.loaderInfo.addEventListener("uncaughtError",uncaughtErrorHandler);
			
			Director.sharedDirector().playing=true;
			currentTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, eventHandler);
			
			URLLoaderUtil.load("app.xml",function(data:AsyncDataObject):void{
//				trace("data.status",data.status);
				if (data.status){
//					trace("...");
					//parseAppXMLData(XML(data.result));
				}
			});
		}
		
		private function parseAppXMLData(data:XML):void{
			appXMLData.parse(data);
			parformAppSettings();
		}
		private function parformAppSettings():void{
			for each(var moduleData:ModuleXMLData in appXMLData.moduleDatas){
				var module:IModule = ModuleFactory.createModule( moduleData );
				modules.push( module );
			}
			startApplication();
		}
		
		protected function eventHandler(event:Event):void{
			switch(event.type)
			{
				case Event.ENTER_FRAME:
				{
					var newTime:Number = getTimer();
					var delta:Number = newTime-currentTime;
					currentTime = newTime;
					Director.sharedDirector().update(delta);
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		protected function uncaughtErrorHandler(e:Event):void{
			e.preventDefault();
			e.stopImmediatePropagation();
			//LogUtil.warn(this, "uncaught error:"+e.type);
			
		}
	}
}