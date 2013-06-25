package simplemvc.command
{
	import simplemvc.common.HandlerObject;
	import simplemvc.common.ObjectPool;

	/**
	 * 导步调用方法的封装
	 * 完成之后，在所调用方法中调用complete方法
	 * 
	 * @author sban
	 * 
	 */	
	public class AsyncCommand extends SimpleCommand
	{
		/**
		 * withFunc example:function(c:SimpleCommand,...others):void
		 * SimpleCommand调用withFunc方法时，默认将SimpleCommand作为第一个参数传入，
		 * 当异步操作完成时，调用c.complete()方法完成指令的执行。
		 * */
		public static function create(withFunc :Function, andOthers:Array):AsyncCommand{
			var command:AsyncCommand= ObjectPool.sharedObjectPool().retrieveNew(AsyncCommand) as AsyncCommand;
			andOthers.unshift(command);
			command.handler = HandlerObject.create(withFunc,andOthers);
			command.released=false;
			return command;
		}
		public function AsyncCommand(){}
		internal var handler:HandlerObject;
		
		override public function execute():Object{
			if (released) return this;
			handler.call();
			return this;
		}
		
		override public function release():void{
			handler.release();
			super.release();
		}
		
		override public function clone():Object{
			return AsyncCommand.create(handler.func,handler.args);
		}
	}
}