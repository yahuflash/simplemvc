package us.sban.simplemvc.core
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import us.sban.simplemvc.util.NumberUtil;
	
	use namespace flash_proxy;
	use namespace simplemvc_internal;
	
	/*
	var obj1:object = $(obj);
	var clicker:Function=function(e:Event):void
	{
	trace('click..');
	};
	// add another listener
	// (without removing previous one)
	obj1.events.click += clicker + $(function(...args):void{trace(args);})(1,2,3);
	obj1.events.click();
	// remove all obj click listeners 
	obj1.events.click -= 0+clicker;
	// remove all obj listeners added
	obj1.events.removeAll();
	*/
	
	/**
	 * 
	 * 
	 * 修改自Fingers<http://filimanjaro.com/fingers/>
	 * 感谢Filip Zawada
	 *  
	 * @author sban
	 * 
	 */	
	public dynamic class SimpleEventHandlers extends Proxy  implements ISimpleObject
	{
		private static const defaultValueOf:Function = Function.prototype.valueOf;
		private static const operatedFunctions:Vector.<Function> = new Vector.<Function>();
		
		private static const extendedValueOf:Function = function():Number
		{
			operatedFunctions.push(this);
			var r:Number = 1 << (operatedFunctions.length - 1);//1,4,8,16
			return r;
		};
		
		public function SimpleEventHandlers(){}
		
		private var target:ISimpleEventDispatcher;
		
		public function release():ISimpleObject{
			target = null;
			return $.objects.pushReleased(this) as ISimpleObject;
		}
		
		simplemvc_internal function setTarget(target:ISimpleEventDispatcher):SimpleEventHandlers{
			this.target = target;
			return this;
		}
		
		simplemvc_internal function open():SimpleEventHandlers
		{
			Function.prototype.valueOf = extendedValueOf;
			return this;
		}
		
		flash_proxy override function getProperty(name:*):*
		{
			return 0;
		}
		
		flash_proxy override function setProperty(name:*, value:*):void
		{
			Function.prototype.valueOf = defaultValueOf;
			name = name.localName;
			
			if (value == null)
			{
				target.removeEventListeners(name);
			}else if (value is Function)
			{
				target.removeEventListeners(name);
				target.addEventListener(name, value);
			} else if (value is int)
			{
				var abs:int = NumberUtil.abs(value);
				var k:int;
				for (var i:int = 0; i < operatedFunctions.length; i++)
				{
					k = 1 << i;
					if ( (abs & k) == k)
					{
						if(value > 0)
							target.addEventListener(name, operatedFunctions[i]);
						else
							target.removeEventListener(name, operatedFunctions[i]);
					}
				}
				operatedFunctions.splice(0,operatedFunctions.length);
			} else
			{
				throw new IllegalOperationError("Unexpected value");
			}
		}
		
		public function clear():SimpleEventHandlers
		{
			Function.prototype.valueOf = defaultValueOf;
			target.removeEventListeners();
			return this;
		}
		
		flash_proxy override function callProperty(name:*, ...args):*
		{
			Function.prototype.valueOf = defaultValueOf;
			target.dispatchEventWith.apply(target, [name].concat(args));
		}
	}
}