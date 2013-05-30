package us.sban.simplemvc.view
{
	import us.sban.simplemvc.core.ISimpleEventDispatcher;
	
	public interface ISimpleView extends ISimpleEventDispatcher
	{
		function get ui():Object;
	}
}