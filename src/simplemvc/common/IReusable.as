package simplemvc.common
{
	/**
	 * 对象复用接口
	 * 
	 * 实现方法：
	 * 1，实现static create方法，传入初始化所需参数，
	 *  －使用$.pool.retrieve拉出对象，调用init完成初始化
	 * 2，在dispose中调用$.pool.push(this)
	 * 
	 * 与IDisposable接口不同，dispose的对象不再使用，reuse之后的对象将重复使用;
	 * 相同之处，两者皆会释放所占资源。如实现IDisposable接口，将不再实现IReusable接口，两者互斥。
	 * 
	 * fixed on 2010/06/20
	 * */
	public interface IReusable
	{
		/**释放并将对象推入对象复用池*/
		function release():void;
	}
}