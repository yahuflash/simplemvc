package simplemvc.action
{
	import simplemvc.command.SimpleCommand;
	import simplemvc.event.DispatcherManager;
	import simplemvc.event.SimpleEventDispatcher;
	import simplemvc.module.Module;

	/**
	 * 动作管理器类
	 *  
	 * @author sban
	 * 
	 */	
	public final class ActionManager
	{
		private static var instance:ActionManager;
		public static function sharedActionManager():ActionManager{
			return (instance ||= new ActionManager);
		}
		public function ActionManager(){
			/**在一个模块释放时，释放其相关的Action*/
			SimpleEventDispatcher.sharedSimpleDispatcher().listenTo(Module.MODULE_DISPOSED,function(args:Object):void{
				removeActionByModuleName(args.name);
			});
		}
		private var actions:Vector.<Action> = new Vector.<Action>();
		
		/**执行消息动作*/
		internal function run(action:Action):void{
			if (action is NotifyAction){
				//如果是派发动作，执行，然后回收
				action.execute().release();
			}else if(action is ListenAction){
				//如果是监听动作，执行，然后推入列表
				//在模块回收时，将其回收
				action.execute();
				actions.push( action );
			}else if(action is RetrieveAction){
				//如果是拉取动作，执行，在完成后回收
				action.listenTo(SimpleCommand.COMPLETE,function():void{
					remove(action);
					action.release();
				});
				action.execute();
				actions.push( action );
			}
		}
		
		internal function removeActionByModuleName(moduleName:String):void{
			for each(var action:Action in actions){
				if(action.moduleName == moduleName){
					remove(action);
					action.release();
				}
			}
		}
		
		internal function remove(action:Action):void{
			var index:int = actions.indexOf(action);
			if (index > -1) actions.splice(index,1);
		}
	}
}