package sban.simplemvc.service
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import sban.simplemvc.interfaces.IServiceProxy;
	
	/**
	 * 远端Socket服务器代理基类
	 * 与具体的解包，发包逻辑无关，仅实现基本的连接，收包，断开，异常管理等
	 *  
	 * @author sban
	 * 
	 */	
	public class SocketProxy extends Socket implements IServiceProxy
	{
		public function SocketProxy(useZlib :Boolean = false){
			endian = Endian.BIG_ENDIAN;
			useZlib = useZlib;
			addEventListener(IOErrorEvent.IO_ERROR, eventHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
			addEventListener(Event.CONNECT, eventHandler);
			addEventListener(Event.CLOSE, eventHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, eventHandler);
		}
		
		/**接收的数据缓冲数组*/
		private var bytesBuffer : ByteArray = new ByteArray();
		/**如果使用了压缩，用于解压缩的临时包*/
		private var useZlibBytesBuf :ByteArray = new ByteArray();
		private var remainBytesBuffer :ByteArray = new ByteArray();
		private var useZlib :Boolean = false;
		
		/**在子类中重写解包逻辑*/
		protected function unpack(bytes:ByteArray):ByteArray{
			return bytes;
		}
		
		/**
		 * 销毁
		 */
		public function Dispose():void
		{
			if (connected) close();
			removeEventListener(IOErrorEvent.IO_ERROR, eventHandler);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
			removeEventListener(Event.CONNECT, eventHandler);
			removeEventListener(Event.CLOSE, eventHandler);
			removeEventListener(ProgressEvent.SOCKET_DATA, eventHandler);
		}
		
		/**初始化
		 * 参数：{host:string, port:int}*/
		public function Init(vars:Object = null):void {
			this.connect( vars.host, vars.port );
		}
		
		/**为与服务器端保持一致，发送的包结构与接收的包结构保持一致*/
		public function Send(...args) : void 
		{
			//override in subclass
		}
		
		/**发送bytes到服务器*/
		protected function sendBytes(bytes:ByteArray):void{
			if(connected){
				writeBytes( bytes );
				flush();
			}
		}
		
		/**当有数据时，读进缓冲包内*/
		private function readBytesToBuffer():void{
			while(bytesAvailable)
			{
				var offset :uint = bytesBuffer.length;
				if (useZlib)
				{
					useZlibBytesBuf.clear();
					readBytes(useZlibBytesBuf);
					useZlibBytesBuf.uncompress();
					bytesBuffer.writeBytes(useZlibBytesBuf, bytesBuffer.length);
				}else{
					readBytes(bytesBuffer, offset, bytesAvailable);
				}
			}
			checkReceivedData();
		}
		
		/**当有数据读进来时，检测是否满足包的定义结构，如果满足则从缓冲包中取出来，派发出去*/
		private function checkReceivedData() :void
		{
			//trace("checkReceivedData");
			bytesBuffer.position = 0;
			
			var haveRemainBytes :Boolean = false;
			var bytes:ByteArray = unpack(bytesBuffer);
			if(bytes){
				if (bytesBuffer.bytesAvailable > 0)
				{
					remainBytesBuffer.clear();
					bytesBuffer.readBytes(remainBytesBuffer);
					bytesBuffer = remainBytesBuffer;
					haveRemainBytes  = true;
				}else{
					bytesBuffer.clear();
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
					trace("socket connected.");
					break;
				}
				case ProgressEvent.SOCKET_DATA:
				{
					readBytesToBuffer();
					break;
				}
			}
		}

		
	}
}
