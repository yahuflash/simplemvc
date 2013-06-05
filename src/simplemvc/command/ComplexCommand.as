package simplemvc.command
{
	import simplemvc.core.ICommand;
	import simplemvc.core.Promise;
	import simplemvc.util.Iterator;

	public class ComplexCommand extends SimpleCommand implements IComplexCommand
	{
		public function ComplexCommand(policy :ICommandPolicy, commands :Array)
		{
			super();
			this.commands = Vector.<ICommand>(commands);
			this.policy = policy;
		}
		
		protected var commands :Vector.<ICommand>;
		protected var policy :ICommandPolicy;
		
		override public function execute():Promise{
			// TODO Auto Generated method stubs
			super.execute();
			policy.start(new Iterator(commands),promise);
			return promise;
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			if(policy){
				this.policy.dispose();
				this.policy=null;
			}
			if(commands){
				this.commands.forEach(
					function(c :ICommand, index:int=-1, v :Vector.<ICommand>=null):void{
						c.dispose();
					}
				);
				this.commands=null;
			}
			super.dispose();
		}
		
		
	}
}