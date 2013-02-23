package us.sban.simplemvc.core.injection
{
	import us.sban.simplemvc.core.simplemvc_internal;

	use namespace simplemvc_internal;
	public class BeanPreDestroyProcessor extends BeanProcessor
	{
		override public function tearDown(bean:SimpleBean):void
		{
			var target:Object = bean.instance;
			if (!target) return;

			var classDescriptor:SimpleClassDescriptor = $.injection.classDescriptor(target);
			// Handle pre destroys
			var preDestroys:Array = classDescriptor.membersByMetaTag(MetaTagKind.PRE_DESTROY);

			for each(var method:ClassMemberDescriptor in preDestroys)
			{
				if (method is ClassMethodDescriptor)
				{
					target[ method.name ]();
				}
			}
		}
	}
}
