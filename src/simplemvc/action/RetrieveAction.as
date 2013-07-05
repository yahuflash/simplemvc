package simplemvc.action
{
	import simplemvc.common.ObjectPool;
	import simplemvc.event.DispatcherManager;
	import simplemvc.event.SimpleEvent;

	public final class RetrieveAction extends Action implements IAction{
		public static function create(requestEventType:String
									  ,requestArgs:Object
									  ,responseEventType:String
									   ,responseListener:Function
									   ,responsePriority:int=0
										,moduleName:String="default"):RetrieveAction{
			var action:RetrieveAction = ObjectPool.sharedObjectPool().retrieveNew(RetrieveAction) as RetrieveAction;
			action.requestEventType=requestEventType;
			action.requestArgs=requestArgs;
			action.responseEventType=responseEventType;
			action.responseListener=responseListener;
			action.responsePriority=responsePriority;
			action.moduleName = moduleName;
			return action;
		}
		
		public function RetrieveAction(){}
		
		internal var requestEventType:String;
		internal var requestArgs:Object;
		internal var responseEventType:String;
		internal var responseListener:Function;
		internal var responsePriority:int;
		
		override public function execute():Object{
			DispatcherManager.sharedDispatcherManager().retrieveNew(moduleName)
				.listenTo(responseEventType,function(data:Object,e:SimpleEvent):void{
					var numArgs:int = responseListener.length;
					if (numArgs == 0) responseListener();
					else if (numArgs == 1) responseListener(e.args);
					else if (numArgs == 2) responseListener(e.args,e);
				},responsePriority);
			DispatcherManager.sharedDispatcherManager().retrieveNew(moduleName)
				.dispatchWith(requestEventType,requestArgs);
			return super.execute();
		}
		
		override public function release():void{
			responseListener=null;
			super.release();
		}
		
		
	}
}