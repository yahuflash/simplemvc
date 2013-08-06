package simplemvc.common
{
	import simplemvc.action.ActionFacade;
	import simplemvc.command.CommandFacade;
	import simplemvc.module.ModuleFacade;
	import simplemvc.util.URLLoaderUtil;
	
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
		
		/**load util func*/
		public function load(path,callback:Function,format:String="text"):void{
			URLLoaderUtil.load(path,callback,format);
		}
		public function load3times(path,callback:Function,format:String="text"):void{
			URLLoaderUtil.load(path,callback,format);
		}
	}
}