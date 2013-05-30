package simplemvc.core
{
	/**可复用对象接口
	 * 实现static create方法
	 * 在dispose中调用SimpleObjectPool.sharedInstance().push(this);
	 * */
	public interface IReusable extends IDisposable
	{
		
	}
}