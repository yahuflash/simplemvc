package us.sban.simplemvc.command
{
	import us.sban.simplemvc.core.ICommand;
	import us.sban.simplemvc.core.ISimpleObject;
	import us.sban.simplemvc.core.Promise;
	import us.sban.simplemvc.core.SimpleObject;
	
	/**
	 * 作为所有指令的基类，复杂或定制的命令继承于此
	 *  
	 * @author sban
	 * 
	 */	
	public class SimpleCommand extends SimpleObject implements ICommand
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
		
		override public function release():ISimpleObject
		{
			this.promise=null;
			// TODO Auto Generated method stub
			return super.release();
		}
		
	}
}