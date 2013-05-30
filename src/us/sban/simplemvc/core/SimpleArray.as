package us.sban.simplemvc.core
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace simplemvc_internal;
	
	public dynamic final class SimpleArray extends Proxy implements ISimpleObject
	{
		public function SimpleArray(){}
		
		private var value:Array;
		
		public function release():ISimpleObject{
			this.value = null;
			return $.objects.pushReleased(this) as ISimpleObject;
		}
		
		public function clear():SimpleArray{value.length=0;return this;};
		
		public function allFuncReturnOf(value:Object):Boolean{
			var rtn:Boolean = false;
			this.value.some(
				function(f:Function,index:int=-1,arr:Array=null):Boolean{
					if(f() != value) return (rtn = true);
					return false;
				}
			);
			return !rtn;
		}
		
		public function contains(item:Object):Boolean{
			return this.value.indexOf(item) > -1;
		}
		
		simplemvc_internal function setValue(value:Array):SimpleArray {
			this.value = value;
			return this;
		}
		
		flash_proxy override function callProperty(name:*, ...rest):*{
			var f:Function = this.value[name];
			if(null != f) return f.apply(this, [name].concat(rest));
			return unhandler.apply(this, [name].concat(rest));
		}
		
		protected function unhandler(method:String, ...rest):SimpleArray{return this;}
		
		public function valueOf():Array{
			return this.value;
		}
		public function toString():String{
			return this.value.toString();
		}
		public function print():SimpleArray{
			trace(this.toString());
			return this;
		}
	}
}