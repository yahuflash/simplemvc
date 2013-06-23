package simplemvc.parser
{
	import flash.utils.Dictionary;

	public final class ModuleXMLData{
		public function ModuleXMLData()
		{
		}
		
		public var name:String;
		public var definition:String;
		public var setting:Dictionary= new Dictionary();
		public var events:Vector.<EventXMLData> = new Vector.<EventXMLData>();
		
		public function parse(data:XML):void{
			name = data.@name;
			definition = data.@definition;
			for each(var settingItemName:XML in (data.setting as XML).children()){
				setting[settingItemName] = data.setting[settingItemName].valueOf();
			}
			for each(var eventXML:XML in data.events.event){
				var eventData:EventXMLData = new EventXMLData();
				eventData.parse(eventXML);
				events.push( eventData );
			}
		}
	}
}