package us.sban.simplemvc.core
{
	/**
	 * array or vector iterator
	 * 
	 * @author sban
	 * 
	 */	
	public class Iterator implements IDisposable
	{
		/**
		 *  
		 * @param source Array or Vector
		 * 
		 */		
		public function Iterator(source : Object)
		{
			this.source = source;
		}
		
		private var cursor:int=0;
		private var source : Object;
		
		public function get count():int
		{
			return source.length;
		}
		
		public function reset():void
		{
			cursor = 0;
		}
		
		public function hasNext():Boolean
		{
			return cursor < source.length;
		}
		
		public function next():Object
		{
			return source[cursor++];
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			this.source=null;
		}
		
		
	}
}