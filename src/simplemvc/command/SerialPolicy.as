package simplemvc.command
{
	import simplemvc.common.Iterator;
	import simplemvc.common.ObjectPool;

	/**
	 * 串发复合指令执行策略
	 * @author sban
	 * 
	 */	
	public class SerialPolicy extends CommandPolicy
	{
		public static function create(strict:Boolean):SerialPolicy{
			var policy:SerialPolicy = ObjectPool.sharedObjectPool().retrieveNew(SerialPolicy) as SerialPolicy;
			policy.strict=strict;
			return policy;
		}
		
		override public function start(iterator :Iterator, promise:SimpleCommand):void
		{
			super.start(iterator,promise);
			executeNextCommand();
		}
		
		protected function executeNextCommand():void{
			if (iterator.hasNext()){
				if (strict){
					(iterator.next().execute() as SimpleCommand).listenTo(SimpleCommand.COMPLETE, command_onComplete);
				}else{
					(iterator.next().execute() as SimpleCommand).listenTos([SimpleCommand.COMPLETE,SimpleCommand.CANCEL], command_onComplete);				
				}
			}
		}
		
		protected function command_onComplete():void{
			if (++numComplete < numTotal){
				executeNextCommand();
			}else{
				command.complete();
				command.release();
			}
		}
	}
}