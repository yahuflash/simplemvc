package us.sban.simplemvc.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import starling.textures.Texture;

	public final class StarlingUtil
	{
		/**
		 * convert displayObject to starling texture 
		 * @param sprite
		 * @return 
		 * 
		 */		
		public static function textureFromDisplayObject(sprite : DisplayObject):Texture
		{
			var bd:BitmapData = DisplayUtil.convertDisplayObjectToBitmap(sprite);
			// create a Texture out of the BitmapData
			var texture:Texture = Texture.fromBitmapData(bd);
			return texture;
		}
		
		public function StarlingUtil()
		{
		}
	}
}