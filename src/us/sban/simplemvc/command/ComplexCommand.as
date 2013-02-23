package us.sban.simplemvc.command
{
	import us.sban.simplemvc.core.ICommand;
	import us.sban.simplemvc.core.Promise;
	import us.sban.simplemvc.core.Iterator;
	
	/**
	 * 复合指令
	 * @author sban
	 * 
	 */
	public class ComplexCommand extends SimpleCommand implements IComplexCommand
	{
		public function ComplexCommand(policy :IComplexCommandPolicy, commands :Array)
		{
			super();
			this.commands = Vector.<ICommand>(commands);
			this.policy = policy;
		}
		
		protected var commands :Vector.<ICommand>;
		protected var policy :IComplexCommandPolicy;
		
		override public function execute(): Promise
		{
			// TODO Auto Generated method stub
			policy.start(new Iterator(commands), super.execute());
			return this.promise;
		}
		
	}
}