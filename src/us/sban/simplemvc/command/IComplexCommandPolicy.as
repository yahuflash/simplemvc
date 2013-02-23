package us.sban.simplemvc.command
{
	import us.sban.simplemvc.core.IDisposable;
	import us.sban.simplemvc.core.Iterator;
	import us.sban.simplemvc.core.Promise;

	/**
	 * 复合指令执行策略接口
	 * @author sban
	 * 
	 */
	public interface IComplexCommandPolicy extends IDisposable
	{
		function start(iterator :Iterator, promise:Promise):void;
	}
}