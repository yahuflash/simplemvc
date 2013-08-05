package sban.simplemvc.event
{
	import flash.events.Event;
	
	public final class SimpleEvent extends Event
	{
		public function SimpleEvent(type:String, ...args)
		{
			super(type);
			this.Args = args;
		}
		
		public var Args:Array;
	}
}