package simplemvc.command
{
	import simplemvc.common.ObjectPool;

	/**
	 * 串发指令
	 * @author sban
	 * 
	 */	
	public final class SerialCommand extends ComplexCommand {
		/**strict如果为false，表示指令在cancel，complete时都可以继续向下执行*/
		public static function create(commands :Array,strict:Boolean=true):SerialCommand{
			var command:SerialCommand = ObjectPool.sharedObjectPool().retrieveNew(SerialCommand) as SerialCommand;
			command.commands = Vector.<SimpleCommand>(commands);
			command.policy = SerialPolicy.create(strict);
			command.released=false;
			return command;
		}
		
		override public function clone():Object{
			var c:SerialCommand = SerialCommand.create([], policy.strict);
			c.commands = commands.concat();
			return c;
		}
	}
}