package sban.simplemvc.core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 全局的事件派发对象
	 */
	public final class GlobalEventDispatcher extends EventDispatcher
	{
		private static var instance:IEventDispatcher;
		public static function get sharedInstance():IEventDispatcher{
			return (instance ||= new GlobalEventDispatcher);
		}
		public function GlobalEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}