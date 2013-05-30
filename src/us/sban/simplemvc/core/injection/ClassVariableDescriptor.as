package us.sban.simplemvc.core.injection
{
	/**
	 * Class for variables within a class
	 */
	public class ClassVariableDescriptor extends ClassMemberDescriptor
	{
		public function ClassVariableDescriptor(){}

		/**
		 * Returns a string representation of the variable
		 */
		public function toString():String
		{
			return "Variable{ name:" + name + ",classname:" + classname + ",tags:" + tags + " }";
		}
	}
}
