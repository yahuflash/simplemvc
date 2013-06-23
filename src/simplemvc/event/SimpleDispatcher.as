package simplemvc.event
{
    import flash.utils.Dictionary;
    import flash.utils.Proxy;
    
    import simplemvc.common.IReusable;
    import simplemvc.common.ObjectPool;
    import simplemvc.common.simplemvc_internal;
    
	use namespace simplemvc_internal;
    
	/**
	 * 事件派发对象
	 * fixed on 2010/06/21 
	 * @author sban
	 * 
	 */	
    public class SimpleDispatcher extends Proxy implements IReusable, ISimpleDispatcher
    {
		private static var instance:SimpleDispatcher;
		/**全局的事件派发对象*/
		public static function sharedSimpleDispatcher():SimpleDispatcher{
			return (instance ||= new SimpleDispatcher);
		}
		
		public static function create():SimpleDispatcher{
			return ObjectPool.sharedObjectPool().retrieveNew( SimpleDispatcher ) as SimpleDispatcher;
		}
		
        /** Creates an EventDispatcher. */
        public function SimpleDispatcher(){}
        protected var eventListeners:Dictionary;
		protected var eventDispatchedMap:Object;
        
        /** Registers an event listener at a certain object. */
        public function listenTo(type:String, listener:Function, priority:int=0):void
        {
            if (eventListeners == null) eventListeners = new Dictionary();
            
            var listeners:Vector.<PriorityHandler> = eventListeners[type] as Vector.<PriorityHandler>;
            if (listeners == null)
                eventListeners[type] = new <PriorityHandler>[PriorityHandler.create(listener,priority)];
            else if ( funcIndexInListeners(listener,listeners) < 0) // check for duplicates
                listeners.push(listener);
			listeners.sort(listeners);
        }
		
		public function listenTos(types:Array, listener:Function):void{
			types.forEach(function(type:String):void{
				listenTo(type,listener);
			});
		}
		
        /** Removes an event listener from the object. */
        public function unlistenTo(type:String, listener:Function):void{
            if (eventListeners)
            {
                var listeners:Vector.<PriorityHandler> = eventListeners[type] as Vector.<PriorityHandler>;
                if (listeners){
                    var numListeners:int = listeners.length;
                    var remainingListeners:Vector.<PriorityHandler> = new <PriorityHandler>[];
                    
                    for (var i:int=0; i<numListeners; ++i){
                        var otherListener:PriorityHandler = listeners[i];
                        if (otherListener.func != listener) remainingListeners.push(otherListener);
                    }
                    
					listeners.sort(remainingListeners);
                    eventListeners[type] = remainingListeners;
                }
            }
        }
        
        /** Removes all event listeners with a certain type, or all of them if type is null. 
         *  Be careful when removing all event listeners: you never know who else was listening. */
        public function clearListenersOf(type:String=null):void
        {
            if (type && eventListeners)
                delete eventListeners[type];
            else
                eventListeners = null;
			if (type && eventDispatchedMap)
				delete eventDispatchedMap[type];
			else
				eventDispatchedMap = null;
        }
		
		public function clearListeners():void{
			this.clearListenersOf();
		}
		
		public function removeListenersStartWith(prefix:String):void{
			if (!prefix || !eventListeners) return;
			for (var type:String in eventListeners){
				if (type.indexOf(prefix) == 0){
					delete eventDispatchedMap[type];
				}
			}
		}
        
        /** Dispatches an event to all objects that have registered listeners for its type. 
         *  If an event with enabled 'bubble' property is dispatched to a display object, it will 
         *  travel up along the line of parents, until it either hits the root object or someone
         *  stops its propagation manually. */
        public function dispatch(event:SimpleEvent):void
        {
            if (eventListeners == null || !(event.getType in eventListeners))
                return; // no need to do anything
            event.target=this;
			invokeEvent(event);                                  
        }
		
		public function dispatchWith(type:String, data:Object=null):void
		{
			if (hasListenedTo(type)){
				var event:SimpleEvent = SimpleEvent.create(type, data);
				dispatch(event);
				event.release();
			}
		}
		
		/** Returns if there are listeners registered for a certain event type. */
		public function hasListenedTo(type:String):Boolean{
			var listeners:Vector.<PriorityHandler> = eventListeners ?
				eventListeners[type] as Vector.<PriorityHandler> : null;
			return listeners ? listeners.length != 0 : false;
		}
		
		/**是否已经派发过某事件*/
		public function hasDispatched(type:String):Boolean{
			return (eventDispatchedMap && eventDispatchedMap[type]);
		}
		
		public function release():void{
			this.clearListeners();
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
        
        /** @private
         *  Invokes an event on the current object. This method does not do any bubbling, nor
         *  does it back-up and restore the previous target on the event. The 'dispatchEvent' 
         *  method uses this method internally. */
        protected function invokeEvent(event:SimpleEvent):Boolean
        {
            var listeners:Vector.<PriorityHandler> = eventListeners ?
                eventListeners[event.getType] as Vector.<PriorityHandler> : null;
            var numListeners:int = listeners == null ? 0 : listeners.length;
            
            if (numListeners){
                for (var i:int=0; i<numListeners; ++i){
                    var listener:Function = (listeners[i] as PriorityHandler).func;
                    var numArgs:int = listener.length;
					
                    if (numArgs == 0) listener();
					else if (numArgs == 1) listener(event.args);
					else if (numArgs == 2) listener(event.args,event);
					
					((eventDispatchedMap ||= {})[event.getType()] ||= {})[event.getType()]=true;
                }
                
                return event.hasStoppedPropagation();
            }
            else{
                return false;
            }
        }
		
		protected function sortFuncOfListeners(a:PriorityHandler,b:PriorityHandler):int{
			if (a.priority < b.priority) return -1;
			else if(a.priority > b.priority) return 1;
			return 0;
		}
        
		protected function funcIndexInListeners(func:Function,listeners:Vector.<PriorityHandler>):int{
			var r:int = -1;
			listeners.some(
				function(listener:PriorityHandler,index:int=-1, vec:Vector.<PriorityHandler>=null):Boolean{
					if (listener.func == func){
						r = index;
						return true;
					}
					return false;
				}
			);
			return r;
		}
		
		
	}
}