package sban.simplemvc.event
{
	import sban.simplemvc.interfaces.IDisposable;
	import sban.simplemvc.interfaces.IPrintable;

	internal final class SimpleEventHandlerList implements IPrintable, IDisposable
	{
		public static const NIL:SimpleEventHandlerList = new SimpleEventHandlerList(null, null);

		public function SimpleEventHandlerList(head:SimpleEventHandler, tail:SimpleEventHandlerList = null)
		{
			if (!head && !tail)
			{
				if (NIL) 
					throw new ArgumentError('Parameters head and tail are null. Use the NIL element instead.');
					
				//this is the NIL element as per definition
				NonEmpty = false;
			}
			else if (!head)
			{
				throw new ArgumentError('Parameter head cannot be null.');
			}
			else
			{
				this.Head = head;
				this.Tail = tail || NIL;
				NonEmpty = true;
			}
		}

		// Although those variables are not const, they would be if AS3 would handle it correctly.
		public var Head:SimpleEventHandler;
		public var Tail:SimpleEventHandlerList;
		public var NonEmpty:Boolean = false;

		private function prepend(slot:SimpleEventHandler):SimpleEventHandlerList
		{
			return new SimpleEventHandlerList(slot, this);
		}	
		
		public function InsertWithPriority(handler:SimpleEventHandler):SimpleEventHandlerList
		{
			if (!NonEmpty) return new SimpleEventHandlerList(handler);

			const priority:int = handler.Priority;
			// Special case: new slot has the highest priority.
			if (priority > this.Head.Priority && handler.Type == Head.Type) return prepend(handler);

			const result:SimpleEventHandlerList = new SimpleEventHandlerList(Head);
			var next:SimpleEventHandlerList = result;
			var current:SimpleEventHandlerList = Tail;

			// Find a slot with lower priority and go in front of it.
			while (current.NonEmpty){
				if (priority > current.Head.Priority && handler.Type == current.Head.Type){
					next.Tail = current.prepend(handler);
					return result; 
				}			
				next = next.Tail = new SimpleEventHandlerList(current.Head);
				current = current.Tail;
			}

			// Slot has lowest priority.
			next.Tail = new SimpleEventHandlerList(handler);
			return result;
		}
		
		public function FilterNotWithTypeAndListener(type:String,listener:Function):SimpleEventHandlerList
		{
			if (!NonEmpty) return this;
			
			var current:SimpleEventHandlerList = this;//用于控制循环的当前对象引用
			var next:SimpleEventHandlerList;//采用的下一个对象引用
			while(current.NonEmpty) {
				if (current.Head.Type != type && current.Head.Listener != listener) {
					if (!result){
						const result:SimpleEventHandlerList = new SimpleEventHandlerList(current.Head);
						next = result;
					}else{
						next.Tail = new SimpleEventHandlerList(current.Head);
						next = next.Tail; 
					}
				}
				current = current.Tail;
			}
			
			if (!result) return NIL;
			
			return result;
		}
		
		public function FilterNotWithType(type:String):SimpleEventHandlerList
		{
			if (!NonEmpty) return this;
			
			var current:SimpleEventHandlerList = this;//用于控制循环的当前对象引用
			var next:SimpleEventHandlerList;//采用的下一个对象引用
			while(current.NonEmpty) {
				if (current.Head.Type != type) {
					if (!result){
						const result:SimpleEventHandlerList = new SimpleEventHandlerList(current.Head);
						next = result;
					}else{
						next.Tail = new SimpleEventHandlerList(current.Head);
						next = next.Tail; 
					}
				}
				current = current.Tail;
			}
			
			if (!result) return NIL;

			return result;
		}

		public function FindWith(type:String, listener:Function):SimpleEventHandler
		{
			if (!NonEmpty) return null;

			var p:SimpleEventHandlerList = this;
			while (p.NonEmpty)
			{
				if (p.Head.Listener == listener && p.Head.Type === type) return p.Head;
				p = p.Tail;
			}

			return null;
		}
		
		public function Dispose():void
		{
			// TODO Auto Generated method stub
			Tail = NIL;
			NonEmpty = false;
		}
		
		
		public function Print():void{
			$.Print("List:");
			if (!NonEmpty) return $.Print("Empty");
			if (Tail == NIL) return  $.Print("Nil");
			
			var result:uint = 0;
			var list:SimpleEventHandlerList = this;
			
			while (list.NonEmpty){
				list.Head.Print();
				list = list.Tail;
			}
		}
		
	}
}
