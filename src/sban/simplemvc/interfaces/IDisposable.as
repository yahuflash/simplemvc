package sban.simplemvc.interfaces
{
	/**对象自身对外提供释放自身资源的方法，包括清理视频，称除定时器，事件监听等*/
	public interface IDisposable
	{
		function dispose():void;
	}
}