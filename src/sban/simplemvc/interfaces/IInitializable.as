package sban.simplemvc.interfaces
{
	/**不提倡在类的构造器中将参数传入并初始化，代替的方案是提供一个init方法*/
	public interface IInitializable
	{
		function init(...args):void;
	}
}