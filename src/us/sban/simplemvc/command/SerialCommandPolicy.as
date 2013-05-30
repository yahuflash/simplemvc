package us.sban.simplemvc.command
{
	import us.sban.simplemvc.core.Iterator;
	import us.sban.simplemvc.core.Promise;
	
	/**
	 * 串发复合指令执行策略
	 * @author sban
	 * 
	 */	
	public class SerialCommandPolicy extends ComplexCommandPolicy
	{
		public function SerialCommandPolicy()
		{
		}
		
		override public function start(iterator :Iterator, promise:Promise):void
		{
			super.start(iterator,promise);
			executeNextCommand();
		}
		
		protected function executeNextCommand():void
		{
			if (iterator.hasNext())
			{
				iterator.next().execute().complete(command_onComplete);
			}
		}
		
		protected function command_onComplete(data :Object=null):void
		{
			if (++numComplete < numTotal)
			{
				executeNextCommand();
			}else{
				this.promise.complete();
			}
		}
	}
}