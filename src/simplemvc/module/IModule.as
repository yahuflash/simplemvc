package simplemvc.module
{
	import simplemvc.event.SimpleEventDispatcher;
	import simplemvc.parser.ModuleXMLData;

	public interface IModule{
		function getName():String;
		function getDefinination():String;
		function init(data:ModuleXMLData):void;
		function moduleDispatcher():SimpleEventDispatcher;
	}
}