package sban.simplemvc.command
{
	import sban.simplemvc.core.Application;
	import sban.simplemvc.core.ICommand;
	import sban.simplemvc.core.Promise;
	
	/**
	 * 作为所有指令的基类，复杂或定制的命令继承于此
	 *  
	 * @author sban
	 * 
	 */	
	public class SimpleCommand implements ICommand
	{
		public function SimpleCommand()
		{
			super();
		}
		
		protected var promise :Promise;
		
		public function execute(): Promise
		{
			return (this.promise ||= new Promise(this));
		}
		
		public function dispose(): void
		{
			// TODO Auto Generated method stub
			if(promise)
			{
				promise.dispose();
				promise = null;
			}
		}
		
		public function intoStack():void
		{
			Application.application.stack.pushCommand(this);
		}
	}
}