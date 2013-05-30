package simplemvc.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import simplemvc.core.IDisposable;
	
	/**
	 * 远端Socket服务器代理基类
	 * 与具体的解包，发包逻辑无关，仅实现基本的连接，收包，断开，异常管理等
	 *  
	 * @author sban
	 * 
	 */	
	public class SocketProxy extends Socket implements IDisposable
	{
		public function SocketProxy(useZlib :Boolean = false){
			this.useZlib = useZlib;
			this.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
			this.addEventListener(Event.CONNECT, eventHandler);
			this.addEventListener(Event.CLOSE, eventHandler);
			this.addEventListener(ProgressEvent.SOCKET_DATA, eventHandler);
		}
		
		/**接收的数据缓冲数组*/
		private var bytesBuffer : ByteArray = new ByteArray();
		/**如果使用了压缩，用于解压缩的临时包*/
		private var useZlibBytesBuf :ByteArray = new ByteArray();
		private var remainBytesBuffer :ByteArray = new ByteArray();
		private var useZlib :Boolean = false;
		
		public function unpack(bytes:ByteArray):ByteArray{
			return bytes;
		}
		
		/**
		 * 销毁
		 */
		public function dispose():void
		{
			this.removeEventListener(IOErrorEvent.IO_ERROR, eventHandler);
			this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
			this.removeEventListener(Event.CONNECT, eventHandler);
			this.removeEventListener(Event.CLOSE, eventHandler);
			this.removeEventListener(ProgressEvent.SOCKET_DATA, eventHandler);
		}
		
		/**为与服务器端保持一致，发送的包结构与接收的包结构保持一致*/
		public function send(data :ByteArray) : void 
		{
			if(this.connected){
				this.writeBytes( data );
				this.flush();
			}
		}
		
		/**当有数据时，读进缓冲包内*/
		private function readBytesToBuffer():void{
			while(this.bytesAvailable)
			{
				var offset :uint = bytesBuffer.length;
				if (useZlib)
				{
					useZlibBytesBuf.clear();
					this.readBytes(useZlibBytesBuf);
					useZlibBytesBuf.uncompress();
					bytesBuffer.writeBytes(useZlibBytesBuf, bytesBuffer.length);
				}else{
					this.readBytes(bytesBuffer, offset, this.bytesAvailable);
				}
			}
			checkReceivedData();
		}
		
		/**当有数据读进来时，检测是否满足包的定义结构，如果满足则从缓冲包中取出来，派发出去*/
		private function checkReceivedData() :void
		{
			//trace("checkReceivedData");
			this.bytesBuffer.position = 0;
			
			var haveRemainBytes :Boolean = false;
			var bytes:ByteArray = unpack(bytesBuffer);
			if(bytes){
				if (bytesBuffer.bytesAvailable > 0)
				{
					remainBytesBuffer.clear();
					bytesBuffer.readBytes(remainBytesBuffer);
					this.bytesBuffer = remainBytesBuffer;
					haveRemainBytes  = true;
				}else{
					this.bytesBuffer.clear();
				}
				
				if(haveRemainBytes)
					checkReceivedData();
			}
		}//end of checkReceivedData
		
		private function eventHandler(e :Event) :void
		{
			switch (e.type)
			{
				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
				case Event.CLOSE:
				case Event.CONNECT:
				{
					//
					break;
				}
				case ProgressEvent.SOCKET_DATA:
				{
					this.readBytesToBuffer();
					break;
				}
			}
		}

		
	}
}
