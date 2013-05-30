package us.sban.simplemvc.core.injection
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import us.sban.simplemvc.core.simplemvc_internal;
	
	use namespace simplemvc_internal;

	public class BeanInjectProcessor extends BeanProcessor
	{
		public function BeanInjectProcessor() {}
		private var bindings:SimpleBindingSet;

		override public function setUp(targetBean:SimpleBean, beans:SimpleBeanSet):void
		{
			var target:Object = targetBean.instance;
			if (!target)
				return;

			var classDescriptor:SimpleClassDescriptor = $.injection.classDescriptor(target);
			var injections:Array = classDescriptor.membersByMetaTag(MetaTagKind.INJECT);

			for each (var property:ClassMemberDescriptor in injections)
			{
				var injectTag:MetaTagDescriptor = property.tagByName(MetaTagKind.INJECT);
				var sourceArg:MetaTagArgDescriptor = injectTag.argByKey(MetaTagArgKind.SOURCE);

				var sourceBean:SimpleBean;
				var source:Object;
				var binding:SimpleBinding = null;
				var autoBind:Boolean = true;

				if (sourceArg)
				{
					var splitArg:Array = sourceArg.value.split(".");
					var beanId:String = splitArg.shift();

					sourceBean = beans.getBeanById(beanId);

					var bindArg:MetaTagArgDescriptor = injectTag.argByKey(MetaTagArgKind.BIND);
					var autoArg:MetaTagArgDescriptor = injectTag.argByKey(MetaTagArgKind.AUTO);
					
					var isBound:Boolean;
					
					if (bindArg)
					{
						isBound = bindArg.value == "true";
						
						if (autoArg)
							autoBind = autoArg.value == "true";
					}
					
					source = sourceBean.instance;
					var propName:String;
					
					while (propName = splitArg.shift())
					{
						if (source.hasOwnProperty(propName))
						{
							if (isBound && splitArg.length == 0)
							{
								binding = new SimpleBinding(source, propName, target, property.name);
								$.injection.bindings.addBinding(binding, autoBind);
							}
							
							source = source[propName];
						}
						else
						{
							throw new Error('property not found:'+propName);
						}
					}
				}
				else
				{
					var TempClass:Class = Class(getDefinitionByName(property.classname));
					sourceBean = beans.getBeanByClass(TempClass);

					if (sourceBean)
					{
						source = sourceBean.instance;
					}
					else
					{
						throw new Error('bean not found:'+property.classname);
					}
				}

				if (!binding)
				{
					target[property.name] = source;
				}
			}
		}
	}
}
