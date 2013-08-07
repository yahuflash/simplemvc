package sban.simplemvc.core
{
	import sban.simplemvc.event.SimpleEventDispatcher;

	public final class SimpleFacade
	{
		public function SimpleFacade(){}
		
		/**全局事件派发器的引用*/
		public const GlobalEventDispatcher:SimpleEventDispatcher = SimpleEventDispatcher.SharedInstance();
		
		/**打印对象到目标载体，默认使用trace*/
		public function Print(...args):void{ var f:Function = trace;f.apply(null,args); }
		
		/**关于指令的API*/
		public const Command:CommandFacade = new CommandFacade();
	}
}