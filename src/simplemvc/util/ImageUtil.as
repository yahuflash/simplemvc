package simplemvc.util
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**图像工具类方法*/
	public final class ImageUtil
	{
		public static function encodeAsPng(img:BitmapData):ByteArray{
			return PNGEncoder.encode(img);
		}
		public static function encodeAsJpg(img:BitmapData,quality:Number=80):ByteArray{
			return new JPGEncoder(quality).encode(img);
		}
		
		public function ImageUtil()
		{
		}
	}
}