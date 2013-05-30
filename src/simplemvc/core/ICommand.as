package simplemvc.core
{
	public interface ICommand extends IReusable
	{
		function execute():Promise;
	}
}