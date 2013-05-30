package us.sban.simplemvc.core.injection
{
	import flash.utils.getDefinitionByName;

	public class ClassMethodParameterDescriptor
	{
		public function ClassMethodParameterDescriptor(xml:XML)
		{
			index = int(xml.@index);
			type = getDefinitionByName(xml.@type) as Class;
			optional = xml.@optional == "true";
		}
		
		public var index:int;
		public var type:Class;
		public var optional:Boolean;
	}
}
