package us.sban.simplemvc.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import us.sban.simplemvc.controller.ISimpleController;
	import us.sban.simplemvc.controller.SimpleController;
	import us.sban.simplemvc.model.SimpleModel;
	import us.sban.simplemvc.service.SimpleService;
	import us.sban.simplemvc.view.ISimpleView;
	
	use namespace simplemvc_internal;

	public class SimpleApplication implements ISimpleApplication
	{
		simplemvc_internal static const application:ISimpleApplication = new SimpleApplication;
		
		public function SimpleApplication()
		{
			super();
		}
		protected var _m:SimpleModel;
		protected var _v:ISimpleView;
		protected var _c:ISimpleController;
		protected var _s:SimpleService;
		
		public function get m():SimpleModel{return _m;}
		public function get v():ISimpleView{return _v;}
		public function get c():ISimpleController{return _c;}
		public function get s():SimpleService{return _s;}
		
		public function init(m:SimpleModel,v:ISimpleView,c:ISimpleController,s:SimpleService):void{
			_m = m;
			_v = v;
			_c = c;
			_s = s;
			_c.setView(_v);
		}
		
		public function release():ISimpleObject{
			return this;
		}
	}
}