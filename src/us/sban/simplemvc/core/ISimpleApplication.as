package us.sban.simplemvc.core
{
	import us.sban.simplemvc.controller.ISimpleController;
	import us.sban.simplemvc.model.SimpleModel;
	import us.sban.simplemvc.service.SimpleService;
	import us.sban.simplemvc.view.ISimpleView;

	public interface ISimpleApplication extends ISimpleObject
	{
		function get m():SimpleModel;
		function get v():ISimpleView;
		function get c():ISimpleController;
		function get s():SimpleService;
		
		function init(m:SimpleModel,v:ISimpleView,c:ISimpleController,s:SimpleService):void;
	}
}