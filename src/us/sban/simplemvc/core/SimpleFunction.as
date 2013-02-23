package us.sban.simplemvc.core
{
	import us.sban.simplemvc.util.StringUtil;

	public final class SimpleFunction extends SimpleObject
	{
		simplemvc_internal static function sortByPriority(x:SimpleFunction, y:SimpleFunction):Number {
			if(x.priority > y.priority)
				return -1;
			else if(x.priority < y.priority)
				return 1;
			return 0;
		}
		
		public function SimpleFunction(){}
		
		private var _priority:int=0;
		private var _args:Array;
		private var value:Function;
		
		simplemvc_internal function setValue(value:Function):SimpleFunction {
			this.value = value;
			return this;
		}
		
		public function valueOf():Function{
			return this.value;
		}
		public function toString():String{
			return StringUtil.format("Function priority:%d", _priority);
		}
		public function print():SimpleFunction{
			trace(this.toString());
			return this;
		}
		
		public function get priority():int{return _priority;}
		
		override public function release():ISimpleObject{
			_priority = 0;
			_args = null;
			return super.release();
		}
		
		public function execute():SimpleFunction{
			this.value.apply(null,_args);
			return this;
		}
		
		public function setArgs(...args):SimpleFunction{
			_args = args;
			return this;
		}
		
		public function setPriority(value:int):SimpleFunction{
			_priority = value;
			return this;
		}
	}
}