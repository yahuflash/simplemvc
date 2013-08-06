package simplemvc.action
{
	import simplemvc.command.SimpleCommand;
	import simplemvc.common.IReusable;
	import simplemvc.common.simplemvc_internal;
	
	use namespace simplemvc_internal;
	
	/**
	 * 通信动作的基类 
	 * 所有动作均派生于此
	 * 
	 * @author sban
	 * 
	 */	
	public class Action extends SimpleCommand implements IAction,IReusable{
		internal var moduleName:String;
		public final function run():Object{
			ActionManager.sharedActionManager().run(this);
			return this;
		}
	}
}