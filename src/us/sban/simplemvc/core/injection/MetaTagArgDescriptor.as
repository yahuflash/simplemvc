package us.sban.simplemvc.core.injection
{
	/**
	 * Key-value pair belonging to a metadata tag.
	 */
	public class MetaTagArgDescriptor
	{
		public function MetaTagArgDescriptor(){}
		/**The meta tag argument key*/
		public var key:String;
		/**The meta tag argument value*/
		public var value:String;
		
		/**
		 * @param key The meta tag argument key
		 * @param value The meta tag argument value
		 */
		public function setKeyAndValue(key:String, value:String):MetaTagArgDescriptor{
			this.key = key;
			this.value = value;
			return this;
		}

		/**
		 * Returns a string representation of the meta tag arg
		 */
		public function toString():String
		{
			return "MetaTagArg{key=" + key + ",value=" + value + "}";
		}
	}
}
