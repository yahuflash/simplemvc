package simplemvc.action
{
	/**
	 * 动作接口
	 * 在模块之间进行数据交互的行为，称之为Action。Action的本质亦是指令，
	 * 可以作为指令被添加进指令集合。提供常用的动作类，方便进行模块间的数据传送。
	 * 
	 * Action是对事件派发与监听的封装。
	 *  
	 * @author sban
	 * 
	 */	
	public interface IAction{
		function run():Object;
	}
}