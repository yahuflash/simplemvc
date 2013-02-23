package us.sban.simplemvc.core
{
	use namespace simplemvc_internal;
	
	public class SimpleColor extends SimpleObject
	{
		public static const WHITE:SimpleColor   = new SimpleColor(0xffffff);
		public static const SILVER:SimpleColor  = new SimpleColor(0xc0c0c0);
		public static const GRAY:SimpleColor    = new SimpleColor(0x808080);
		public static const BLACK:SimpleColor   = new SimpleColor(0x000000);
		public static const RED:SimpleColor     = new SimpleColor(0xff0000);
		public static const MAROON:SimpleColor  = new SimpleColor(0x800000);
		public static const YELLOW:SimpleColor  = new SimpleColor(0xffff00);
		public static const OLIVE:SimpleColor   = new SimpleColor(0x808000);
		public static const LIME:SimpleColor    = new SimpleColor(0x00ff00);
		public static const GREEN:SimpleColor   = new SimpleColor(0x008000);
		public static const AQUA:SimpleColor    = new SimpleColor(0x00ffff);
		public static const TEAL:SimpleColor    = new SimpleColor(0x008080);
		public static const BLUE:SimpleColor    = new SimpleColor(0x0000ff);
		public static const NAVY:SimpleColor    = new SimpleColor(0x000080);
		public static const FUCHSIA:SimpleColor = new SimpleColor(0xff00ff);
		public static const PURPLE:SimpleColor  = new SimpleColor(0x800080);
		
		public function SimpleColor(color:int=-1){if(color>-1) setValue(color);}
		
		private var _color:uint;
		private var _a:uint;
		private var _r:uint;
		private var _g:uint;
		private var _b:uint;
		
		simplemvc_internal function setValue(value:uint):SimpleColor {
			_color = value;
			_a = (value >> 24) 	& 0xff;
			_r = (value >> 16) 	& 0xff;
			_g = (value >> 8) 	& 0xff;
			_b = value 			& 0xff;
			return this;
		}
		
		public function toString():String{ return "0x"+_color.toString(16); };
		public function valueOf():uint{ return _color; };
		public function print():SimpleColor{
			trace(this.toString());
			return this;
		}
		
		public function get a():uint { return _a; };
		public function get r():uint { return _r; };
		public function get g():uint { return _g; };
		public function get b():uint { return _b; };
		
	}
}