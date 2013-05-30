package simplemvc.event
{
	/**
	 * 全局的事件派发对象 
	 * @author sban
	 * 
	 */	
	public final class GlobalEventDispatcher extends SimpleEventDispatcher
	{
		private static var instance:SimpleEventDispatcher;
		public static function sharedInstance():SimpleEventDispatcher{
			return (instance ||= SimpleEventDispatcher.create());
		}
		
		public function GlobalEventDispatcher(){}
	}
}