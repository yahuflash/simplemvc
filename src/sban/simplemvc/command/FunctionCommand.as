package sban.simplemvc.command
{
	import sban.simplemvc.interfaces.ICommand;
	import sban.simplemvc.interfaces.IComplexCommand;

	public final class FunctionCommand implements ICommand
	{
		public function FunctionCommand(method:Function, args:Array, onDispose:Function = null)
		{
			this.method = method;
			this.args = args;
			this.onDispose = onDispose;
		}
		
		internal var parent:IComplexCommand;
		private var method:Function;
		private var args:Array;
		private var onDispose:Function = null;
		
		public function SetParent(value:IComplexCommand):void{
			parent = value;
		}
		
		public function Execute():void {
			if (!method || !args) return;
			
			var numArgs:int = args.length;
			if (numArgs == 0){
				method(this);
			}else if (numArgs == 1){
				method(this,args[0]);
			}else if (numArgs == 2){
				method(this,args[0],args[1]);
			}else if (numArgs == 3){
				method(this,args[0],args[1],args[2]);
			}else if (numArgs == 4){
				method(this,args[0],args[1],args[2],args[3]);
			}else{
				args.unshift(this);
				method.apply(null, args);
			}
		}
		
		public function Complete():void {
			if (parent) parent.OneComplete(this);
		}
		
		public function Dispose():void
		{
			if (onDispose){
				onDispose();
				onDispose = null;
			}
			this.method=null;
			this.parent=null;
			this.args=null;
		}
		
	}
}