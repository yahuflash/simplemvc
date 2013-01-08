package sban.simplemvc.control
{
	import feathers.skins.IFeathersTheme;
	
	import sban.simplemvc.core.StarlingApplication;
	import sban.simplemvc.manager.StarlingAssetsManager;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class StarlingNavigatorControl extends StarlingViewControl
	{
		public function StarlingNavigatorControl()
		{
			super();
		}
		
		public var currentScreen :Sprite;
		public var bg :Image;
		protected var theme:IFeathersTheme;
		
		override public function initialize():void
		{
			StarlingApplication.application.navigator=this;
			
			StarlingAssetsManager.single.initialize();
			//By default, the Feathers components don't have skins.
			this.theme = new application.Theme_Class(Starling.current.stage);
			
			var bgTexture :Texture = StarlingAssetsManager.single.getTexture("bg");
			if(bgTexture)
			{
				bg = new Image(bgTexture);
				this.addChild(bg);
			}
			this.application.browser("default");
			
		}
		
		public function changeScreen(screen :Sprite):void
		{
			if(currentScreen)
			{
				this.removeChild(currentScreen, true);
			}
			
			this.addChild(screen);
			this.currentScreen = screen;
		}
	}
}