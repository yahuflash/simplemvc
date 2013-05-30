package us.sban.simplemvc.util
{
	/**
	 *关于int,uint,number的工具类方法
	 *  
	 * @author sban
	 * 
	 */	
	public final class NumberUtil
	{
		/**
		 * 浮点数化整 
		 * @param n
		 * @return 
		 * 
		 */		
		public static function floor(n:Number):Number
		{
			return n >> 0;
		}
		
		/**
		 * 取模 
		 * @param n
		 * @param m
		 * @return 
		 * 
		 */		
		public static function mod(n:Number,m:Number):Number
		{
			if( (n&1)==0 )
				return n & (m-1);
			return n % m;
		}
		
		/**
		 *是否为偶数 
		 * @param n
		 * @return 
		 * 
		 */		
		public static function isEven(n:Number):Boolean
		{
			return (n&1) == 0;
		}
		
		/**
		 * 取绝对值 
		 * @param x
		 * @return 
		 * 
		 */		
		public static function abs(x:Number):Number
		{
			return (x^(x>>31)) - (x>>31);
		}
				
		
		public function NumberUtil()
		{
		}
	}
}