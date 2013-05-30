package us.sban.simplemvc.core
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import us.sban.simplemvc.util.StringUtil;
	
	use namespace simplemvc_internal;

	/**
	 * 
	 * @author sban
	 * 
	 */	
	public dynamic final class SimpleString extends Proxy implements ISimpleObject
	{
		public function SimpleString(){}
		private var value:String;
		
		public function contains(s:String,substr:String,ignoreCase:Boolean=false):Boolean{
			return StringUtil.contains(value,s,ignoreCase);
		}
		public function startWith(substr:String,ignoreCase:Boolean=false):Boolean{
			return StringUtil.startWith(value, substr, ignoreCase);
		}
		public function endWith(substr:String,ignoreCase:Boolean=false):Boolean{
			return StringUtil.endWith(value, substr, ignoreCase);
		}
		public function isNullOrEmpty():Boolean{return StringUtil.isNullOrEmpty(this.value);}
		
		public function format(...args):SimpleString{
			this.value = StringUtil.format(value, args);
			return this;
		}
		
		public function pad(num:int, char:String=" "):SimpleString{
			this.value = StringUtil.pad(value, num, char);
			return this;
		}
		
		public function removeWhitespace():SimpleString{
			this.value = StringUtil.removeWhitespace(value);
			return this;
		}
		
		public function release():ISimpleObject{
			this.value = null;
			return $.objects.pushReleased(this) as ISimpleObject;
		}
		
		simplemvc_internal function setValue(value:String):SimpleString {
			this.value = value;
			return this;
		}
		flash_proxy override function callProperty(name:*, ...rest):*{
			var f:Function = this.value[name];
			if(null != f) return f.apply(this, [name].concat(rest));
			return unhandler.apply(this, [name].concat(rest));
		}
		
		protected function unhandler(method:String, ...rest):SimpleString{return this;}
		
		public function valueOf():String{
			return this.value;
		}
		public function toString():String{
			return this.value;
		}
		public function print():SimpleString{
			trace(this.toString());
			return this;
		}
		
		
	}
}