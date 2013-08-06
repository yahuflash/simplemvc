package simplemvc.common
{

	/**
	 * 方法执行域对象
	 * 包括执行方法体及参数
	 *  
	 * @author sban
	 * 
	 */	
	public final class HandlerObject implements IReusable{
		public static function create(withFunc:Function,andArgs:Array=null):HandlerObject{
			return ObjectPool.sharedObjectPool().retrieveNew(HandlerObject).init(withFunc,andArgs);
		}
		
		public function init(withFunc:Function,andArgs:Array=null):HandlerObject{
			func=withFunc;
			args=andArgs;
			return this;
		}
		
		public var func:Function;
		public var args:Array;
		
		public function call():HandlerObject{
			func.apply(null,args);
			return this;
		}
		
		public function release():void{
			func=null;
			args=null;
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
		
	}
}