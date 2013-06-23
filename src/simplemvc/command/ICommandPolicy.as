package simplemvc.command
{
	import simplemvc.common.Iterator;

	/**
	 * 复合指令执行策略接口
	 * @author sban
	 */
	public interface ICommandPolicy
	{
		function start(iterator :Iterator, c:SimpleCommand):void;
	}
}