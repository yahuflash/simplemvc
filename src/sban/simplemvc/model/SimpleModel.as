package sban.simplemvc.model
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import sban.simplemvc.core.Promise;
	import sban.simplemvc.model.proxy.AMFProxy;
	import sban.simplemvc.model.proxy.LocalProxy;
	import sban.simplemvc.model.proxy.MemoryProxy;
	import sban.simplemvc.model.proxy.SocketProxy;
	
	public dynamic class SimpleModel extends Proxy
	{
		public function SimpleModel()
		{
		}
		
		protected var memory :MemoryProxy = MemoryProxy.single;
		protected var local :LocalProxy = LocalProxy.single;
		protected var amf :AMFProxy = AMFProxy.single;
		protected var socket :SocketProxy = SocketProxy.single;
		
		protected var data:Object = {};
		
		override flash_proxy function callProperty(name:*, ...parameters):*
		{
			trace("未实现Service接口",name.toString(),parameters);
			return new Promise(this);
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			// TODO Auto Generated method stub
			delete this.data[name.toString()];
			return true;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			// TODO Auto Generated method stub
			return this.data[name.toString()];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			// TODO Auto Generated method stub
			return (this.data[name.toString()]);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			// TODO Auto Generated method stub
			this.data[name.toString()] = value;
		}
	}
}