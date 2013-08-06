package
{
    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import starling.core.Starling;
    
	[SWF(frameRate="60", backgroundColor="#fff")]
    public class Scaffold_Android extends Sprite
    {
        private var mStarling:Starling;
        
        public function Scaffold_Android()
        {
            // set general properties
            
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            Starling.multitouchEnabled = true;  // useful on mobile devices
            Starling.handleLostContext = true;  // required on Android
            
            // create a suitable viewport for the screen size
            
            var screenWidth:int  = stage.fullScreenWidth;
            var screenHeight:int = stage.fullScreenHeight;
            var viewPort:Rectangle = new Rectangle();
            
            if (screenHeight / screenWidth < AppSetting.ASPECT_RATIO)
            {
                viewPort.height = screenHeight;
                viewPort.width  = int(viewPort.height / AppSetting.ASPECT_RATIO);
                viewPort.x = int((screenWidth - viewPort.width) / 2);
            }
            else
            {
                viewPort.width = screenWidth; 
                viewPort.height = int(viewPort.width * AppSetting.ASPECT_RATIO);
                viewPort.y = int((screenHeight - viewPort.height) / 2);
            }
            
            // Set up Starling
            
            mStarling = new Starling(AppSetting.StartUpClass, stage, viewPort);
            mStarling.start();
            
            // When the game becomes inactive, we pause Starling; otherwise, the enter frame event
            // would report a very long 'passedTime' when the app is reactivated. 
            
            NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, 
                function (e:Event):void { mStarling.start(); });
            
            NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, 
                function (e:Event):void { mStarling.stop(); });
			
			loaderInfo.addEventListener("uncaughtError",uncaughtErrorHandler);
        }
		
		protected function uncaughtErrorHandler(e:Event):void{
			e.preventDefault();
			e.stopImmediatePropagation();
			//LogUtil.warn(this, "uncaught error:"+e.type);
		}
    }
}