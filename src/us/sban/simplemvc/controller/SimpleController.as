package us.sban.simplemvc.controller
{
	import us.sban.simplemvc.core.SimpleEventDispatcher;
	import us.sban.simplemvc.core.simplemvc_internal;
	import us.sban.simplemvc.view.ISimpleView;
		
	use namespace simplemvc_internal;
	
	public class SimpleController extends SimpleEventDispatcher implements ISimpleController
	{
		public function SimpleController()
		{
			super();
		}
		
		protected var _view:ISimpleView;
		
		public function setView(view:ISimpleView):void
		{
			// TODO Auto Generated method stub
			_view = view;
		}
		
		public function get view():ISimpleView
		{
			// TODO Auto Generated method stub
			return _view;
		}
		
		public function takeOn():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function teardown():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
	}
}