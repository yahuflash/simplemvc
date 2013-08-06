package simplemvc.action
{
	import simplemvc.common.DelayCallManager;
	import simplemvc.common.HandlerObject;
	import simplemvc.common.ObjectPool;
	import simplemvc.event.DispatcherManager;

	public final class NotifyAction extends Action implements IAction{
		
		public static function create(eventType:String, args:Object=null,moduleName:String="default"):NotifyAction{
			var action:NotifyAction = ObjectPool.sharedObjectPool().retrieveNew(NotifyAction) as NotifyAction;
			action.eventType = eventType;
			action.args = args;
			action.moduleName=moduleName;
			return action;
		}
		
		public function NotifyAction(){}
		
		internal var eventType:String;
		internal var args:Object=null;
		
		override public function execute():Object{
			DispatcherManager.sharedDispatcherManager().retrieveNew(moduleName)
				.dispatchEventWith(eventType,args);
			DelayCallManager.sharedDelayCallManager().push( HandlerObject.create(complete) );
			return super.execute();
		}
	}
}