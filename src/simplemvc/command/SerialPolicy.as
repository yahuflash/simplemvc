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
		
		override public function start(withIterator :Iterator, promise:SimpleCommand):void{
			super.start(withIterator,promise);
			executeNextCommand();
		}
		
		protected function executeNextCommand():void{
			var c:SimpleCommand;
			if (iterator.hasNext()){
//				trace("start");
				c = iterator.next() as SimpleCommand;
				if (strict){
					c.listenTo(SimpleCommand.COMPLETE, command_onComplete);
				}else{
					c.listenTos([SimpleCommand.COMPLETE,SimpleCommand.CANCEL], command_onComplete);				
				}
				c.execute();
			}
		}
		
		protected function command_onComplete():void{
//				trace("end");
			if (++numComplete < numTotal){
				executeNextCommand();
			}else{
				command.complete();
				command.release();
			}
		}
	}
}