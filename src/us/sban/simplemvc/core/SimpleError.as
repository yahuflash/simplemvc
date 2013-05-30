package us.sban.simplemvc.core
{
	
	public final class SimpleError extends SimpleObject
	{
		public static const ARGUMENT_ERROR :String = "argument error";
		
		private static var ID:int = 0;
		
		/**
		 *  
		 * @param type 错误类型
		 * @param message 错误消息说明
		 * @param level 错误等级
		 * 
		 */		
		public function SimpleError()
		{
			_error = new Error("", ID++);
		}
		
		private var _level:int=0;
		private var _error :Error;
		
		public function get message():String
		{
			return _error.message;
		}
		
		public function get id():int
		{
			return _error.errorID;
		}
		
		public function setMessage(msg:String):SimpleError{
			_error.message = msg;
			return this;
		}
		public function setLevel(level:int):SimpleError{
			_level = level;
			return this;
		}
		
		public function throwOut():void
		{
			throw _error;
		}
	}
}