package us.sban.simplemvc.service.proxy
{
	import flash.net.SharedObject;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * 以本地LocalShareObject作为存储源，封装对其操作方法 
	 * 在Flash Web, AIR中均存在该源，但有大小限制，并且用户有可能禁止
	 * 
	 * @author sban
	 * 
	 */	
	public dynamic class LocalProxy extends Proxy
	{
		public static const single :LocalProxy = new LocalProxy();
		
		public function LocalProxy(name :String = "simplemvc_localProxy")
		{
			this.so = SharedObject.getLocal(name);
		}
		
		protected var so :SharedObject;
		
		override flash_proxy function callProperty(name:*, ...parameters):*
		{
			switch (name.toString()) {
				case 'clear':
					so.clear();
					break;
				case 'flush':
					so.flush( parameters.length > 0 ? parameters[0] : 0 )
					break;
				case 'remove':
					delete this.so.data[parameters[0]];
					break;
				default:
					break;
			}
			return this;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			// TODO Auto Generated method stub
			delete this.so.data[name.toString()];
			return true;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			// TODO Auto Generated method stub
			return this.so.data[name.toString()];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			// TODO Auto Generated method stub
			return (this.so.data[name.toString()]);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			// TODO Auto Generated method stub
			this.so.data[name.toString()] = value;
		}
		
		
	}
}