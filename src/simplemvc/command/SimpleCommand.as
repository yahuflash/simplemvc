package simplemvc.command
{
	import simplemvc.core.ICommand;
	import simplemvc.core.Promise;
	import simplemvc.event.SimpleEvent;
	import simplemvc.event.SimpleEventDispatcher;
	
	/**
	 * 作为所有指令的基类，复杂或定制的命令继承于此
	 */	
	public class SimpleCommand extends SimpleEventDispatcher implements ICommand
	{
		public function SimpleCommand(){
			super();
		}
		
		protected var promise:Promise;
		
		public function execute():Promise{
			return (promise ||= Promise.create());
		}
		
		override public function dispose():void{
			// TODO Auto Generated method stub
			if(promise) promise.dispose();
			super.dispose();
		}
		
		protected function setComplete():void{
			promise.dispatchSimpleEvent( SimpleEvent.COMPLETE );
		}
	}
}