package sban.simplemvc.view
{
	import starling.core.Starling;
	import starling.display.Quad;

	/**
	 * 用于快速建模的单色背景 
	 * @author sban
	 * 
	 */	
	public class StarlingSingleColorBackground extends Quad
	{
		public function StarlingSingleColorBackground(color :uint = 0x454545)
		{
			super( Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,color );
		}
	}
}