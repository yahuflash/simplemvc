package us.sban.simplemvc.core.injection
{
	/**
	 * Base class for class members
	 */
	public class ClassMemberDescriptor
	{
		public function ClassMemberDescriptor(){}

		/**All tags on the member */
		protected const tags:Array = [];
		/**The member name.*/
		public var name:String;
		/**The member classname.*/
		public var classname:String;
		
		/**
		 * Returns true if a tag with the specified name exists, false is not.
		 *
		 * @param tagName The tag name to search for
		 */
		public function hasTag(tagName:String):Boolean
		{
			for each(var tag:MetaTagDescriptor in tags)
			{
				if (tag.name == tagName)
					return true;
			}

			return false;
		}

		/**
		 * Returns the tag with the specified name
		 *
		 * @param tagName The tag name to search for
		 */
		public function tagByName(tagName:String):MetaTagDescriptor{
			for each(var tag:MetaTagDescriptor in tags){
				if (tag.name == tagName)
					return tag;
			}

			return null;
		}

		public function parse(xml:XML):ClassMemberDescriptor
		{
			name = xml.@name;
			classname = xml.@type;

			for each(var metaDataXml:XML in xml.metadata){
				tags.push(new MetaTagDescriptor().setNameAndArgXMLList(metaDataXml.@name, metaDataXml..arg));
			}
			return this;
		}
	}
}
