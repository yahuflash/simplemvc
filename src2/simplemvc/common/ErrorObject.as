package simplemvc.common
{

	public final class ErrorObject implements IXMLSerializable,IReusable
	{
		public static function create():ErrorObject{
			return (ObjectPool.sharedObjectPool().retrieveNew(ErrorObject) as ErrorObject);
		}
		public static const NAME:String = "error";
		
		public function ErrorObject(){}
		
		public var errorCode:int=0;
		public var message:String='';
		
		public function setMessage(v:String):ErrorObject{
			message=v;
			return this;
		}
		
		public function parseFromXML(data:XML):void{
			errorCode = parseInt(data.errorCode);
			message = data.message;
		}
		
		public function toXML():XML{
			return <{NAME}><errorCode>{errorCode}</errorCode><message>{message}</message></{NAME}>;
		}
		
		public function release():void{
			errorCode=0;
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
		
		
	}
}