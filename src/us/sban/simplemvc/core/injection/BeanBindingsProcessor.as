package us.sban.simplemvc.core.injection
{
	import us.sban.simplemvc.core.simplemvc_internal;

	use namespace simplemvc_internal;
	
	public class BeanBindingsProcessor extends BeanProcessor
	{
		public function BeanBindingsProcessor() {}

		override public function setUp(targetBean:SimpleBean, beans:SimpleBeanSet):void
		{
			var target:Object = targetBean.instance;
			if (!target) return;

			var classDescriptor:SimpleClassDescriptor = $.injection.classDescriptor(target);
			var bindingMembers:Array = classDescriptor.membersByMetaTag(MetaTagKind.BINDINGS);

			for each(var taggedBinding:ClassMemberDescriptor in bindingMembers)
			{
				target[ taggedBinding.name ] = $.injection.bindings;
			}
		}
	}
}
