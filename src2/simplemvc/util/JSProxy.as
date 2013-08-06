package simplemvc.util
{
	import flash.external.ExternalInterface;

	/**
	 * 代理对js方法的调用与回调注册 
	 * @author sban
	 * fixed 2010/06/23
	 */	
	public class JSProxy
	{
		public static function addCallback(funName:String,closure:Function):void{
			if(ExternalInterface.available){
				ExternalInterface.addCallback(funName,closure);
			}
		}
		public static function call(jsFunName:String,...args):void{
			if(ExternalInterface.available){
				args.unshift(jsFunName);
				ExternalInterface.call.apply(ExternalInterface,args);
			}
		}
		
		public function JSProxy()
		{
		}
	}
}