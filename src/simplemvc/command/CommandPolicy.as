package simplemvc.command
{
	import simplemvc.common.IReusable;
	import simplemvc.common.Iterator;
	import simplemvc.common.ObjectPool;

	/**
	 * 复合指令执行策略
	 * @author sban
	 * 
	 */	
	public class CommandPolicy implements ICommandPolicy,IReusable
	{
		public function CommandPolicy(){}
		
		protected var numComplete :int;
		protected var numTotal :int;
		protected var iterator :Iterator;
		protected var command:SimpleCommand;
		internal var strict:Boolean = true;
		
		public function start(withIterator :Iterator, withCommand:SimpleCommand):void
		{
			iterator = withIterator;
			command = withCommand;
			numComplete=0;
			numTotal = iterator.numItems();
		}
		
		public function release():void
		{
			// TODO Auto Generated method stub
			iterator.release();
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
		
	}
}