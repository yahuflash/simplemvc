package simplemvc.common
{
	import simplemvc.action.ActionFacade;
	import simplemvc.command.CommandFacade;
	import simplemvc.event.SimpleDispatcher;
	import simplemvc.module.ModuleFacade;
	
	use namespace simplemvc_internal;

	public final class SimpleMVC
	{
		public function SimpleMVC(){}
		
		/**提供消息动作的API*/
		public const action:ActionFacade = new ActionFacade();
		/**指令相关API*/
		public const command:CommandFacade = new CommandFacade();
		/**模块相关API*/
		public const module:ModuleFacade = new ModuleFacade();
		/**应用导演对象*/
		public var director:IDirector;
	}
}