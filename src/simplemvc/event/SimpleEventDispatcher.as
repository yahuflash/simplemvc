package simplemvc.event
{
	import flash.events.EventDispatcher;
	
	import simplemvc.core.IDisposable;
	import simplemvc.core.SimpleObjectPool;
	
	public class SimpleEventDispatcher extends EventDispatcher implements IDisposable
	{
		public static function create():SimpleEventDispatcher{
			return SimpleObjectPool.sharedInstance().pull(SimpleEventDispatcher) as SimpleEventDispatcher;
		}
		
		public function SimpleEventDispatcher(){}
		
		private var listeners :Vector.<EventListener> = new Vector.<EventListener>();
		
		/**
		 * 清除指定类型的事件监听 
		 * @param type 如果为空，清除所有
		 * 
		 */
		public function clearEventListeners(type:String=null):void{
			var j:int, item:EventListener;
			
			if(!type){
				for (j = 0; j < listeners.length; j++) {
					item = listeners[j];
					super.removeEventListener(item.type, item.listener, item.capture);
					item.dispose();
				}
				listeners.length=0;
			}else{
				for (j = 0; j < listeners.length; j++) {
					if(listeners[j].type == type){
						item = listeners[j];
						super.removeEventListener(item.type, item.listener, item.capture);
						listeners.splice(j,1);
						item.dispose();
						j--;
					}
				}
			}
		}
		
		public function dispatchSimpleEvent(type:String,...args):Boolean{
			var e:SimpleEvent=new SimpleEvent(type);
			e.args=args;
			return this.dispatchEvent(e);
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			this.clearEventListeners();
			SimpleObjectPool.sharedInstance().push(this);
		}
		
		
		override public function toString():String{
			var r:String="[";
			for (var j:int = 0; j < listeners.length; j++) {
				if(j>0) r+= "\n,";
				r += "{type:"+listeners[j].type+",listener:"+listeners[j].listener+"}";
			}
			r += "]";
			return r;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			// TODO Auto Generated method stub
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			this.listeners.push( EventListener.create(type, listener, useCapture, priority) );
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			// TODO Auto Generated method stub
			super.removeEventListener(type, listener, useCapture);
			
			var item:EventListener;
			for (var j:int = 0; j < listeners.length; j++) {
				item = listeners[j];
				if(item.type == type && item.listener == listener){
					listeners.splice(j,1);
					item.dispose();
					break;
				}
			}
		}
		
	}
}