package us.sban.simplemvc.core.injection
{
	public class BeanViewRemovedProcessor extends BaseMediatorProcessor
	{
		public function process(object:Object, beans:SimpleBeanSet):void
		{
			announceToMediators(object, beans, MetaTagKind.VIEW_REMOVED);
		}

	}
}
