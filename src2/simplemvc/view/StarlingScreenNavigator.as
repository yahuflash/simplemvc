package simplemvc.view
{
	import feathers.themes.AeonDesktopTheme;
	
	import simplemvc.common.simplemvc_internal;
	
	import starling.core.Starling;
	import starling.display.Image;
	
	use namespace simplemvc_internal;
	
	public class StarlingScreenNavigator extends StarlingScreen implements IScreenNavigator
	{
		public function StarlingScreenNavigator(){}
		
		/**
		 * A Feathers theme will automatically pass skins to any components that
		 * are added to the stage. Components do not have default skins, so you
		 * must always use a theme or skin the components manually.
		 *
		 * @see http://wiki.starling-framework.org/feathers/themes
		 */
		protected var theme:Object;
		protected var screens:Vector.<StarlingScreen> = new Vector.<StarlingScreen>();
		
		public function pushScreen(screen:StarlingScreen):void{
			if (screens.length > 0){
				screens[screens.length-1].slideToLeft();
			}
			screens.push(screen);
			addChild(screen);
			screen.slideFromRight();
		}
		
		public function replaceScreen(screen:StarlingScreen):void{
			if (screens.length > 0){
				removeChild( screens.pop() );
			}
			addChild(screen);
		}
		
		public function popupScreen():void{
			if (screens.length > 0){
				var screen:StarlingScreen = screens.pop();
				screen.slideToRight();
				if (screens.length > 0){
					screens[screens.length-1].slideFromLeft();
				}
			}
		}
		
		override protected function init():void
		{
			super.init();
			StarlingApplication._navigator = this;
			
			//create the theme. this class will automatically pass skins to any
			//Feathers component that is added to the stage. you should always
			//create a theme immediately when your app starts up to ensure that
			//all components are properly skinned.
			this.theme = new feathers.themes.AeonDesktopTheme(stage);
			
			// we create the game with a fixed stage size -- only the viewPort is variable.
			stage.stageWidth  = AppSetting.STAGE_WIDTH;
			stage.stageHeight = AppSetting.STAGE_HEIGHT;
			
			// the contentScaleFactor is calculated from stage size and viewport size
			Assets.contentScaleFactor = Starling.current.contentScaleFactor;
			
			// prepare assets
			Assets.prepareSounds();
			Assets.loadBitmapFonts();
			
			// add some content
			mBackground = new Image(Assets.getTexture("Background"));
			addChild(mBackground);
			
			var c:Class = AppSetting.DefaultScreenClass;
			pushScreen( new c );
		}
	}
}