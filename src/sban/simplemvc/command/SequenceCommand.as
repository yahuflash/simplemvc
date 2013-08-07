package sban.simplemvc.command
{
	import sban.simplemvc.interfaces.ICommand;
	
	public final class SequenceCommand extends ComplexCommand
	{
		public function SequenceCommand(cmds:Vector.<ICommand>){
			super(cmds);
		}
		
		private var current:int = -1;
		
		override public function Execute():void{
			if (commands){
				if (commands.length > 0) {
					numComplete=0;
					numTotal = commands.length;
					executeNextCommand();
				}else {
					Complete();
				}
			}
		}
		
		override public function OneComplete(one:ICommand):void{
			if (++numComplete == numTotal) {
				Complete();
			}else{
				executeNextCommand();
			}
		}
		
		private function executeNextCommand():void{
			commands[++current].Execute();
		}
	}
}