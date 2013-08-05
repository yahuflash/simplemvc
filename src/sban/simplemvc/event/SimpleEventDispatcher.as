package sban.simplemvc.event
{
	public final class SimpleEventDispatcher
	{
		private static var instance:SimpleEventDispatcher;
		public static function SharedInstance():SimpleEventDispatcher{
			return (instance ||= new SimpleEventDispatcher());
		}
		
		public function SimpleEventDispatcher(){}
		
		protected var list:SimpleEventHandlerList = SimpleEventHandlerList.NIL;
		
		public function AddEventListener(type:String,listener:Function,priority:int=0):SimpleEventDispatcher
		{
			registerListener(type,listener,false,priority);
			return this;
		}
		
		public function AddEventListenerOnce(type:String,listener:Function,priority:int=0):SimpleEventDispatcher
		{
			registerListener(type,listener, true, priority);
			return this;
		}
		
		public function RemoveEventListener(type:String,listener:Function):SimpleEventDispatcher
		{
			list = list.FilterNotWithTypeAndListener(type,listener);
			return this;
		}
		
		public function RemoveEventListenerWithType(type:String):SimpleEventDispatcher
		{
			list = list.FilterNotWithType(type);
			return this;
		}
		
		public function RemoveAllEventListeners():SimpleEventDispatcher
		{
			list = SimpleEventHandlerList.NIL;
			return this;
		}
		
		public function DispatchEventWith(type:String,...valueObjects):SimpleEventDispatcher
		{
			return DispatchEventWithTypeAndArgs(type, valueObjects);
		}
		
		public function DispatchEventWithTypeAndArgs(type:String,valueObjects:Array):SimpleEventDispatcher
		{
			// Broadcast to listeners.
			var listToProcess:SimpleEventHandlerList = list;
			if(listToProcess.NonEmpty)
			{
				while (listToProcess.NonEmpty)
				{
					if (listToProcess.Head.Type === type) 
						executeHandler(listToProcess.Head, valueObjects);
					listToProcess = listToProcess.Tail;
				}
			}
			return this;
		}
		
		public function DispatchEvent(event:SimpleEvent):SimpleEventDispatcher{
			var listToProcess:SimpleEventHandlerList = list;
			if(listToProcess.NonEmpty)
			{
				while (listToProcess.NonEmpty)
				{
					if (listToProcess.Head.Type === event.type) 
						executeHandler(listToProcess.Head, event.Args);
					listToProcess = listToProcess.Tail;
				}
			}
			return this;
		}
		
		public function HasEventListener(type:String, listener:Function):Boolean {
			return registrationPossible(type, listener);
		}

		private function registerListener(type:String,listener:Function, once:Boolean = false, priority:int=0):void
		{
			if (registrationPossible(type,listener))
			{
				const newSlot:SimpleEventHandler = new SimpleEventHandler(type, listener, once, priority);
				list = list.Prepend(newSlot);
			}
		}

		private function registrationPossible(type:String, listener:Function):Boolean
		{
			if (!list.NonEmpty) return true;
			
			const existingSlot:SimpleEventHandler = list.FindWith(type, listener);
			if (!existingSlot) return true;

			return false; // Listener was already registered.
		}
		
		private function executeHandler(handler:SimpleEventHandler, valueObjects:Array):void
		{
			if (handler.Once) this.RemoveEventListener(handler.Type,handler.Listener);
			
			// NOTE: simple ifs are faster than switch: http://jacksondunstan.com/articles/1007
			const numValueObjects:int = valueObjects.length;
			if (numValueObjects == 0)
			{
				handler.Listener();
			}
			else if (numValueObjects == 1)
			{
				handler.Listener(valueObjects[0]);
			}
			else if (numValueObjects == 2)
			{
				handler.Listener(valueObjects[0], valueObjects[1]);
			}
			else if (numValueObjects == 3)
			{
				handler.Listener(valueObjects[0], valueObjects[1], valueObjects[2]);
			}
			else
			{
				handler.Listener.apply(null, valueObjects);
			}
		}
	}
}
