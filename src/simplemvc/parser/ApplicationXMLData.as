package simplemvc.parser
{

	public final class ApplicationXMLData{
		public function ApplicationXMLData()
		{
		}
		
		public var moduleDatas:Vector.<ModuleXMLData> = new Vector.<ModuleXMLData>();
		
		public function parse(data:XML):void{
			for each(var moduleXML:XML in data.modules.module){
				var moduleData:ModuleXMLData = new ModuleXMLData();
				moduleData.parse( moduleXML );
				moduleDatas.push( moduleData );
			}
		}
	}
}