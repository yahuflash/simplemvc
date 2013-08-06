package simplemvc.common
{
	/**
	 * 对象克隆接口
	 * 将对象复印为另一个具有相同结构及数据的对象
	 * 
	 * fixed on 2010/06/20
	 * */
	public interface IClonable{
		/**实现方法：
		 * 1，new一个同类对象，调用init方法初始化
		 * 2，设置当前即时状态数据，如果有的话*/
		function clone():Object;
	}
}