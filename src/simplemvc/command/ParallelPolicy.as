package simplemvc.command
{
	import simplemvc.core.ICommand;
	import simplemvc.core.Promise;
	import simplemvc.event.SimpleEvent;
	import simplemvc.util.Iterator;

	/**
	 * 并发执行策略 
	 * @author Optimus.Li
	 * 
	 */	
	public class ParallelPolicy extends CommandPolicy
	{
		public function ParallelPolicy(){}
		
		override public function start(iterator:Iterator,promise:Promise):void
		{
			super.start(iterator,promise);
			var c :ICommand;
			
			while(iterator.hasNext()){
				c = iterator.next() as ICommand;
				c.execute().complete(command_onComplete);
			}
		}
		
		protected function command_onComplete(...args):void{
			if (++numComplete == numTotal){
				promise.dispatchSimpleEvent(SimpleEvent.COMPLETE);
			}
		}
	}
}