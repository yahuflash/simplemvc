package simplemvc.command
{
	import simplemvc.core.IDisposable;
	import simplemvc.core.Promise;
	import simplemvc.util.Iterator;

	public interface ICommandPolicy extends IDisposable
	{
		function start(iterator:Iterator,promise:Promise):void;
	}
}