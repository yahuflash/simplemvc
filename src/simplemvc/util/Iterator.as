package simplemvc.util
{
	public class Iterator
	{
		/**
		 * 集合迭代器
		 * @param source Array or Vector
		 */		
		public function Iterator(source : Object){
			this.source = source;
		}
		
		protected var cursor:int=0;
		protected var source : Object;
		
		public function get count():int{
			return source.length;
		}
		
		public function reset():void{
			cursor = 0;
		}
		
		public function hasNext():Boolean{
			return cursor < source.length;
		}
		
		public function next():Object{
			return source[cursor++];
		}
	}
}