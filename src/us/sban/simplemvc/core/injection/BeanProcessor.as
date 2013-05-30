package us.sban.simplemvc.core.injection
{
	import us.sban.simplemvc.core.SimpleObject;

	public class BeanProcessor extends SimpleObject implements IBeanProcessor
	{
		public function BeanProcessor(){}
		public function setUp(targetBean:SimpleBean, beans:SimpleBeanSet):void{}
		public function tearDown(bean:SimpleBean):void{}
	}
}