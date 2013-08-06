package sban.simplemvc.event 
{
	import sban.simplemvc.interfaces.IPrintable;

	internal final class SimpleEventHandler implements IPrintable
	{
		public function SimpleEventHandler(Type:String, listener:Function, once:Boolean = false, priority:int = 0)
		{
			this.Type = Type;
			this.Listener = listener;
			this.Once = once;
			this.Priority = priority;
		}
		
		public var Listener:Function;
		public var Once:Boolean = false;
		public var Priority:int = 0;
		public var Type:String;
		
		public function Print():void{
			$.Print("Type:",Type,"Priority:",Priority,"Once:",Once, "Listener:", Listener);
		}
		
		
	}
}