package simplemvc.event
{
    import flash.utils.Dictionary;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    
    import simplemvc.common.IReusable;
    import simplemvc.common.ObjectPool;
    import simplemvc.common.simplemvc_internal;
    
	use namespace simplemvc_internal;
	use namespace flash_proxy;
    
	/**
	 * 事件派发对象
	 * fixed on 2010/06/21 
	 * @author sban
	 * 
	 */	
    public class SimpleEventDispatcher extends Proxy implements IReusable, ISimpleEventDispatcher
    {
		private static var instance:SimpleEventDispatcher;
		/**全局的事件派发对象*/
		public static function sharedSimpleDispatcher():SimpleEventDispatcher{
			return (instance ||= new SimpleEventDispatcher);
		}
		
		public static function create():SimpleEventDispatcher{
			return ObjectPool.sharedObjectPool().retrieveNew( SimpleEventDispatcher ) as SimpleEventDispatcher;
		}
		
        /** Creates an EventDispatcher. */
        public function SimpleEventDispatcher(){}
        protected var eventListeners:Dictionary;
		protected var eventDispatchedMap:Object;
		
		/**是否已经派发过某事件
		 * @param 事件名*/
		flash_proxy override function getProperty(name:*):*{
			return hasDispatchedEvent(name.localName);
		}
		
		/**xxx.complete = null
		 * xxx.complete = listener
		 * */
		flash_proxy override function setProperty(name:*, value:*):void{
			name = name.localName;
			if (value == null){
				//clearListenersOf(name);
				removeEventListenersStartWith(name);
			}else if (value is Function){
				addEventListener(name,value);
			}
		}
		
		/**
		 * dispatch event or add listener
		 * 1,promise.complete(obj)
		 * 2,promise.complete(function(){...})
		 */
		flash_proxy override function callProperty(name:*, ...args):*{
			name = name.localName;
			var arg :* = (args.length > 0) ? args[0] : null;
			if (arg && (arg is Function)){
				addEventListener(name,arg);
			}else{
				dispatchEventWith(name,arg);
			}
			return this;
		}
        
        public function addEventListener(type:String, listener:Function, priority:int=0):void
        {
            if (eventListeners == null) eventListeners = new Dictionary();
            
            var listeners:Vector.<PriorityHandler> = eventListeners[type] as Vector.<PriorityHandler>;
            if (listeners == null){
				eventListeners[type] = new <PriorityHandler>[PriorityHandler.create(listener,priority)];
			}else if ( funcIndexInListeners(listener,listeners) < 0) {
                listeners.push(PriorityHandler.create(listener,priority));
				listeners.sort(sortFuncOfListeners);
			}
        }
		
		public function addEventListenersTo(types:Array, listener:Function):void{
			types.forEach(function(type:String,index:int=-1,arr:Array=null):void{
				addEventListener(type,listener);
			});
		}
		
        /** Removes an event listener from the object. */
        public function removeEventListener(type:String, listener:Function):void{
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
        public function removeEventListenersOf(type:String=null):void
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
		
		public function removeEventListeners():void{
			this.removeEventListenersOf();
		}
		
		public function removeEventListenersStartWith(prefix:String):void{
			if (!prefix || !eventListeners) return;
			for (var type:String in eventListeners){
				if (type.indexOf(prefix) == 0){
					delete eventListeners[type];
				}
			}
		}
        
        public function dispatchEvent(event:SimpleEvent):void {
            if (eventListeners == null || !(event.type in eventListeners))
                return; // no need to do anything
            event.target=this;
			invokeEvent(event);                                  
        }
		
		public function dispatchEventWith(type:String, data:Object=null):void
		{
			if (hasListenedTo(type)){
				var event:SimpleEvent = SimpleEvent.create(type, data);
				dispatchEvent(event);
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
		public function hasDispatchedEvent(type:String):Boolean{
			return (eventDispatchedMap && eventDispatchedMap[type]);
		}
		
		public function release():void{
			this.removeEventListeners();
			ObjectPool.sharedObjectPool().pushReleased(this);
		}
        
        /** @private
         *  Invokes an event on the current object. This method does not do any bubbling, nor
         *  does it back-up and restore the previous target on the event. The 'dispatchEvent' 
         *  method uses this method internally. */
        protected function invokeEvent(event:SimpleEvent):Boolean
        {
            var listeners:Vector.<PriorityHandler> = eventListeners ?
                eventListeners[event.type] as Vector.<PriorityHandler> : null;
            var numListeners:int = listeners == null ? 0 : listeners.length;
            
            if (numListeners){
                for (var i:int=0; i<numListeners; ++i){
                    var listener:Function = (listeners[i] as PriorityHandler).func;
                    var numArgs:int = listener.length;
					
                    if (numArgs == 0) listener();
					else if (numArgs == 1) listener(event.args);
					else if (numArgs == 2) listener(event.args,event);
					
					((eventDispatchedMap ||= {})[event.type] ||= {})[event.type]=true;
                }
                
                return event.stopsPropagation;
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