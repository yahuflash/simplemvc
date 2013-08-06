package simplemvc.command
{
	import simplemvc.common.Iterator;
	import simplemvc.common.ObjectPool;

	/**
	 * 环行指令执行策略
	 * @author sban
	 * 
	 */	
	public class CirclinePolicy extends CommandPolicy
	{
		public static function create(strict:Boolean):CirclinePolicy{
			var policy:CirclinePolicy = ObjectPool.sharedObjectPool().retrieveNew(CirclinePolicy) as CirclinePolicy;
			policy.strict=strict;
			return policy;
		}
		
		override public function start(iterator :Iterator, promise:SimpleCommand):void{
			super.start(iterator,promise);
			executeNextCommand();
		}
		
		protected function executeNextCommand():void{
			if (iterator.hasNext()){
				var c:SimpleCommand = iterator.next() as SimpleCommand;
				if (strict){
					c.addEventListener(SimpleCommand.COMPLETE, command_onComplete);
				}else{
					c.addEventListenersTo([SimpleCommand.COMPLETE,SimpleCommand.CANCEL], command_onComplete);				
				}
				c.execute();
			}
		}
		
		protected function command_onComplete():void{
			if (++numComplete == numTotal){
				numComplete=0;
				numTotal=iterator.numItems();
				iterator.reset();
			}
			executeNextCommand();
		}
	}
}