package us.sban.simplemvc.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import starling.textures.Texture;

	public final class StarlingUtil
	{
		public static function textureFromDisplayObject(sprite : DisplayObject):Texture
		{
			var buffer:BitmapData = new BitmapData(sprite.width, sprite.height, true, 0x000000); // draw the shape on the bitmap
			buffer.draw(sprite);
			// create a Texture out of the BitmapData
			var texture:Texture = Texture.fromBitmapData(buffer);
			return texture;
		}
		
		public function StarlingUtil()
		{
		}
	}
}