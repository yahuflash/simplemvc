package simplemvc.extension.socket
{
	import flash.utils.ByteArray;

	public interface ISocketProxy{
		function connect(host:String,port:int):void;
		function send(data:Object):void;
		function sendBytes(bytes:ByteArray):void;
	}
}