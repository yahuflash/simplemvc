package simplemvc.module
{
	import flash.utils.getDefinitionByName;
	import simplemvc.parser.ModuleXMLData;
	

	public final class ModuleFactory{
		
		public static function createModule(moduleData:ModuleXMLData):IModule{
			var r:IModule;
			var c:Class = getDefinitionByName(moduleData.definition) as Class;
			if (c){
				r = new c();
				r.init(moduleData);
			}
			
			return r;
		}
		public function ModuleFactory()
		{
		}
	}
}