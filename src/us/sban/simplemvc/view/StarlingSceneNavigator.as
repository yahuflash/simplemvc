package us.sban.simplemvc.view
{
	import flash.geom.Rectangle;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public final class StarlingSceneNavigator extends Sprite
	{
		public function StarlingSceneNavigator()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,
					function(e:Event):void{
						e.currentTarget.removeEventListener(e.type, arguments.callee);
						init();
					}
				);
		}
		
		public var currentScene:Sprite;
		protected function get application():StarlingApplication{
			return StarlingApplication.application;
		}
		
		protected function init():void{
			var rect:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, application.gameWidth, application.gameHeight), 
				new Rectangle(0, 0, application.stage.fullScreenWidth, application.stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL);
			this.x = rect.x;
			this.y = rect.y;
		}
		
		public function replaceScene(scene:Sprite):void{
			if(currentScene)
				currentScene.removeFromParent(true);
			this.addChild(scene);
			currentScene = scene;
		}
	}
}