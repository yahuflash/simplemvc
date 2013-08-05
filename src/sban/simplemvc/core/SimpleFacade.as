package sban.simplemvc.core
{
	import sban.simplemvc.event.SimpleEventDispatcher;

	public final class SimpleFacade
	{
		public function SimpleFacade(){}
		
		/**全局事件派发器的引用*/
		public const GlobalEventDispatcher:SimpleEventDispatcher = SimpleEventDispatcher.SharedInstance();
	}
}