package simplemvc.common
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	
	public final class ObjectPool implements IDisposable
	{
		private static var instance:ObjectPool;
		public static function sharedObjectPool():ObjectPool{
			return (instance ||= new ObjectPool);
		}
		public function ObjectPool(){}
		
		private const runingPool:Vector.<Object> = new <Object>[];
		private const reusePool:Dictionary = new Dictionary();
		
		/**
		 * called by release() 
		 * @param object
		 * @return 
		 * 
		 * @see SimpleObject.release()
		 */		
		public function pushReleased(object:Object):Object{
			(reusePool[object['constructor']] ||= new <Object>[]).push( object );
			var index:int = runingPool.indexOf(object);
			if(index > -1) runingPool.splice(index,1);
			return object;
		}
		
		public function retrieveNew(c:Class):Object{
			var rtn:Object;
			if((reusePool[c] ||= new <Object>[]).length > 0)
				rtn = reusePool[c].shift();
			else
				rtn = new c;
			runingPool.push(rtn);
			return rtn;
		}
		
		public function dispose():void{
			var n:int = runingPool.length;
			while(runingPool.length > 0){
				runingPool.pop().release();
			}
			trace('release objects:'+n);
		}
	}
}