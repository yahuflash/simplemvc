package us.sban.simplemvc.core.injection
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import us.sban.simplemvc.core.SimpleObject;
	import us.sban.simplemvc.core.simplemvc_internal;
	
	use namespace simplemvc_internal;
	
	public final class SimpleInjection extends SimpleObject
	{
		public function SimpleInjection(){}
		
		public const beans:SimpleBeanSet = new SimpleBeanSet();
		public const bindings:SimpleBindingSet = new SimpleBindingSet();
		
		public function setUp(stage:Stage):void{
			stage.addEventListener(Event.ADDED, eventHandler);
		}
		
		private function eventHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			switch(event.type)
			{
				case Event.ADDED:
				{
					registerBean(event.target);
					break;
				}
				case Event.REMOVED:
				{
					releaseBean(event.target);
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		public function registerBean(instance:Object,id:String=null):SimpleBean{
			var bean:SimpleBean = ($.objects.createNew(SimpleBean) as SimpleBean).setInstance(instance);
			if(id) bean.id = id;
			beans.addBean(bean);
			return bean;
		}
		public function releaseBean(instance:Object):Boolean{
			var bean:SimpleBean = beans.getBeanByInstance(instance);
			if(bean){
				beans.removeBean(bean);
				bean.release();
				return true;
			}
			return false;
		}
		
		public function classDescriptor(object:Object):SimpleClassDescriptor{
			const classDescriptorCache:Dictionary = new Dictionary();
			var classDescriptor:SimpleClassDescriptor;
			if (classDescriptorCache[object.constructor]){
				classDescriptor = classDescriptorCache[object.constructor];
			}else{
				classDescriptor = new SimpleClassDescriptor().describe(object);
				classDescriptorCache[object.constructor] = classDescriptor;
			}
			return classDescriptor;
		}
	}
}