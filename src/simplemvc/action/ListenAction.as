package simplemvc.action
{
	import simplemvc.common.ObjectPool;
	import simplemvc.event.DispatcherManager;

	/**
	 * 用于监听一个特定的事件，从而取得相应的数据，或改变事件的参数及进程 
	 * @author sban
	 * 
	 */	
	public final class ListenAction extends Action implements IAction{
		public static function create(eventType:String,listener:Function,priority:int=0,moduleName:String="default"):ListenAction{
			var action:ListenAction = ObjectPool.sharedObjectPool().retrieveNew(ListenAction) as ListenAction;
			action.eventType = eventType;
			action.listener = listener;
			action.priority = priority;
			action.moduleName=moduleName;
			return action;
		}
		public function ListenAction(){}
		
		internal var eventType:String;
		internal var listener:Function;
		internal var priority:int=0;
		
		override public function execute():Object{
			DispatcherManager.sharedDispatcherManager().retrieveNew(moduleName)
				.listenTo(eventType,listener,priority);
			return super.execute();
		}
		
		override public function release():void{
			if(listener){
				DispatcherManager.sharedDispatcherManager().retrieveNew(moduleName)
					.unlistenTo(eventType,listener);
				listener=null;
			}
			super.release();
		}
		
		
	}
}