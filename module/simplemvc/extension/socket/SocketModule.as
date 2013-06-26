package simplemvc.extension.socket
{
	import flash.utils.ByteArray;
	
	import simplemvc.event.SimpleEvent;
	import simplemvc.module.Module;
	import simplemvc.parser.ModuleXMLData;

	public final class SocketModule extends Module{
		
		/**发起连接服务器请求*/
		public static const SOCKET_CONNECT :String = "socketConnect";
		/**在连接上socket服务器时派发，args:{}*/
		public static const SOCKET_CONNECTED :String = "socketConnected";
		/**
		 * 在收到data数据时派发，例如对于2-4类型：
		 * args:{type:"2-4",data:{mid:int,body:ByteArray}} 一个完整的包数据，mid在其内
		 */
		public static const SOCKET_RESPONSE :String = "socketResponse";
		/**
		 * 其它模块以该事件请求发送socket数据包，例如对于2-4类型：
		 * args:{type:"2-4",data:{mid:int,body:ByteArray}}
		 * 
		 * type可选类型：
		 * 1: 2-4,
		 * 2: 0-0（代表直接发送bytes）
		 * */
		public static const SOCKET_REQUEST :String = "socketRequest";
		
		public static const SOCKET_PACKAGE_TYPE_0_0:String = "0-0";
		public static const SOCKET_PACKAGE_TYPE_2_4:String = "2-4";
		/**module name*/
		public static const NAME:String = "socket";
		
		private static var instance:SocketModule;
		public static function sharedSocketModule():SocketModule{
			return instance;
		}
		
		public function SocketModule(){
			name = NAME;
			if(!instance) instance=this;
		}
		
		internal var socket:SocketProxy;
		internal var host:String;
		internal var port:int;
		
		override public function init(data:ModuleXMLData):void{
			name=NAME;
			super.init(data);
			var type:String = data.setting.type;
			switch(type)
			{
				case SOCKET_PACKAGE_TYPE_2_4:
				{
					socket = new SocketProxy24();
					host = data.setting.host;
					port = parseInt(data.setting.port);
					//socket.connect( data.setting.host,parseInt(data.setting.port) );
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			SocketModule.sharedSocketModule().dispatcher().listenTo(SOCKET_REQUEST, socketRequestHandler);
			SocketModule.sharedSocketModule().dispatcher().listenTo(SOCKET_CONNECT, socketHandler);
		}
		
		private function socketHandler(args:Object, e:SimpleEvent):void{
			switch(e.type){
				case SOCKET_CONNECT:
				{
					socket.connect( host,port );
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		private function socketRequestHandler(args:Object,e:SimpleEvent):void{
			var type:String = args.type;
			switch(type)
			{
				case SOCKET_PACKAGE_TYPE_2_4:
				{
					//send {mid:int,body:ByteArray}
					socket.send(args.data);	
					break;
				}
				case SOCKET_PACKAGE_TYPE_0_0:
				{
					socket.sendBytes(args.data as ByteArray);
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
	}
}