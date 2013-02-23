package us.sban.simplemvc.core.injection
{
	import us.sban.simplemvc.core.ISimpleObject;

	public interface IBeanProcessor extends ISimpleObject
	{
		function setUp(targetBean:SimpleBean, beans:SimpleBeanSet):void;
		function tearDown(bean:SimpleBean):void;
	}
}