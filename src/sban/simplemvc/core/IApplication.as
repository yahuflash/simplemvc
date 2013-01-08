package sban.simplemvc.core
{
	import sban.simplemvc.model.SimpleModel;

	public interface IApplication
	{
		function browser(location :String):Promise;
		function get model():SimpleModel;
		function get stack():Stack;
	}
}