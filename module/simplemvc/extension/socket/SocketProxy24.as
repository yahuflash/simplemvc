package simplemvc.extension.socket
{
	import flash.utils.ByteArray;
	
	/**
	 * 以4(message id)+4(data.length)+data的方式设计数据包
	 *  
	 * @author sban
	 * 
	 */	
	public final class SocketProxy24 extends SocketProxy
	{
		/**2+4，包头是6个字节*/
		public static const HEADER_SIZE:uint = 6;
		
		public function SocketProxy24(useZlib:Boolean=false)
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
			pack.writeInt(body.bytesAvailable);
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
				var len :uint = bytes.readInt();
				var packetLen :uint = HEADER_SIZE + len;
				
				//trace("bytesBuffer.length",bytesBuffer.length,len,HEADER_LENGTH);
				if (bytes.length >= packetLen)
				{
					//trace("message id", mid);
					r = new ByteArray();
					bytes.readBytes(r, 0, len);
					r.position=0;
					
					SocketModule.sharedSocketModule().dispatcher().dispatchWith(SocketModule.SOCKET_RESPONSE,{type:SocketModule.SOCKET_PACKAGE_TYPE_2_4,data:{mid:mid,body:r}});
				}
			}
			return r;
		}
		
	}
}