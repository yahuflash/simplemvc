package sban.simplemvc.event
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sban.simplemvc.core.simplemvc_internal;
	import sban.simplemvc.core.IDisposable;
	
	/**
	 * 在EventDispatcher上扩展出removeAllEventListeners等方法
	 * 
	 * 修改自：http://k2xl.googlecode.com/svn/trunk/as3classes/src/util/k2xl/EventManager.as 
	 * 感谢Danny Miller（http://k2xl.com/）
	 * 
	 * @author sban
	 * 
	 */	
	public class SimpleEventDispatcher extends EventDispatcher implements ISimpleEventDispatcher, IDisposable
	{
		simplemvc_internal static const globalEventDispatcher :ISimpleEventDispatcher = new SimpleEventDispatcher();
		
		private static var objectMap:Dictionary = new Dictionary(true);
		
		private static function addEventListener(obj:IEventDispatcher,type:String,listener:Function,useCapture:Boolean=false,priority:int=0, useWeakReference:Boolean=true):void
		{
			if (objectMap[obj] == null)
			{
				objectMap[obj] = new Dictionary();
				objectMap[obj].numListeners = 0;
			}
			if (objectMap[obj][type] == null)
			{
				objectMap[obj].numListeners++;
				objectMap[obj][type] = new Array();
				(objectMap[obj][type] as Array).push(obj,type); // You can't access keys of a dictionary, so might as well put need info as first index
			}
			(objectMap[obj][type] as Array).push(listener);
		}
		
		private static function addEventListeners(obj:IEventDispatcher, eventListeners:Array, useCapture:Boolean=false,priority:int=0, useWeakReference:Boolean=true):void
		{
			for ( var i:int = 0; i < eventListeners.length; i += 2 )
			{
				addEventListener( obj, eventListeners[ i ] as String, eventListeners[ i + 1] as Function, useCapture, priority, useWeakReference );
			}
		}
		
		private static function removeEventListener(obj:IEventDispatcher,type:String,listener:Function,useCapture:Boolean=false):void
		{
			if (objectMap[obj] == null)
			{
				//trace("Couldn't find listener to remove (type = "+type+" from "+obj+")");
				return;
			}
			var arr:Array = objectMap[obj][type];
			if (arr == null)
			{
				// if obj overrides remove event listener, it better have removeListener set to false when it calls so that this block is encountered.
				return;
			}
			var tempS:int = arr.length;
			for (var i:int = 2; i <  tempS; i++)
			{
				if (arr[i] == listener)
				{
					arr.splice(i,1);
				}				
			}
			if (arr.length == 2) // only object and type indexes left...
			{
				objectMap[obj][type] = null;
				// If no more listeners exist on this object...
				objectMap[obj].numListeners--;
				if (objectMap[obj].numListeners == 0)
				{
					objectMap[obj] = null;
				}
			}
		}
		
		private static function removeAllListeners(objectFilter:IEventDispatcher = null, typeFilter:String = null, functionFilter:Function = null): Boolean
		{
			var hasRemove :Boolean = false;
			for (var obj:Object in objectMap)
			{
				if (objectFilter != null) 
				{
					obj = objectFilter;
				}
				var tempobj:Object = objectMap[obj];
				for each (var temp:Object in tempobj)
				{
					if ((temp is Number || temp==null) || (typeFilter != null && temp[1]!=typeFilter) || (functionFilter != null && temp[2]!=functionFilter)) { continue; }; // length property
					{
						removeEventListener(temp[0],temp[1],temp[2],false);
						hasRemove = true;
					}
				}
				if (objectFilter != null) { break; };
			}
			return hasRemove;
		}
		
		public static function cleanUp():void
		{
			var prevObj:Object = new Object();
			for each (var type:Object in objectMap)
			{
				for each (var type2:Object in type)
				{
					if (type2 is Number || type2 == null) { continue; }
					if (type2[0] == prevObj) { continue; }
					cleanUpObject(type2[0] as IEventDispatcher);
					prevObj = type2[0];
				}
			}
		}
		public static function cleanUpObject(obj:IEventDispatcher):void
		{
			if (objectMap[obj] == null) 
			{ 
				return; 
			}			
			for each (var type:Object in objectMap[obj])
			{
				if (type is Number || type == null){continue; } // length property
				var num:int = (objectMap[obj][type[1]] as Array).length-2; // first 2 parameters are obj, event
				
				if (! ((type[0] as EventDispatcher).hasEventListener(type[1])) )
				{ 
					removeEventListener(type[0],type[1],type[2]);  
				}
			} 
		}
		
		public function SimpleEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			// TODO Auto Generated method stub
			SimpleEventDispatcher.addEventListener(this, type, listener, useCapture, priority, true);
			super.addEventListener(type, listener, useCapture, priority,useWeakReference);
		}
		
		public function addEventListeners(obj:IEventDispatcher, eventListeners:Array, useCapture:Boolean=false,priority:int=0, useWeakReference:Boolean=true):void
		{
			SimpleEventDispatcher.addEventListeners(obj, eventListeners, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			// TODO Auto Generated method stub
			SimpleEventDispatcher.removeEventListener(this, type,listener,useCapture);
			super.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 *移除所有使用addEventListener添加的事件监听 
		 * 可以使用参数过滤，移除指定监听集合
		 * @param type 
		 * @param listener
		 * 
		 */				
		public function removeAllEventListeners(type:String = null, listener:Function = null): Boolean
		{
			return SimpleEventDispatcher.removeAllListeners(this, type, listener);
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			this.removeAllEventListeners();
		}
		
	}
}