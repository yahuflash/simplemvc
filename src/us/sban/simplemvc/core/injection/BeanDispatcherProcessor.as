package us.sban.simplemvc.core.injection
{
	import us.sban.simplemvc.core.ISimpleEventDispatcher;
	import us.sban.simplemvc.core.simplemvc_internal;
	
	use namespace simplemvc_internal;

	public class BeanDispatcherProcessor extends BeanProcessor
	{
		public function BeanDispatcherProcessor() {}

		override public function setUp(targetBean:SimpleBean, beans:SimpleBeanSet):void
		{
			var target:Object = targetBean.instance;
			if (!target) return;

			var classDescriptor:SimpleClassDescriptor = $.injection.classDescriptor(target);
			var dispatchers:Array = classDescriptor.membersByMetaTag(MetaTagKind.DISPATCHER);

			for each(var taggedDispatcher:ClassMemberDescriptor in dispatchers){
				target[ taggedDispatcher.name ] = $.globalDispatcher;
			}
		}
	}
}
