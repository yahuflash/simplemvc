package us.sban.simplemvc.view
{
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public final class StarlingLoadingScene extends StarlingScene
	{
		public function StarlingLoadingScene()
		{
			super();
			this.touchable=false;
			// TODO Auto Generated method stub
			var bg:Image = new Image( Texture.fromBitmap( application.getBackgroundBitmap() ) );
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			addChild(bg);
			StarlingApplication.Background = null;
			StarlingApplication.BackgroundHD = null; // no longer needed!
			
			// The AssetManager contains all the raw asset data, but has not created the textures
			// yet. This takes some time (the assets might be loaded from disk or even via the
			// network), during which we display a progress indicator. 
			
			var mLoadingProgress:StarlingProgressBar = new StarlingProgressBar(175, 20);
			mLoadingProgress.x = (application.gameWidth  - mLoadingProgress.width) / 2;
			mLoadingProgress.y = (application.gameHeight - mLoadingProgress.height) / 2;
//			mLoadingProgress.y = application.gameHeight * 0.5;
			addChild(mLoadingProgress);
			
			assetManager.loadQueue(function(ratio:Number):void
			{
				mLoadingProgress.ratio = ratio;
				
				// a progress bar should always show the 100% for a while,
				// so we show the main menu only after a short delay. 
				
				if (ratio == 1){
					Starling.juggler.delayCall(application.showSceneNavigator, 0.15);
				}
			});
		}
		
	}
}