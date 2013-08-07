package sban.simplemvc.interfaces
{
	/**
	 * 复合指令接口 
	 * @author sban
	 * 
	 */	
	public interface IComplexCommand extends ICommand
	{
		/**当一个子指令完成时执行的逻辑*/
		function OneComplete(one:ICommand):void;
	}
}