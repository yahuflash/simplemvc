package simplemvc.util
{
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;

	/**日志记录工具类*/
	public final class LogUtil
	{
		public static function enable(target:ILogTarget=null):void{
			if(!target) target = new TraceTarget;
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
		}
		public static function disable():void{
			LOGGER_FACTORY.setup =null;
		}
		
		public static function debug(target:Object,formMessage:String,...parms):void{
			getLogger(target).debug(formMessage,parms);
		}
		public static function info(target:Object,formMessage:String,...parms):void{
			getLogger(target).info(formMessage,parms);
		}
		public static function warn(target:Object,formMessage:String,...parms):void{
			getLogger(target).warn(formMessage,parms);
		}
		public static function error(target:Object,formMessage:String,...parms):void{
			getLogger(target).error(formMessage,parms);
		}
		public static function fatal(target:Object,formMessage:String,...parms):void{
			getLogger(target).fatal(formMessage,parms);
		}
		
		public function LogUtil()
		{
		}
	}
}