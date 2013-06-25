package simplemvc.command
{
	import simplemvc.common.Iterator;
	import simplemvc.common.ObjectPool;

	/**
	 * 并发执行策略 
	 * @author sban
	 * 
	 */	
	public class ParallelPolicy extends CommandPolicy
	{
		public static function create(strict:Boolean):ParallelPolicy{
			var policy:ParallelPolicy = ObjectPool.sharedObjectPool().retrieveNew(ParallelPolicy) as ParallelPolicy;
			policy.strict=strict;
			return policy;
		}
		
		override public function start(withIterator :Iterator, promise:SimpleCommand):void{
			super.start(withIterator,promise);
			var c:SimpleCommand;
			while(iterator.hasNext()){
				c = iterator.next() as SimpleCommand;
				c.listenTo(SimpleCommand.COMPLETE, command_onComplete);
				c.execute();
			}
		}
		
		protected function command_onComplete():void{
			if (strict){
				if (++numComplete == numTotal){
					command.complete();
					command.release();
				}
			}else{
				command.complete();
				command.release();
			}
		}
	}
}