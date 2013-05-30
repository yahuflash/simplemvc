package us.sban.simplemvc.core.injection
{
	import us.sban.simplemvc.core.simplemvc_internal;

	use namespace simplemvc_internal;
	public class BeanPostConstructProcessor extends BeanProcessor
	{
		override public function setUp(targetBean:SimpleBean, beans:SimpleBeanSet):void
		{
			var target:Object = targetBean.instance;
			if (!target) return;

			var classDescriptor:SimpleClassDescriptor = $.injection.classDescriptor(target);
			// Handle post constructs
			var postConstructs:Array = classDescriptor.membersByMetaTag(MetaTagKind.POST_CONSTRUCT);

			for each(var method:ClassMemberDescriptor in postConstructs)
			{
				if (method is ClassMethodDescriptor)
				{
					target[ method.name ]();
				}
			}
		}
	}
}
