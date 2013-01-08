package sban.simplemvc.view
{
	import starling.display.Sprite;
	import starling.events.Event;

	public class StarlingView extends Sprite
	{
		public function StarlingView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void
		{
			// TODO Auto Generated method stub
			e.currentTarget.removeEventListener(e.type, arguments.callee);
		}
		
	}
}