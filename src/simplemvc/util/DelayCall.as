package simplemvc.util
{
	import com.greensock.TweenLite;

	public final class DelayCall
	{
		/**
		 * 延时执行方法
		 */
		public static function add(method:Function,params:Array=null):void{
			TweenLite.delayedCall(1,method,params,true);
		}
		
		public function DelayCall()
		{
		}
	}
}