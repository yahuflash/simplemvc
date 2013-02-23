package us.sban.simplemvc.core.injection
{
	public class ClassMethodDescriptor extends ClassMemberDescriptor
	{
		public function ClassMethodDescriptor(){}
		public var parameters:Array = [];

		override public function parse(xml:XML):ClassMemberDescriptor
		{
			name = xml.@name;
			super.parse(xml);

			for each(var parameterXml:XML in xml.parameter)
			{
				parameters.push(new ClassMethodParameterDescriptor(parameterXml));
			}
			return this;
		}
	}
}
