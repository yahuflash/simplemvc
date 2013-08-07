package sban.simplemvc.interfaces
{
	/**
	 * 指令接口 
	 * @author sban
	 * 
	 */	
	public interface ICommand extends IDisposable
	{
		/**设置上一级节点*/
		function SetParent(value:IComplexCommand):void;
		
		function Execute():void;
		function Complete():void;
	}
}