package simplemvc.animation
{
	/**动画接口*/
	public interface IAnimation
	{
		/**由系统间隔调用该方法，在该方法中处理动画逻辑*/
		function update(delta:Number):void;
	}
}