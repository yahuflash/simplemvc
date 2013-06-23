package simplemvc.common
{
	import simplemvc.util.XMLUtil;

	public final class AsyncDataObject implements IXMLSerializable,IReusable
	{
		public static function create():AsyncDataObject{
			return (ObjectPool.sharedObjectPool().retrieveNew(AsyncDataObject) as AsyncDataObject);
		}
		
		public static const NAME:String = "asyncData";
		
		public function AsyncDataObject(){}
		
		/**0:默认，－1×：错误，1：成功*/
		public var status:int = 0;
		/**map对象或自定义的ValueObject*/
		public var result:Object=null;
		/**当status<0时，存在error不为空*/
		public var error:ErrorObject=null;
		
		public function parseFromXML(data:XML):void{
			this.status = parseInt(data.status);
			if (undefined != data.result) this.result = XMLUtil.xmlToObject(data.result);
			if (undefined != data.error) (error ||= new ErrorObject).parseFromXML(data.error);
		}
		
		public function toXML():XML{
			var r:XML = <{NAME}><status>{status}</status></{NAME}>;
			if(result) r.appendChild( XMLUtil.objectToXML("result",result) );
			if(error) r.appendChild( error.toXML() );
			return r;
		}
		
		public function release():void{
			result=null;
			error=null;
			status=0;
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
		
		
	}
}