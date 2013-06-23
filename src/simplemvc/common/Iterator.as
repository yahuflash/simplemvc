package simplemvc.common
{
	/**
	 * array or vector iterator
	 * @author sban
	 * 
	 */	
	public class Iterator implements IReusable
	{
		public static function create(source : Object):Iterator{
			var iterator:Iterator = ObjectPool.sharedObjectPool().retrieveNew(Iterator) as Iterator;
			iterator.source=source;
			return iterator;
		}
		public function Iterator(){}
		
		internal var cursor:int=0;
		internal var source : Object;
		
		public function numItems():int{
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
		
		public function release():void{
			cursor=0;
			source=null;
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
		
	}
}