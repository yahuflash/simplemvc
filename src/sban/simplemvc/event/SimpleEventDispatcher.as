package sban.simplemvc.event
{
	import sban.simplemvc.interfaces.IDisposable;
	import sban.simplemvc.interfaces.IPrintable;

	public final class SimpleEventDispatcher implements IPrintable, IDisposable
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
			var event:SimpleEvent = new SimpleEvent(type);
			event.Args = valueObjects;
			return DispatchEvent(event);
		}
		
		public function DispatchEvent(event:SimpleEvent):SimpleEventDispatcher{
			var listToProcess:SimpleEventHandlerList = list;
			if(listToProcess.NonEmpty)
			{
				while (listToProcess.NonEmpty && !event.StopedPropagation())
				{
					if (listToProcess.Head.Type === event.type) 
						executeHandler(event, listToProcess.Head, event.Args);
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
				const handler:SimpleEventHandler = new SimpleEventHandler(type, listener, once, priority);
				list = list.InsertWithPriority(handler);
			}
		}

		private function registrationPossible(type:String, listener:Function):Boolean
		{
			if (!list.NonEmpty) return true;
			
			const existingSlot:SimpleEventHandler = list.FindWith(type, listener);
			if (!existingSlot) return true;

			return false; // Listener was already registered.
		}
		
		private function executeHandler(event:SimpleEvent, handler:SimpleEventHandler, valueObjects:Array):void
		{
			if (handler.Once) this.RemoveEventListener(handler.Type,handler.Listener);
			
			const numFuncArgs:int = handler.Listener.length;
			
			event.dispatcher = this;
			if (numFuncArgs == 0)
			{
				handler.Listener();
			}else if (numFuncArgs == 1)
			{
				handler.Listener(event);
			}else if (numFuncArgs >= 2)
			{
				const numValueObjects:int = valueObjects.length;
				if (numValueObjects == 1){
					handler.Listener(event, valueObjects[0]);
				}else if (numValueObjects == 2) {
					handler.Listener(event, valueObjects[0], valueObjects[1]);					
				}else if (numValueObjects == 3) {
					handler.Listener(event, valueObjects[0], valueObjects[1], valueObjects[2]);					
				}else if (numValueObjects == 4) {
					handler.Listener(event, valueObjects[0], valueObjects[1], valueObjects[2], valueObjects[3]);					
				}else{
					valueObjects.unshift(event);
					handler.Listener.apply(null, valueObjects);										
				}
			}
		}
		
		public function Dispose():void
		{
			// TODO Auto Generated method stub
			list.Dispose();
		}
		
		
		public function Print():void{
			list.Print();
		}
		
	}
}
