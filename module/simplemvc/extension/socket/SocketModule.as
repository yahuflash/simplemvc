package simplemvc.extension.socket
{
	import flash.utils.ByteArray;
	
	import simplemvc.event.SimpleEvent;
	import simplemvc.module.Module;
	import simplemvc.parser.ModuleXMLData;

	public final class SocketModule extends Module{
		
		/**
		 * 在收到data数据时派发，例如对于2-2类型：
		 * args:{type:"2-2",data:{mid:int,body:ByteArray}} 一个完整的包数据，mid在其内
		 */
		public static const SOCKET_RESPONSE :String = "socketResponse";
		/**
		 * 其它模块以该事件请求发送socket数据包，例如对于2-2类型：
		 * args:{type:"2-2",data:{mid:int,body:ByteArray}}
		 * 
		 * type可选类型：
		 * 1: 2-2,
		 * 2: 0-0（代表直接发送bytes）
		 * */
		public static const SOCKET_REQUEST :String = "socketRequest";
		public static const NAME:String = "socket";
		
		public static const SOCKET_REQUEST_TYPE:String = "0-0";
		
		private static var instance:SocketModule;
		public static function sharedSocketModule():SocketModule{
			return instance;
		}
		
		public function SocketModule(){
			name = NAME;
			if(!instance) instance=this;
		}
		
		private var socket:SocketProxy;
		
		override public function init(data:ModuleXMLData):void{
			name=NAME;
			super.init(data);
			var type:String = data.setting.type;
			switch(type)
			{
				case SocketProxy22.TYPE:
				{
					socket = new SocketProxy22();
					socket.connect( data.setting.host,parseInt(data.setting.port) );
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			SocketModule.sharedSocketModule().moduleDispatcher().listenTo(SOCKET_REQUEST, socketHandler);
		}
		
		private function socketHandler(e:SimpleEvent):void{
			var args:Object = e.args;
			var type:String = args.type;
			switch(type)
			{
				case SocketProxy22.TYPE:
				{
					//send {mid:int,body:ByteArray}
					socket.send(args.data);	
					break;
				}
				case SOCKET_REQUEST_TYPE:
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