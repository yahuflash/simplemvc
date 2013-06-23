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
		
		override public function start(iterator :Iterator, promise:SimpleCommand):void{
			super.start(iterator,promise);
			while(iterator.hasNext()){
				(iterator.next().execute() as SimpleCommand).listenTo(SimpleCommand.COMPLETE, command_onComplete);
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