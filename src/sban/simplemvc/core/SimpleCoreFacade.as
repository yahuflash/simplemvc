package sban.simplemvc.core
{
	public final class SimpleCoreFacade
	{
		public function SimpleCoreFacade(){}
		
		/**
		 * 全局事件派发对象的引用 
		 */		
		public const GED:GlobalEventDispatcher = GlobalEventDispatcher.SharedInstance();
	}
}