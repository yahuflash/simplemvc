package simplemvc.util
{
	import com.adobe.crypto.HMAC;
	import com.adobe.crypto.MD5;
	
	import flash.utils.ByteArray;

	/**加密工具类
	 * */
	public final class CryptoUtil
	{
		public static function md5(s:String):String{
			return MD5.hash(s);
		}
		/**加密字节为md5字符串*/
		public static function md5Bytes(s:ByteArray):String{
			return MD5.hashBinary(s);
		}
		
		/**使用密钥hmac加密*/
		public static function hmac(key:String,s:String):String{
			return HMAC.hash(key,s);
		}
		public static function hmacBytes(key:ByteArray,s:ByteArray):String{
			return HMAC.hashBytes(key,s);
		}
		
		public function CryptoUtil()
		{
		}
	}
}