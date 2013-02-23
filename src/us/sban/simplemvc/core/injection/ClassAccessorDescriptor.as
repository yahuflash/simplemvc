package us.sban.simplemvc.core.injection
{
	/**
	 * Class for accessors within a class
	 */
	public class ClassAccessorDescriptor extends ClassMemberDescriptor
	{
		public function ClassAccessorDescriptor(){}

		/**
		 * Returns a string representation of the accessor
		 */
		public function toString():String
		{
			return "Accessor{ name:" + name + ",classname:" + classname + ",tags:" + tags + " }";
		}
	}
}
