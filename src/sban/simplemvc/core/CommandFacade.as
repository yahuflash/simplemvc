package sban.simplemvc.core
{
	import sban.simplemvc.command.CircleCommand;
	import sban.simplemvc.command.FunctionCommand;
	import sban.simplemvc.command.ParallelCommand;
	import sban.simplemvc.command.SequenceCommand;
	import sban.simplemvc.interfaces.ICommand;
	import sban.simplemvc.interfaces.IComplexCommand;

	public final class CommandFacade
	{
		public function CommandFacade(){}
		
		public function Func(method:Function, onDispose:Function = null,...args):ICommand {
			return new FunctionCommand(method, args, onDispose);
		}
		
		public function Parallel(strict:Boolean = true, ...cmds):IComplexCommand {
			return new ParallelCommand(Vector.<ICommand>(cmds), strict);
		}
		
		public function Sequence(...cmds):IComplexCommand {
			return new SequenceCommand(Vector.<ICommand>(cmds));
		}
		
		public function Circle(...cmds):IComplexCommand {
			return new CircleCommand( Vector.<ICommand>(cmds) );
		}
	}
}