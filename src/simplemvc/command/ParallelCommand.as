package simplemvc.command
{
	import simplemvc.common.ObjectPool;

	/**
	 * 并发指令 
	 * @author sban
	 * 
	 */	
	public final class ParallelCommand extends ComplexCommand
	{
		/**如果strict为false，则任意一个子指令完成即表示集合完成*/
		public static function create(commands :Array, strict:Boolean=true):ParallelCommand{
			var command:ParallelCommand = ObjectPool.sharedObjectPool().retrieveNew(ParallelCommand) as ParallelCommand;
			command.commands = new Vector.<SimpleCommand>(commands);
			command.policy = ParallelPolicy.create(strict);
			return command;
		}
	}
}