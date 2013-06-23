package simplemvc.util
{
	public final class XMLUtil
	{
		public static function objectToXML(type:String,obj:Object):XML{
			var r:XML = <{type}/>;
			for (var s:String in obj){
				r.appendChild(<{s}>{obj[s]}</{s}>);
			}
			return r;
		}
		public static function xmlToObject(data:XML):Object{
			var r:Object = {};
			for each(var attr:XML in data.attributes()){
				r[attr.localName()] = attr.valueOf();
			}
			for each(var ele:XML in data.children()){
				r[ele.localName()]=ele.valueOf();
			}
			return r;
		}
		
		public function XMLUtil()
		{
		}
		
		
	}
}