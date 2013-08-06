package simplemvc.module
{
	import simplemvc.event.SimpleEventDispatcher;
	import simplemvc.parser.ModuleXMLData;

	public interface IModule{
		function init(data:ModuleXMLData):void;
		function dispatcher():SimpleEventDispatcher;
	}
}