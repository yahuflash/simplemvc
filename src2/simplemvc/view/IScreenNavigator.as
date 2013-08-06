package simplemvc.view
{
	public interface IScreenNavigator
	{
		function pushScreen(screen:StarlingScreen):void;
		function replaceScreen(screen:StarlingScreen):void;
		function popupScreen():void;
	}
}