package us.sban.simplemvc.util
{
	public final class ColorUtil
	{
		/** Returns the alpha part of an ARGB color (0 - 255). */
		public static function getAlpha(color:uint):Number { return (color >> 24) & 0xff; }
		
		/** Returns the red part of an (A)RGB color (0 - 255). */
		public static function getRed(color:uint):Number   { return (color >> 16) & 0xff; }
		
		/** Returns the green part of an (A)RGB color (0 - 255). */
		public static function getGreen(color:uint):Number { return (color >>  8) & 0xff; }
		
		/** Returns the blue part of an (A)RGB color (0 - 255). */
		public static function getBlue(color:uint):Number  { return  color        & 0xff; }
		
		/** Creates an RGB color, stored in an unsigned integer. Channels are expected
		 *  in the range 0 - 255. */
		public static function rgb(red:Number, green:Number, blue:Number):uint
		{
			return (red << 16) | (green << 8) | blue;
		}
		/** Creates an ARGB color, stored in an unsigned integer. Channels are expected
		 *  in the range 0 - 255. */
		public static function argb(alpha:Number, red:Number, green:Number, blue:Number):uint
		{
			return (alpha << 24) | (red << 16) | (green << 8) | blue;
		}
		
		public function ColorUtil()
		{
		}
	}
}