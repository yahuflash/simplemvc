package simplemvc.parser
{
	public final class EventXMLData{
		public function EventXMLData()
		{
		}
		
		public var name:String;
		public var description:String;
		
		public function parse(data:XML):void{
			name = data.@name;
			description = data.description;
		}
	}
}