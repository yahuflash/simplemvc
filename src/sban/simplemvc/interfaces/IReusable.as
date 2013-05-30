package sban.simplemvc.interfaces
{
	/**可回收再用接口，实现该接口*/
	public interface IReusable extends IInitializable, IDisposable
	{
		/**回收存储时所使用的key，在从对象池内取出缓存时将会用到*/
		function get reuseKey():String;
	}
}