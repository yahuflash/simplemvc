package simplemvc.event
{
	import flash.utils.Dictionary;

	/**提供对事件派发器的实例管理，以名称划分，每一个名称一个派发器
	 * 对于应用中的模块，每一个模块一个派发器*/
	public final class DispatcherManager{
		private static var instance:DispatcherManager;
		public static function sharedDispatcherManager():DispatcherManager{
			return (instance ||= new DispatcherManager);
		}
		public function DispatcherManager(){}
		protected const dispatcherMap:Dictionary = new Dictionary();
		
		/**如果不存在，则新建一个派发器*/
		public function retrieveNew(moduleName:String="default"):SimpleEventDispatcher{
			return (dispatcherMap[moduleName] ||= SimpleEventDispatcher.create());
		}
		/**移除派发器，如在模块释放时调用，事件派发器被回收*/
		public function remove(moduleName:String="default"):void{
			if(dispatcherMap[moduleName]){
				retrieveNew(moduleName).release();
				delete dispatcherMap[moduleName];
			}
		}
	}
}