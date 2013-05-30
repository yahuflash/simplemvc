package us.sban.simplemvc.controller
{
	import us.sban.simplemvc.core.ISimpleEventDispatcher;
	import us.sban.simplemvc.view.ISimpleView;
	
	public interface ISimpleController extends ISimpleEventDispatcher
	{
		function get view():ISimpleView;
		function setView(view:ISimpleView):void;
		function takeOn():void;
		function teardown():void;
	}
}