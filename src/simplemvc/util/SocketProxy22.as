package simplemvc.util
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import simplemvc.event.SimpleEvent;

	/**
	 * 以2(message id)+2(data.length)+data的方式设计数据包
	 *  
	 * @author sban
	 * 
	 */	
	public final class SocketProxy22 extends SocketProxy
	{
		/**
		 * 在收到2+2+data数据时派发
		 * args:[mid:int,data:ByteArray] 一个完整的包数据，包头在其内
		 */
		public static const SOCKET22_DATA :String = "socket22Data";
		
		/**2+2，包头是4个字节*/
		public static const HEADER_SIZE:uint = 4;
		
		public function SocketProxy22(useZlib:Boolean=false)
		{
			super(useZlib);
		}
		
		public function send22(messageId:int, data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var pack:ByteArray = new ByteArray();
			pack.writeShort(messageId);
			data.position=0;
			pack.writeShort(data.bytesAvailable);
			pack.writeBytes(data);
			
			this.send(pack);
		}
		
		override public function unpack(bytes:ByteArray):ByteArray
		{
			// TODO Auto Generated method stub
			var r:ByteArray;
			if (bytes.length > HEADER_SIZE)
			{
				var mid :uint = bytes.readShort();	
				var len :uint = bytes.readShort();
				var packetLen :uint = HEADER_SIZE + len;
				
				//trace("bytesBuffer.length",bytesBuffer.length,len,HEADER_LENGTH);
				if (bytes.length >= packetLen)
				{
					//trace("message id", mid);
					r = new ByteArray();
					bytes.readBytes(r, 0, len);
					r.position=0;
					
					dispatchEvent( new SimpleEvent(SOCKET22_DATA, mid, r) );
				}
			}
			return r;
		}
		
	}
}