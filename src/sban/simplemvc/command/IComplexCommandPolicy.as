package sban.simplemvc.command
{
	import sban.simplemvc.core.IDisposable;
	import sban.simplemvc.core.Promise;
	import sban.simplemvc.core.Iterator;

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