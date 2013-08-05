package sban.simplemvc.event
{
	internal final class SimpleEventHandlerList
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

		public function Prepend(slot:SimpleEventHandler):SimpleEventHandlerList
		{
			return new SimpleEventHandlerList(slot, this);
		}

		public function Append(slot:SimpleEventHandler):SimpleEventHandlerList
		{
			if (!slot) return this;
			if (!NonEmpty) return new SimpleEventHandlerList(slot);
			// Special case: just one slot currently in the list.
			if (Tail == NIL) 
				return new SimpleEventHandlerList(slot).Prepend(Head);
			
			// The list already has two or more slots.
			// We have to build a new list with cloned items because they are immutable.
			const wholeClone:SimpleEventHandlerList = new SimpleEventHandlerList(Head);
			var subClone:SimpleEventHandlerList = wholeClone;
			var current:SimpleEventHandlerList = Tail;

			while (current.NonEmpty)
			{
				subClone = subClone.Tail = new SimpleEventHandlerList(current.Head);
				current = current.Tail;
			}
			// Append the new slot last.
			subClone.Tail = new SimpleEventHandlerList(slot);
			return wholeClone;
		}		
		
		public function InsertWithPriority(slot:SimpleEventHandler):SimpleEventHandlerList
		{
			if (!NonEmpty) return new SimpleEventHandlerList(slot);

			const priority:int = slot.Priority;
			// Special case: new slot has the highest priority.
			if (priority > this.Head.Priority) return Prepend(slot);

			const wholeClone:SimpleEventHandlerList = new SimpleEventHandlerList(Head);
			var subClone:SimpleEventHandlerList = wholeClone;
			var current:SimpleEventHandlerList = Tail;

			// Find a slot with lower priority and go in front of it.
			while (current.NonEmpty)
			{
				if (priority > current.Head.Priority)
				{
					subClone.Tail = current.Prepend(slot);
					return wholeClone; 
				}			
				subClone = subClone.Tail = new SimpleEventHandlerList(current.Head);
				current = current.Tail;
			}

			// Slot has lowest priority.
			subClone.Tail = new SimpleEventHandlerList(slot);
			return wholeClone;
		}
		
		public function FilterNotWithTypeAndListener(type:String,listener:Function):SimpleEventHandlerList
		{
			if (!NonEmpty || listener == null) return this;

			if (listener == Head.Listener && type == Head.Type) return Tail;

			// The first item wasn't a match so the filtered list will contain it.
			const wholeClone:SimpleEventHandlerList = new SimpleEventHandlerList(Head);
			var subClone:SimpleEventHandlerList = wholeClone;
			var current:SimpleEventHandlerList = Tail;
			
			while (current.NonEmpty)
			{
				if (current.Head.Listener == listener && current.Head.Type == type)
				{
					// Splice out the current head.
					subClone.Tail = current.Tail;
					return wholeClone;
				}
				
				subClone = subClone.Tail = new SimpleEventHandlerList(current.Head);
				current = current.Tail;
			}

			// The listener was not found so this list is unchanged.
			return this;
		}
		
		public function FilterNotWithType(type:String):SimpleEventHandlerList
		{
			if (type == Head.Type) return Tail;
			
			// The first item wasn't a match so the filtered list will contain it.
			const wholeClone:SimpleEventHandlerList = new SimpleEventHandlerList(Head);
			var subClone:SimpleEventHandlerList = wholeClone;
			var current:SimpleEventHandlerList = Tail;
			
			while (current.NonEmpty)
			{
				if (current.Head.Type == type)
				{
					// Splice out the current head.
					subClone.Tail = current.Tail;
					return wholeClone;
				}
				
				subClone = subClone.Tail = new SimpleEventHandlerList(current.Head);
				current = current.Tail;
			}
			
			// The listener was not found so this list is unchanged.
			return this;
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
	}
}
