package us.sban.simplemvc.util
{
	import flash.system.Capabilities;

	public final class ScreenUtil
	{
		public static function getDPI():Number
		{
			var serverString:String = unescape(Capabilities.serverString); 
			var reportedDpi:Number = Number(serverString.split("&DP=", 2)[1]);
			return reportedDpi;
		}
		
		public static function getDPWide(fullScreenWidth:Number):Number
		{
			return fullScreenWidth * 160 / getDPI(); 
		}
		
		public static function getInchesWide(fullScreenWidth:Number):Number
		{
			return fullScreenWidth / getDPI(); 
		}
		
		public function ScreenUtil()
		{
		}
	}
}