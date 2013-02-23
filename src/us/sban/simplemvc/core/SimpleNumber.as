package us.sban.simplemvc.core
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import us.sban.simplemvc.util.NumberUtil;
	
	use namespace simplemvc_internal;

	public dynamic final class SimpleNumber extends Proxy implements ISimpleObject
	{
		public function SimpleNumber(){}
		private var value:Number;
		
		public function lessThan(n:Number):Boolean{
			return value < n;
		}
		public function lessThanOrEqual(n:Number):Boolean{
			return value <= n;
		}
		
		public function greaterThan(n:Number):Boolean{
			return value > n;
		}
		public function greaterThanOrEqual(n:Number):Boolean{
			return value >= n;
		}
		
		public function floor():SimpleNumber{
			this.value = NumberUtil.floor(value);
			return this;
		}
		public function mod(m:Number):SimpleNumber{ 
			this.value = NumberUtil.mod(value,m);
			return this;
		}
		public function isEven():Boolean{ 
			return NumberUtil.isEven(value);
		}
		public function abs():SimpleNumber{ 
			this.value = NumberUtil.abs(value);
			return this;
		}
		
		public function release():ISimpleObject{
			return $.objects.pushReleased(this) as ISimpleObject;
		}
		
		simplemvc_internal function setValue(value:Number):SimpleNumber {
			this.value = value;
			return this;
		}
		flash_proxy override function callProperty(name:*, ...rest):*{
			var f:Function = this.value[name];
			if(null != f) return f.apply(this, [name].concat(rest));
			return unhandler.apply(this, [name].concat(rest));
		}
		
		protected function unhandler(method:String, ...rest):SimpleNumber{return this;}
		
		public function valueOf():Number{
			return this.value;
		}
		public function toString():String{
			return this.value.toString();
		}
		public function print():SimpleNumber{
			trace(this.toString());
			return this;
		}
		
		
	}
}