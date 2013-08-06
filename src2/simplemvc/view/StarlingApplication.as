package simplemvc.view
{
	import simplemvc.common.simplemvc_internal;
	
	use namespace simplemvc_internal;

	public final class StarlingApplication
	{
		simplemvc_internal static var _navigator:IScreenNavigator;
		
		public static function get navigator():IScreenNavigator{
			return _navigator;
		}

	}
}