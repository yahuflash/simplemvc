package us.sban.simplemvc.core
{
    import flash.utils.Dictionary;
    
	use namespace simplemvc_internal;
	
	/**
	 * 修改自Starling的EventDispatcher
	 * 
	 * @author sban
	 * 
	 */    
    public class SimpleEventDispatcher extends SimpleObject implements ISimpleEventDispatcher
    {
        private var mEventListeners:Dictionary;
        
        /** Creates an EventDispatcher. */
        public function SimpleEventDispatcher(){}
		
		private var _eventHandler:SimpleEventHandlers;
		public function get eventHandlers():SimpleEventHandlers{
			return (_eventHandler ||= $.objects.createNew(SimpleEventHandlers) as SimpleEventHandlers).setTarget(this).open();
		}
		
		override public function release():ISimpleObject{
			this.removeSimpleEventListeners();
			if(_eventHandler){
				_eventHandler.release();
				_eventHandler=null;
			}
			return super.release();
		}
		
		public function numListeners(type:String=null):Number 
		{
			if(!mEventListeners) return 0;
			
			if(!type)
			{
				var listeners:Vector.<SimpleFunction> = mEventListeners ? mEventListeners[type] : null;
				return listeners ? listeners.length : 0;
			}
			
			var count:int = 0;
			for each (listeners in mEventListeners) 
			{
				count += listeners.length;
			}
			return count;
		}
        
        /** Registers an event listener at a certain object. */
        public function addSimpleEventListener(type:String, listener:Function,priority:int=0):void
        {
			if(null == mEventListeners) mEventListeners = new Dictionary();
            var listeners:Vector.<SimpleFunction> = mEventListeners ? mEventListeners[type] : null;
            if (listeners == null)
                mEventListeners[type] = new <SimpleFunction>[$.f(listener).setPriority(priority)];
			else{
				var hasListener:Boolean = false;
				listeners.some(
					function(item:SimpleFunction,index:int=-1,vector:Vector.<SimpleFunction>=null):Boolean{
						if(item.valueOf() == listener)
							return (hasListener=true);
						return false;
					}
				);
				if(!hasListener)
					listeners.push($.f(listener).setPriority(priority));
			}
			
			//sort
			sortEventListenerByPriority(type);
        }
        
        /** Removes an event listener from the object. */
        public function removeSimpleEventListener(type:String, listener:Function):void
        {
            if (mEventListeners)
            {
                var listeners:Vector.<SimpleFunction> = mEventListeners[type];
                if (listeners)
                {
                    var numListeners:int = listeners.length;
                    var remainingListeners:Vector.<SimpleFunction> = new <SimpleFunction>[];
                    
                    for (var i:int=0; i<numListeners; ++i){
						if (listeners[i].valueOf() == listener){
							listeners[i].release();
							listeners.splice(i++,1);
							numListeners--;
						}
					}
					
					//sort
					sortEventListenerByPriority(type);
                }
            }
        }
        
        /** Removes all event listeners with a certain type, or all of them if type is null. 
         *  Be careful when removing all event listeners: you never know who else was listening. */
        public function removeSimpleEventListeners(type:String=null):void
        {
			var listeners:Vector.<SimpleFunction>;
            if (type && mEventListeners){
				listeners = mEventListeners[type];
				listeners.forEach(
					function(item:SimpleFunction,index:int=-1,vector:Vector.<SimpleFunction>=null):void{
						item.release();
					}
				);
                delete mEventListeners[type];
			}else{
				for(type in mEventListeners){
					listeners = mEventListeners[type];
					listeners.forEach(
						function(item:SimpleFunction,index:int=-1,vector:Vector.<SimpleFunction>=null):void{
							item.release();
						}
					);
				}
                mEventListeners = null;
			}
        }
        
        /** Dispatches an event to all objects that have registered for events of the same type. */
        public function dispatchSimpleEvent(event:SimpleEvent):void
        {
			var bubbles:Boolean = event.bubbles;
			if (!bubbles && (mEventListeners == null || !(event.type in mEventListeners)))
				return; // no need to do anything
			
			// we save the current target and restore it later;
			// this allows users to re-dispatch events without creating a clone.
			
			event.setTarget(this);
			invoke(event);
        }
        
        public function dispatchSimpleEventWith(type:String, ...args):void
        {
            if (hasSimpleEventListener(type)) 
            {
                var event:SimpleEvent = $.event(type).setArgs(args);
                dispatchSimpleEvent(event);
				event.release();
            }
        }
        
        /** Returns if there are listeners registered for a certain event type. */
        public function hasSimpleEventListener(type:String):Boolean
        {
            var listeners:Vector.<SimpleFunction> = mEventListeners ? mEventListeners[type] : null;
            return listeners ? listeners.length != 0 : false;
        }
		
		protected function sortEventListenerByPriority(type:String):void{
            var listeners:Vector.<SimpleFunction> = mEventListeners ? mEventListeners[type] : null;
			if(listeners){
				listeners.sort( SimpleFunction.sortByPriority );
			}
		}
		
		private function invoke(event:SimpleEvent):void
		{
			var listeners:Vector.<Function> = mEventListeners ? mEventListeners[event.type] : null;
			var numListeners:int = listeners == null ? 0 : listeners.length;
			
			if (numListeners)
			{
				// we can enumerate directly over the vector, because:
				// when somebody modifies the list while we're looping, "addEventListener" is not
				// problematic, and "removeEventListener" will create a new Vector, anyway.
				
				for (var i:int=0; i<numListeners; ++i)
				{
					var listener:Function = listeners[i] as Function;
					var numArgs:int = listener.length;
					
					if (numArgs == 0) listener();
					else if (numArgs == 1) listener(event);
					else listener.apply(this, [event].concat(event.args));
					
					if (event.immediatePropagationStops)
						break;
				}
			}
		}
	}
}