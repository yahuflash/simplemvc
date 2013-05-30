package us.sban.simplemvc.command
{
	import us.sban.simplemvc.core.Promise;
	
	/**
	 * 包装同步方法用于在一个执行序列中执行，例：
	 * <pre>
	 * var c = new FunctionCommand(function(a,b){...}, [1,2]); 
	 * c.execute();
	 * </pre>
	 * 
	 * 对SyncCommand，执行即完成。
	 * 
	 * @author sban
	 * 
	 */	
	public class SyncCommand extends SimpleCommand
	{
		public function SyncCommand(func :Function, args :Array = null)
		{
			super();
			this.func = func;
			this.args = args;
		}
		
		protected var func :Function;
		protected var args :Array;
		
		override public function execute(): Promise
		{
			// TODO Auto Generated method stub
			var data :Object = this.func.apply(null,this.args);
			return super.execute().complete( data );
		}
		
	}
}