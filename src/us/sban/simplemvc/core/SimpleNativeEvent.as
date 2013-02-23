package us.sban.simplemvc.core
{
	import flash.events.Event;
	
	public final class SimpleNativeEvent extends Event
	{
		public function SimpleNativeEvent(type:String)
		{
			super(type);
		}
		
		private var _args:Array;
		
		public function get args():Array{return _args;}
		
		public function setArgs(args:Array):SimpleNativeEvent{
			this._args = args;
			return this;
		}
	}
}