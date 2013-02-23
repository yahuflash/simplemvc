package us.sban.simplemvc.service.proxy
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import us.sban.simplemvc.core.SimpleEventDispatcher;
	
	/**
	 * 以远端一个支持amf3协议的服务器作为存储源，封装对其操作方法
	 * 可以使用amfphp,blazeds,fluorineFx等框架在服务器端构建存储源
	 *  
	 * @author art
	 * 
	 */	
	public class AMFProxy extends SimpleEventDispatcher
	{
		public static const NetConnection_Call_Failed :String = "NetConnection.Call.Failed";
		
		public static const single :AMFProxy = new AMFProxy();
		
		public function AMFProxy()
		{
			super();
		}
		
		protected var destination :String = '';
		protected var endpoint :String;
		protected var conn :NetConnection;
		protected var _connected :Boolean = false;
		
		public function get connected():Boolean
		{
			return _connected;
		}
		
		/**
		 * 连接服务器
		 *  
		 * @param endpoint 数据源地址
		 * @param destination 包路径+类名
		 * @param handshakeMethod 握手方法，用于测试连接
		 * 
		 */		
		public function connect(endpoint :String, destination:String,handshakeMethod :String):void
		{
			if(conn)
				conn.removeEventListener(NetStatusEvent.NET_STATUS, conn_netStatusEventHandler);
			
			this.endpoint = endpoint;
			this.destination = destination;
			
			conn = new NetConnection();
			conn.addEventListener(NetStatusEvent.NET_STATUS, conn_netStatusEventHandler);
			conn.connect(endpoint);
			
			this.call(handshakeMethod,new Responder(
				function(data :Object):void
				{
					_connected = true;
					dispatchSimpleEventWith(Event.CONNECT);
				}
			));
		}
		
		//服务器响应失败，将派发如下error
		//Unhandled NetStatusEvent:. level=error, code=NetConnection.Call.Failed
		public function call(name:String, responder :Responder, ...args):void
		{
			var p : Array = [destination+name, responder].concat(args);
			conn.call.apply(conn, p);
		}
		
		protected function conn_netStatusEventHandler(e :NetStatusEvent) :void
		{
			//NetConnection.Call.BadVersion:曾经因为php.ini中的date.timezone未设置而导致该错误出现
			//NetConnection.Call.Failed:
//			trace('amfproxy','e.info["code"]',e.info["code"]);
			if (e.info["level"] == "error" && e.info["code"] == "NetConnection.Call.Failed")
			{
				trace("AMFProxy", e.info["code"]);
//				new SimpleEvent(SimpleEvent.EVENT_ERROR, NetConnection_Call_Failed, e).dispatchIn(this);
			}
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			if (conn)
			{
				conn.removeEventListener(NetStatusEvent.NET_STATUS, conn_netStatusEventHandler);
				conn = null;
			}
		}
		
	}
}