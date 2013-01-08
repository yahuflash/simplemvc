package sban.simplemvc.control
{
	
	import sban.simplemvc.core.Promise;
	import sban.simplemvc.core.StarlingApplication;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StarlingViewControl extends Sprite implements IControl
	{
		public function StarlingViewControl(name :String = null)
		{
			super();
			this.name = name;
			this.addEventListener(Event.ADDED_TO_STAGE,
					function(e:Event):void
					{
						e.currentTarget.removeEventListener(e.type, arguments.callee);
						initialize();
					}
				);
		}
		
		public function get view():Object
		{
			// TODO Auto Generated method stub
			return this;
		}
		
		protected function get application():StarlingApplication
		{
			return StarlingApplication.application;
		}
		
		public function initialize():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function navigateTo(location:String):Promise
		{
			// TODO Auto Generated method stub
			return application.browser(location);
		}
		
		
	}
}