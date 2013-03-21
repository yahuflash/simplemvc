package us.sban.simplemvc.view
{
	import starling.display.Sprite;

	public final class StarlingLoadingScene extends Sprite
	{
		public function StarlingLoadingScene()
		{
			super();
			this.touchable=false;
		}
		
		public function updateProgress(ratio:Number):void{
			trace(ratio);
		}
	}
}