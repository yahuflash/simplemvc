package us.sban.simplemvc.core
{
    import flash.utils.Dictionary;
    
    import starling.events.Event;
    import starling.events.EventDispatcher;
    
	use namespace simplemvc_internal;
	
	/**
	 * 修改自Starling的EventDispatcher
	 * 
	 * @author sban
	 * 
	 */    
    public class SimpleEventDispatcher extends EventDispatcher implements ISimpleEventDispatcher
    {
        private var mEventListeners:Dictionary;
        
        /** Creates an EventDispatcher. */
        public function SimpleEventDispatcher(){}
		
		private var _eventHandler:SimpleEventHandlers;
		public function get eventHandlers():SimpleEventHandlers{
			return (_eventHandler ||= $.objects.createNew(SimpleEventHandlers) as SimpleEventHandlers).setTarget(this).open();
		}
		
		public function release():ISimpleObject{
			this.removeEventListeners();
			if(_eventHandler){
				_eventHandler.release();
				_eventHandler=null;
			}
			return $.objects.pushReleased(this) as ISimpleObject;
		}
        
	}
}