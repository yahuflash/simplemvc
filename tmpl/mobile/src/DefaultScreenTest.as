package
{
	import simplemvc.view.StarlingApplication;
	import simplemvc.view.StarlingScreen;
	
	import starling.display.Image;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public final class DefaultScreenTest extends StarlingScreen
	{
		public function DefaultScreenTest(){}
		
		override protected function init():void
		{
			// TODO Auto Generated method stub
			super.init();
			
			var mLogo:Image = new Image(Assets.getAtlasTexture("logo"));
			mLogo.addEventListener(TouchEvent.TOUCH, onLogoTouched);
			mLogo.x = int((AppSetting.STAGE_WIDTH  - mLogo.width)  / 2);
			mLogo.y = int((AppSetting.STAGE_HEIGHT - mLogo.height) / 2);
			addChild(mLogo);
		}
		
		private function onLogoTouched(event:TouchEvent):void
		{
			if (event.getTouch(event.currentTarget as Image, TouchPhase.BEGAN)){
				Assets.getSound("Click").play();
				StarlingApplication.navigator.pushScreen( new FirstScreenTest );
			}
		}
	}
}