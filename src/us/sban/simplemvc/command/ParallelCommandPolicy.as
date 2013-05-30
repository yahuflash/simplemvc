package us.sban.simplemvc.command
{
	import us.sban.simplemvc.core.Promise;
	import us.sban.simplemvc.core.Iterator;

	/**
	 * 并发执行策略 
	 * @author sban
	 * 
	 */	
	public class ParallelCommandPolicy extends ComplexCommandPolicy
	{
		public function ParallelCommandPolicy()
		{
		}
		
		override public function start(iterator :Iterator, promise:Promise):void
		{
			super.start(iterator,promise);
			
			while(iterator.hasNext())
			{
				iterator.next().execute().complete(command_onComplete);
			}
		}
		
		protected function command_onComplete(data :Object=null):void
		{
			if (++numComplete == numTotal)
			{
				promise.complete();
			}
		}
	}
}