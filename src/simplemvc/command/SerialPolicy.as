package simplemvc.command
{
	import simplemvc.core.ICommand;
	import simplemvc.core.Promise;
	import simplemvc.event.SimpleEvent;
	import simplemvc.util.Iterator;

	public class SerialPolicy extends CommandPolicy
	{
		public function SerialPolicy(){}
		
		override public function start(iterator:Iterator,promise:Promise):void{
			super.start(iterator,promise);
			executeNextCommand();
		}
		
		protected function executeNextCommand():void{
			if (iterator.hasNext()){
				var c :ICommand = iterator.next() as ICommand;
				c.execute().complete(command_onComplete);
			}
		}
		
		protected function command_onComplete(...args):void{
			if (++numComplete < numTotal){
				executeNextCommand();
			}else{
				promise.dispatchSimpleEvent(SimpleEvent.COMPLETE);
			}
		}
	}
}