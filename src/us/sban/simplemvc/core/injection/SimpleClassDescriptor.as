package us.sban.simplemvc.core.injection
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import us.sban.simplemvc.core.ISimpleObject;
	import us.sban.simplemvc.core.SimpleObject;

	/**
	 * Meta class parsing of a real object
	 */
	public class SimpleClassDescriptor extends SimpleObject
	{
		public function SimpleClassDescriptor(){}
		
		/**All accessors within the class*/
		private const accessors:Array = [];
		/**All variables within the class*/
		private const variables:Array = [];
		/**All tags on the class*/
		private const tags:Array = [];
		/**All methods of the class*/
		private const methods:Array = [];
		
		override public function release():ISimpleObject{
			accessors.splice(0,accessors.length);
			variables.splice(0,variables.length);
			tags.splice(0,tags.length);
			methods.splice(0,methods.length);
			return super.release();
		}
		
		public function describe(object:Object):SimpleClassDescriptor{
			var xml:XML = describeType(object);
			for each(var tag:XML in xml.metadata)
				tags.push(new MetaTagDescriptor().setNameAndArgXMLList(tag.@name, tag..arg));
			
			parse(xml..accessor, ClassMemberKind.ACCESSOR);
			parse(xml..variable, ClassMemberKind.VARIABLE);
			parse(xml..method, ClassMemberKind.METHOD);
			return this;
		}

		/**
		 * Retrieve a member by a tag name
		 *
		 * @param tagName The tag name to search for
		 */
		public function membersByMetaTag(tagName:String):Array
		{
			var members:Array = [];
			var member:ClassMemberDescriptor;

			for each(member in accessors){
				if (member.hasTag(tagName))
					members.push(member);
			}

			for each(member in variables){
				if (member.hasTag(tagName))
					members.push(member);
			}

			for each(member in methods){
				if (member.hasTag(tagName))
					members.push(member);
			}

			return members;
		}

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
		public function tagByName(tagName:String):MetaTagDescriptor
		{
			for each(var tag:MetaTagDescriptor in tags)
			{
				if (tag.name == tagName)
					return tag;
			}

			return null;
		}

		private function parse(xmlList:XMLList, kind:String):void
		{
			for each(var itemXml:XML in xmlList)
			{
				switch (kind)
				{
					case ClassMemberKind.ACCESSOR:
						accessors.push(new ClassAccessorDescriptor().parse(itemXml));
						break;
					case ClassMemberKind.METHOD:
						methods.push(new ClassMethodDescriptor().parse(itemXml));
						break;
					case ClassMemberKind.VARIABLE:
						variables.push(new ClassVariableDescriptor().parse(itemXml));
						break;
					default:
						throw new Error("undefined member kind");
						break;
				}
			}
		}
	}
}
