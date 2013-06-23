package simplemvc.common
{
	/**应用的导演角色接口*/
	public interface IDirector{
		function isPlaying():Boolean;
		function stop():Object;
		function resume():Object;
	}
}