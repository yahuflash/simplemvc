package us.sban.simplemvc.service.proxy
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import us.sban.simplemvc.core.IDisposable;
	import us.sban.simplemvc.core.SimpleEventDispatcher;
	
	
	/**
	 * MID长度为2节字
	 * Length长度为2字节
	 * 整个包头信息长度为4字节
	 * 
	 * 远端Socket服务代理
	 *  
	 * @author sban
	 * 
	 */	
	public final class SocketProxy extends SimpleEventDispatcher implements IDisposable
	{
		public static const SOCKET_DATA="socketData";
		
		public static const single :SocketProxy = new SocketProxy();
		
		public function SocketProxy(idSize:int=2, lenSize:int=2)
		{
			HEADER_ID_SIZE = idSize;
			HEADER_LEN_SIZE = lenSize;
		}
		
		protected var host :String;
		protected var port :uint;
		protected var socket:Socket;
		protected var bytesBuffer : ByteArray = new ByteArray();
		protected var _connected :Boolean;
		protected var useZlib :Boolean = false;
		
		/**
		 * 包头信息中ID的长度，默认1
		 */	
		private var HEADER_ID_SIZE :uint = 2;
		
		/**
		 * 数据包长度信息的长度，默认2
		 */	
		private var HEADER_LEN_SIZE :uint = 2;
		
		/**
		 * 包头信息的长度
		 */		
		protected function get headerSize() :uint
		{
			return HEADER_ID_SIZE + HEADER_LEN_SIZE;
		}
		
		/**
		 * 是否已经成功连接 
		 * @return 
		 * 
		 */		
		public function connected():Boolean
		{
			return _connected;
		}
		
		/**
		 * 初始化，在初始化之前尝试进行一次销毁
		 * 可以重复初始化
		 */
		public function connect(host :String, port :uint, useZlib :Boolean = false) :void
		{
			this.host = host;
			this.port = port;
			this.useZlib = useZlib;
			
			if (socket)
				dispose();
			
			socket = new Socket();
			socket.addEventListener(IOErrorEvent.IO_ERROR, socket_eventHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_eventHandler);
			socket.addEventListener(Event.CONNECT, socket_eventHandler);
			socket.addEventListener(Event.CLOSE, socket_eventHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socket_eventHandler);
			socket.connect(host, port);
		}
		
		/**
		 * 销毁
		 */
		public function dispose():void
		{
			socket.removeEventListener(IOErrorEvent.IO_ERROR, socket_eventHandler);
			socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_eventHandler);
			socket.removeEventListener(Event.CONNECT, socket_eventHandler);
			socket.removeEventListener(Event.CLOSE, socket_eventHandler);
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, socket_eventHandler);
			socket = null;
		}
		
		public function send(mid :int, data :ByteArray) : void 
		{
			if (!_connected)
			{
				//throw new Error("socket is not connected");
				return;
			}
			
			this.socket.writeBytes( getWrapedPacket(mid, data) );
			this.socket.flush();
		}
		
		protected function socket_eventHandler(e :Event) :void
		{
			switch (e.type)
			{
				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
				{
					this.dispatchEventWith(e.type);
					break;
				}
				case Event.CONNECT:
				{
					_connected = true;
					this.dispatchEventWith(e.type);
					//new SimpleEvent(SimpleEvent.CONNECT).dispatch(this);
					break;
				}
				case Event.CLOSE:
				{
					_connected = false;
					this.dispatchEventWith(e.type);
					break;
				}
				case ProgressEvent.SOCKET_DATA:
				{
					while(socket.bytesAvailable)
					{
						var offset :uint = bytesBuffer.length;
						if (useZlib)
						{
							var bytes :ByteArray = new ByteArray();
							socket.readBytes(bytes);
							bytes.uncompress();
							bytesBuffer.writeBytes(bytes, bytesBuffer.length);
						}else{
							socket.readBytes(bytesBuffer, offset, socket.bytesAvailable);
						}
					}
					checkReceivedData();
					break;
				}
			}
		}
		
		protected function getWrapedPacket(mid :int, data :ByteArray) :ByteArray
		{
			var r :ByteArray = new ByteArray();
			var len :int = data.length;
			
			this.writeMID(r, mid);
			this.writeLength(r, len);
			r.writeBytes(data);
			r.position = 0;
			
			if (useZlib)
				r.compress();
			
			return r;
		}
		
		protected function writeMID(bytes :ByteArray, mid : int) :void
		{
			switch (HEADER_ID_SIZE) 
			{
				case 1:
				{
					bytes.writeByte(mid);
					break;
				}
				case 4:
				{
					bytes.writeInt(mid);
					break;
				}
				case 2:
				default:
				{
					bytes.writeShort(mid);
				}
			}
		}
		
		protected function writeLength(bytes :ByteArray, len : uint) :void
		{
			switch (HEADER_ID_SIZE) 
			{
				case 1:
				{
					bytes.writeByte(len);
					break;
				}
				case 4:
				{
					bytes.writeInt(len);
					break;
				}
				case 2:
				default:
				{
					bytes.writeShort(len);
				}
			}
			
		}
		
		protected function readMID(bytes :ByteArray) : int
		{
			var r :int;
			
			switch (HEADER_ID_SIZE) 
			{
				case 1:
				{
					r = bytes.readByte();
					break;
				}
				case 4:
				{
					r = bytes.readInt();
					break;
				}
				case 2:
				default:
				{
					r = bytes.readShort();
				}
			}
			
			return r;
			
		}
		
		protected function readLength(bytes :ByteArray) : uint
		{
			var r :int;
			
			switch (HEADER_LEN_SIZE) 
			{
				case 1:
				{
					r = bytes.readByte();
					break;
				}
				case 4:
				{
					r = bytes.readInt();
					break;
				}
				case 2:
				default:
				{
					r = bytes.readShort();
				}
			}
			
			return r;
		}
		
		protected function checkReceivedData() :void
		{
			//trace("checkReceivedData");
			this.bytesBuffer.position = 0;
			
			//trace("bytesBuffer.length",bytesBuffer.length);
			if (bytesBuffer.length > headerSize)
			{
				var mid :uint = readMID( bytesBuffer );	
				var len :uint = readLength( bytesBuffer );
				var packetLen :uint = headerSize + len;
				
				//trace("bytesBuffer.length",bytesBuffer.length,len,HEADER_LENGTH);
				if (bytesBuffer.length >= packetLen)
				{
					//trace("SocketProxy comeback id", mid);
					var haveRemainBytes :Boolean = false;
					var bytes :ByteArray = new ByteArray();
					
					bytesBuffer.readBytes(bytes, 0, len);
					
					if (bytesBuffer.length > packetLen)
					{
						var remainBytesBuffer :ByteArray = new ByteArray();
						bytesBuffer.readBytes(remainBytesBuffer);
						this.bytesBuffer = remainBytesBuffer;
						haveRemainBytes  = true;
					}else{
						this.bytesBuffer.clear();
					}
					
					dispatchEventWith(SOCKET_DATA,mid,bytes);
					
					if(haveRemainBytes)
						checkReceivedData();
				}
			}
		}//end of checkReceivedData
		
	}
}
