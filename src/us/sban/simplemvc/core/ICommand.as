package us.sban.simplemvc.core
{
	/**
	 * 命令模式
	 * 单次执行，不保存数据，不持有对象 
	 * 
	 * 执行之后，获取Promise对象，才可能把指令设置为完成，即调用complete。
	 * 
	 * promise指令：complete
	 * 
	 * @author sban
	 * 
	 */	
	public interface ICommand extends IDisposable, ISimpleObject
	{
		/**执行*/
		function execute(): Promise;
	}
}