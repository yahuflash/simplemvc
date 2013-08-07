package sban.simplemvc.command
{
	import sban.simplemvc.interfaces.ICommand;
	
	public final class ParallelCommand extends ComplexCommand
	{
		public function ParallelCommand(cmds:Vector.<ICommand>, strict:Boolean = true){
			super(cmds);
			this.strict = strict;
		}
		
		/**如果为true，则每一个子指令全部完成，此指令算是完成;如果为false，任意一子指令完成，即算完成*/
		private var strict:Boolean = true;
		
		override public function Execute():void{
			if (commands){
				if (commands.length > 0) {
					numComplete = 0;
					numTotal = commands.length;
					commands.forEach(function(c:ICommand,index:int=-1,vec:Vector.<ICommand>=null):void{
						c.Execute();
					});
				}else {
					Complete();
				}
			}
		}
		
		override public function OneComplete(one:ICommand):void{
			if (strict){
				if (++numComplete == numTotal) {
					Complete();
				}
			}else{
				Complete();
			}
		}
		
	}
}