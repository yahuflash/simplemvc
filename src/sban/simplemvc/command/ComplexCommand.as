package sban.simplemvc.command
{
	import sban.simplemvc.interfaces.ICommand;
	import sban.simplemvc.interfaces.IComplexCommand;

	internal class ComplexCommand implements IComplexCommand
	{
		public function ComplexCommand(cmds:Vector.<ICommand>)
		{
			this.commands = cmds;
			if (commands && commands.length > 0){
				const self:IComplexCommand = this;
				commands.forEach(function(c:ICommand,index:int=-1,vec:Vector.<ICommand>=null):void{
					c.SetParent( self );
				});
			}
		}
		
		private var parent:IComplexCommand;
		protected var commands:Vector.<ICommand>;
		protected var numComplete:int=0;
		protected var numTotal:int = 0;
		
		public function Complete():void{
			if (parent) parent.OneComplete(this);
			Dispose();
		}
		
		public function Execute():void{}
		public function OneComplete(one:ICommand):void{}
		
		public function SetParent(value:IComplexCommand):void{
			parent = value;
		}
		
		public function Dispose():void{
			this.parent=null;
			if (commands){
				commands.forEach(function(c:ICommand,index:int=-1,vec:Vector.<ICommand>=null):void{
					c.Dispose();
				});
				this.commands=null;
			}
		}
	}
}