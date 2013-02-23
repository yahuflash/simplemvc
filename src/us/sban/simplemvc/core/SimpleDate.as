package us.sban.simplemvc.core
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace simplemvc_internal;

	/**
	 * 
	 * @author sban
	 * 
	 */	
	public dynamic final class SimpleDate extends Proxy implements ISimpleObject
	{
		public function SimpleDate(){}
		private var value:Date;
		
		public function release():ISimpleObject{
			this.value = null;
			return $.objects.pushReleased(this) as ISimpleObject;
		}
		
		public function equal(other:Date):Boolean{
			return (value.time == other.time);
		}
		public function after(other:Date):Boolean{
			return (value < other);
		}
		public function afterOrEqual(other:Date):Boolean{
			return (value <= other);
		}
		public function before(other:Date):Boolean{
			return (value > other);
		}
		public function beforeOrEqual(other:Date):Boolean{
			return (value >= other);
		}
		public function betwwn(min:Date, max:Date):Boolean{
			return (value > min) && (value < max);
		}
		
		simplemvc_internal function setValue(value:Date):SimpleDate {
			this.value = value;
			return this;
		}
		flash_proxy override function callProperty(name:*, ...rest):*{
			var f:Function = this.value[name];
			if(null != f) return f.apply(this, [name].concat(rest));
			return unhandler.apply(this, [name].concat(rest));
		}
		
		protected function unhandler(method:String, ...rest):SimpleDate{return this;}
		
		public function valueOf():Date{
			return this.value;
		}
		public function toString():String{
			return this.value.toString();
		}
		public function print():SimpleDate{
			trace(this.toString());
			return this;
		}
	}
}