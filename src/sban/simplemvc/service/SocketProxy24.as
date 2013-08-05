package sban.simplemvc.service
{
	import flash.utils.ByteArray;
	
	import sban.simplemvc.event.SimpleEvent;
	
	/**
	 * 以2字节(message id)+4字节(data.length)+data的方式设计数据包
	 *  
	 * @author sban
	 * 
	 */	
	public final class SocketProxy24 extends SocketProxy
	{
		/**当接收到数据包时派发
		 * args:[mid,body]*/
		public static const SOCKET24_DATA:String = "SOCKET24_DATA";
		
		/**2+4，包头是6个字节*/
		private static const HEADER_SIZE:uint = 6;
		
		public function SocketProxy24(useZlib:Boolean=false)
		{
			super(useZlib);
		}
		
		/**send {mid:int,body:ByteArray} 
		 * */
		override public function Send(...args):void
		{
			var data:Object = args[0];
			var mid:int = data.mid, body:ByteArray = data.body;
			var pack:ByteArray = new ByteArray();
			pack.writeShort(mid);
			body.position=0;
			pack.writeInt(body.length);
			pack.writeBytes(body);
			
			this.sendBytes(pack);
		}
		
		override protected function unpack(bytes:ByteArray):ByteArray
		{
			// TODO Auto Generated method stub
			var r:ByteArray;
			if (bytes.length > HEADER_SIZE)
			{
				var mid :uint = bytes.readShort();
				var len :uint = bytes.readInt();
				var packetLen :uint = HEADER_SIZE + len;
				
				//trace("bytesBuffer.length",bytesBuffer.length,len,HEADER_LENGTH);
				if (bytes.length >= packetLen)
				{
					//trace("message id", mid);
					r = new ByteArray();
					bytes.readBytes(r, 0, len);
					r.position=0;
					
					dispatchEvent( new SimpleEvent(SOCKET24_DATA, mid, r) );
				}
			}
			return r;
		}
		
	}
}