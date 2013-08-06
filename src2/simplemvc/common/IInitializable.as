package simplemvc.common
{
	/**
	 * 资源初始化接口
	 * 如果对象存在复杂的初始化过程，而非仅成员变量的初始化，实现该接口
	 * 对于仅需设置成员变量的类，可直接在create中设置;如果有其它的初始化过程，实现该接口，并在初始化完成时派发initialized事件。
	 * 
	 * fixed on 2013/06/21
	 *  
	 * @author sban
	 * 
	 */	
	public interface IInitializable{
		/**初始化所需的参数及成员变量，在static create方法中设置，或在调用方作用域中设置*/
		function init():Object;
	}
}