package simplemvc.command
{
	import simplemvc.common.ObjectPool;

	/**
	 * 环行指令，执行到最后一个后重头开始执行
	 * @author sban
	 * 
	 */	
	public final class CirclineCommand extends ComplexCommand
	{
		/**strict如果为false，表示指令在cancel，complete时都可以继续向下执行*/
		public static function create(commands :Array,strict:Boolean=true):CirclineCommand{
			var command:CirclineCommand = ObjectPool.sharedObjectPool().retrieveNew(CirclineCommand) as CirclineCommand;
			command.commands = new Vector.<SimpleCommand>(commands);
			command.policy = SerialPolicy.create(strict);
			return command;
		}
	}
}