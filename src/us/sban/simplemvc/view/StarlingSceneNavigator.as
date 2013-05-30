package us.sban.simplemvc.view
{
	import flash.geom.Rectangle;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public final class StarlingSceneNavigator extends StarlingScene
	{
		public function StarlingSceneNavigator()
		{
			super();
			var bg:Image = new Image( assetManager.getTexture("bg") );
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			addChild(bg);
			
			var rect:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, application.gameWidth, application.gameHeight), 
				new Rectangle(0, 0, application.stage.fullScreenWidth, application.stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL);
			x = rect.x;
			y = rect.y;
			
			replaceScene( new StarlingApplication.StartSceneClass );
			StarlingApplication.StartSceneClass=null;
		}
		
		/**index=1*/
		public var currentScene:Sprite;
		
		public function replaceScene(scene:Sprite):void{
			if(currentScene)
				currentScene.removeFromParent(true);
			this.addChild(scene);
			currentScene = scene;
		}
	}
}