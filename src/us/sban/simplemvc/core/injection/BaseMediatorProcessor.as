package us.sban.simplemvc.core.injection
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import us.sban.simplemvc.core.simplemvc_internal;
	
	use namespace simplemvc_internal;

	public class BaseMediatorProcessor extends BeanProcessor
	{
		protected function announceToMediators(view:Object, beans:SimpleBeanSet, tag:String):void
		{
			var className:String = getQualifiedClassName(view);
			var ViewClass:Class = Class(getDefinitionByName(className));

			for each(var targetBean:SimpleBean in beans.beans)
			{
				var target:Object = targetBean.instance;
				if (!target) continue;

				var classDescriptor:SimpleClassDescriptor = $.injection.classDescriptor(target);
				var taggedMethods:Array = classDescriptor.membersByMetaTag(tag);

				for each(var method:ClassMethodDescriptor in taggedMethods){
					if (method.parameters.length == 1 && method.parameters[0].type == ViewClass){
						target[method.name](view);
					}
				}
			}
		}
	}
}
