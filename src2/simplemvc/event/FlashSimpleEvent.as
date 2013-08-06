package simplemvc.event
{
	import flash.events.Event;
	
	public final class FlashSimpleEvent extends Event
	{
		public function FlashSimpleEvent(type:String, args:Object=null)
		{
			super(type);
			this.args = args;
		}
		
		public var args :Object;
	}
}