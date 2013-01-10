package sban.simplemvc.util
{
	import flash.geom.Rectangle;

	public final class MathUtil
	{
		/**
		 * 返回等比缩放的最大居中区域 
		 * @param deviceSize
		 * @param guiSize
		 * @return 
		 * 
		 */		
		public static function getAppSize(deviceSize:Rectangle,guiSize:Rectangle):Rectangle
		{
			var appScale:Number = 1;
			var appSize:Rectangle = guiSize.clone();
			// if device is wider than GUI's aspect ratio, height determines scale
			if ((deviceSize.width/deviceSize.height) > (guiSize.width/guiSize.height)) {
				appScale = deviceSize.height / guiSize.height;
				appSize.width = deviceSize.width / appScale;
				appSize.x = Math.round((appSize.width - guiSize.width) / 2);
			} 
				// if device is taller than GUI's aspect ratio, width determines scale
			else {
				appScale = deviceSize.width / guiSize.width;
				appSize.height = deviceSize.height / appScale;
				appSize.y = Math.round((appSize.height - guiSize.height) / 2);;
			}
			return appSize;
		}
		
		public function MathUtil()
		{
		}
	}
}