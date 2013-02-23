package us.sban.simplemvc.core.injection
{
	/**
	 * Class for metadata tags on a class member
	 */
	public class MetaTagDescriptor
	{
		public function MetaTagDescriptor(){}
		
		/**All arguments on the tag*/
		private const args:Array = [];
		/**The tag name*/
		public var name:String;

		/**
		 * @param name The tag name
		 */
		public function setNameAndArgXMLList(name:String, argXmlList:XMLList):MetaTagDescriptor{
			this.name = name;
			for each(var argXml:XML in argXmlList){
				args.push(new MetaTagArgDescriptor().setKeyAndValue(argXml.@key, argXml.@value));
			}
			return this;
		}

		/**
		 * Retrieve an arg by name
		 *
		 * @param name The name to search for
		 */
		public function argByKey(key:String):MetaTagArgDescriptor
		{
			for each(var arg:MetaTagArgDescriptor in args)
			{
				if (arg.key == key)
					return arg;
			}

			return null;
		}

		/**
		 * Returns a string representation of the meta tag
		 */
		public function toString():String
		{
			return "MetaTag{ name:" + name + ",args:" + args + " }";
		}
	}
}
