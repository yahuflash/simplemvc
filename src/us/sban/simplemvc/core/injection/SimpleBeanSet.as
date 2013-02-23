package us.sban.simplemvc.core.injection
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import us.sban.simplemvc.core.SimpleObject;
	import us.sban.simplemvc.core.simplemvc_internal;
	
	use namespace simplemvc_internal;

	public class SimpleBeanSet extends SimpleObject
	{
		public function SimpleBeanSet(){setUpProcessors()}
		
		public const beans:Dictionary = new Dictionary(true);
		private const processors:Vector.<IBeanProcessor> = new <IBeanProcessor>[];
		
		public function addBean(bean:SimpleBean):SimpleBeanSet
		{
			if (bean.id){
				beans[bean.id] = bean;
			}else{
				var c:Class = Class(getDefinitionByName(getQualifiedClassName(bean.instance)));
				beans[c] = bean;
			}
			tearUp(bean);
			return this;
		}

		public function removeBean(beanIn:SimpleBean):SimpleBeanSet
		{
			var bean:SimpleBean;
			
			tearDown(beanIn);

			//remove injection from other beans
			for each(bean in beans){
				if (!bean.instance) continue;
				var classDescriptor:SimpleClassDescriptor = $.injection.classDescriptor(bean.instance);
				var injections:Array = classDescriptor.membersByMetaTag(MetaTagKind.INJECT);

				for each(var member:ClassMemberDescriptor in injections){
					if (bean.instance[member.name] == beanIn.instance)
						bean.instance[member.name] = null;
				}
			}

			//delete and release bean
			for (var key:Object in beans)
			{
				bean = beans[key];
				if (bean.instance == beanIn.instance){
					beans[key] = null;
					delete beans[key];
				}
			}
			return this;
		}

		public function getBeanByClass(BeanClass:Class):SimpleBean{
			return beans[BeanClass];
		}

		public function getBeanById(id:String):SimpleBean{
			return beans[id];
		}
		
		public function getBeanByInstance(instance:Object):SimpleBean{
			var bean:SimpleBean;
			for (var key:Object in beans)
			{
				bean = beans[key];
				if (bean.instance == instance){
					return bean;
				}
			}
			return null;
		}
		
		private function tearUp(bean:SimpleBean):void
		{
			var beans:SimpleBeanSet = $.injection.beans;
			var n:int = processors.length;
			for (var j:int = 0; j < n; j++) {
				processors[j].setUp(bean, beans);
			}
		}
		
		private function tearDown(bean:SimpleBean):void
		{
			var n:int = processors.length;
			for (var j:int = 0; j < n; j++) {
				processors[j].tearDown(bean);
			}
		}
		
		private function setUpProcessors():void{
			processors.push(new BeanDispatcherProcessor());
			processors.push(new BeanBindingsProcessor());
			processors.push(new BeanInjectProcessor());
			processors.push(new BeanEventHandlerProcessor());
			processors.push(new BeanPostConstructProcessor());
		}
	}
}
