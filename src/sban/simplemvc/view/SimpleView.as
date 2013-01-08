package sban.simplemvc.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author sban
	 * 
	 */	
	public class SimpleView extends Sprite
	{
		public function SimpleView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void
		{
			// TODO Auto-generated method stub
			e.currentTarget.removeEventListener(e.type, arguments.callee);
		}		
		
	}
}