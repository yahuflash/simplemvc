package sban.simplemvc.controls
{
	import sban.simplemvc.interfaces.IDisposable;

	/**视图控制器的接口*/
	public interface IControl extends IDisposable
	{
		/**返回的对象可以是flash.display.DisplayObject，也可以是starling的显示对象，或者是其它的类型*/
		function get content():Object;
	}
}