package sban.simplemvc.command
{
	import sban.simplemvc.core.Promise;
	import sban.simplemvc.core.Iterator;

	/**
	 * 复合指令执行策略
	 * @author sban
	 * 
	 */	
	public class ComplexCommandPolicy implements IComplexCommandPolicy
	{
		public function ComplexCommandPolicy()
		{
		}
		
		protected var numComplete :int;
		protected var numTotal :int;
		protected var iterator :Iterator;
		protected var promise:Promise;
		
		public function start(iterator :Iterator, promise:Promise):void
		{
			this.iterator = iterator;
			this.promise = promise;
			numComplete=0;
			this.numTotal = this.iterator.count;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			if(iterator)
			{
				iterator.dispose();
				this.iterator=null;
			}
			if(promise)
			{
				promise.dispose();
				this.promise=null;
			}
		}
		
	}
}