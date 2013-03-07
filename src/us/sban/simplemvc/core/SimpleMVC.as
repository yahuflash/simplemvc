package us.sban.simplemvc.core
{
	import us.sban.simplemvc.core.injection.SimpleBean;
	import us.sban.simplemvc.core.injection.SimpleInjection;
	import us.sban.simplemvc.model.SimpleModel;
	import us.sban.simplemvc.service.SimpleService;
	import us.sban.simplemvc.view.SimpleView;

	use namespace simplemvc_internal;
	/**
	 * 
	 * @author sban
	 * 
	 */	
	public final class SimpleMVC extends SimpleObject
	{
		public function SimpleMVC(){}
		
		public const objects:SimpleObjectPool = new SimpleObjectPool();
		override public function release():ISimpleObject{
			objects.release();
			return this;
		}
		public function color(argb:uint):SimpleColor{return objects.createNew(SimpleColor).setValue(argb);}
		public function array(a:Array):SimpleArray{return objects.createNew(SimpleArray).setValue(a);}
		public function arr(a:Array):SimpleArray{return array(a);}
		public function string(s:String):SimpleString{return objects.createNew(SimpleString).setValue(s);}
		public function str(s:String):SimpleString{return string(s);}
		public function number(n:Number):SimpleNumber{return objects.createNew(SimpleNumber).setValue(n);}
		public function n(n:Number):SimpleNumber{return number(n);}
		public function event(type:String):SimpleEvent{return objects.createNew(SimpleEvent).setType(type);}
		public function e(type:String):SimpleEvent{return event(type);}
		public function f(f:Function):SimpleFunction{return objects.createNew(SimpleFunction).setValue(f);}
		public function error(message:String):SimpleError{return objects.createNew(SimpleError).setMessage(message);}
		public function err(message:String):SimpleError{return error(message);}
		
		public function freezef(f:Function):Function{
			return function(...args):Function{
				return function():void{
					f.apply(null, args);
				}
			}
		}
		
		public function eventDispatcher():SimpleEventDispatcher{
			return objects.createNew(SimpleEventDispatcher) as SimpleEventDispatcher;
		}
		/**return a new SimpleEventHandlers*/		
		public function eventHandlers(target:ISimpleEventDispatcher):SimpleEventHandlers{
			return ($.objects.createNew(SimpleEventHandlers) as SimpleEventHandlers).setTarget(target).open();
		}
		public const globalDispatcher:SimpleEventDispatcher = new SimpleEventDispatcher;
		
		public const injection:SimpleInjection = new SimpleInjection();
		public function bean(instance:Object):SimpleBean{
			var bean:SimpleBean = injection.beans.getBeanByInstance(instance);
			if(!bean) bean = ($.objects.createNew(SimpleBean) as SimpleBean).setInstance(instance);
			return bean;
		}
		
		public function get application():ISimpleApplication{return SimpleApplication.application;}
		public function get app():ISimpleApplication{return application;}
	}
}