package simplemvc.command
{
	import simplemvc.common.HandlerObject;
	import simplemvc.common.ObjectPool;

	/**
	 * 导步调用方法的封装
	 * 完成之后，在所调用方法中调用complete方法
	 * 
	 * 注意：如果使用该指令封装了一个同步方法，一定要在execute之前注册监听，
	 * 否则在同步方法中直接调用complete，会导致接收不到完成事件。
	 * 
	 * @author sban
	 * 
	 */	
	public class FuncCommand extends SimpleCommand
	{
		/**
		 * withFunc example:function(c:SimpleCommand,...others):void
		 * SimpleCommand调用withFunc方法时，默认将SimpleCommand作为第一个参数传入，
		 * 当异步操作完成时，调用c.complete()方法完成指令的执行。
		 * */
		public static function create(withFunc :Function, andOthers:Array):FuncCommand{
			var command:FuncCommand= ObjectPool.sharedObjectPool().retrieveNew(FuncCommand) as FuncCommand;
			andOthers.unshift(command);
			command.handler = HandlerObject.create(withFunc,andOthers);
			command.released=false;
			return command;
		}
		public function FuncCommand(){}
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
			return FuncCommand.create(handler.func,handler.args);
		}
	}
}