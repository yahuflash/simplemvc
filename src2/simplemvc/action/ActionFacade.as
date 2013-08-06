package simplemvc.action
{
	/**
	 * 消息动作的外观接口 
	 * @author sban
	 * 
	 */	
	public final class ActionFacade{
		public function ActionFacade(){}
		
		/**监听消息*/
		public function listen(eventType:String,listener:Function,priority:int=0,moduleName:String="default"):ListenAction{
			return ListenAction.create(eventType,listener,priority,moduleName).run() as ListenAction;
		}
		
		/**广播消息*/
		public function notify(eventType:String, args:Object=null,moduleName:String="default"):NotifyAction{
			return NotifyAction.create(eventType,args,moduleName).run() as NotifyAction;
		}
		
		/**拉取消息*/
		public function retrieve(requestEventType:String
								 ,requestArgs:Object
								  ,responseEventType:String
								   ,responseListener:Function
									,responsePriority:int=0
									 ,moduleName:String="default"):RetrieveAction{
			return RetrieveAction.create(requestEventType,requestArgs,responseEventType,responseListener,responsePriority,moduleName)
				.run() as RetrieveAction;
		}
	}
}