package sban.simplemvc.command
{
	import sban.simplemvc.interfaces.ICommand;
	
	public final class CircleCommand extends ComplexCommand
	{
		public function CircleCommand(cmds:Vector.<ICommand>){
			super(cmds);
		}
		
		private var current:int = -1;
		
		override public function Execute():void{
			if (commands){
				if (commands.length > 0) {
					numComplete=0;
					numTotal = commands.length;
					executeNextCommand();
				}
			}
		}
		
		override public function OneComplete(one:ICommand):void{
			executeNextCommand();
		}
		
		private function executeNextCommand():void{
			if (++current == numTotal){
				current = 0;
			}
			commands[current].Execute();
		}
		
	}
}