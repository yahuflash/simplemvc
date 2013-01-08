package sban.simplemvc.control
{
	import sban.simplemvc.core.ISimpleObject;
	import sban.simplemvc.core.Promise;

	public interface IControl extends ISimpleObject
	{
		function get view():Object;
		function navigateTo(location:String):Promise;
	}
}