package simplemvc.extension.socket
{
	import flash.utils.ByteArray;
	
	/**
	 * 以2(message id)+2(data.length)+data的方式设计数据包
	 *  
	 * @author sban
	 * 
	 */	
	public final class SocketProxy22 extends SocketProxy
	{
		public static const TYPE:String = "2-2";
		
		/**2+2，包头是4个字节*/
		public static const HEADER_SIZE:uint = 4;
		
		public function SocketProxy22(useZlib:Boolean=false)
		{
			super(useZlib);
		}
		
		/**send {mid:int,body:ByteArray} 
		 * */
		override public function send(data:Object):void
		{
			var mid:int = data.mid, body:ByteArray = data.body;
			var pack:ByteArray = new ByteArray();
			pack.writeShort(mid);
			body.position=0;
			pack.writeShort(body.bytesAvailable);
			pack.writeBytes(body);
			
			this.sendBytes(pack);
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
					
					SocketModule.sharedSocketModule().moduleDispatcher().dispatchWith(SocketModule.SOCKET_RESPONSE,{type:TYPE,data:{mid:mid,body:r}});
				}
			}
			return r;
		}
		
	}
}