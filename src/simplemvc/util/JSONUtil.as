package simplemvc.util
{
	public final class JSONUtil
	{
		public static function jsonToObject(json:String):Object{
			return JSON.parse(json);
		}
		public static function objectToJson(obj:Object):String{
			return JSON.stringify(obj);
		}
		
		public function JSONUtil()
		{
		}
	}
}