package us.sban.simplemvc.core
{
	use namespace simplemvc_internal;
	
	public final class SimpleEvent extends SimpleObject
	{
		/** Event type for a display object that is added to a parent. */
		public static const ADDED:String = "added";
		/** Event type for a display object that is removed from its parent. */
		public static const REMOVED:String = "removed";
		
		public function SimpleEvent()
		{
		}
		
		private var _type:String;
		private var _args:Array;
		private var _immediatePropagationStops:Boolean = false;
		private var _bubbles:Boolean = false;
		private var _target:ISimpleEventDispatcher;
		private var _priority:int=0;
		
		/** Indicates if event will bubble. */
		public function get bubbles():Boolean { return _bubbles; }
		public function get priority():int{return _priority;}
		public function get target():ISimpleEventDispatcher{return _target;}
		public function get type():String{return _type;}
		public function get args():Array{return _args;}
		public function get immediatePropagationStops():Boolean{return _immediatePropagationStops;}
		
		public function dispatchIn(target:ISimpleEventDispatcher):SimpleEvent{
			target.dispatchSimpleEvent(this);
			return this;
		}
		public function dispatchInGlobal():SimpleEvent{
			$.globalDispatcher.dispatchSimpleEvent(this);
			return this;
		}
		
		public function stopImmediatePropagation():SimpleEvent{
			_immediatePropagationStops=true;
			return this;
		}
		
		public function setPriority(value:int):SimpleEvent{
			this._priority = priority;
			return this;
		}
		public function setBubbles(value:Boolean):SimpleEvent{
			this._bubbles = value;
			return this;
		}
		
		public function setArgs(args:Array):SimpleEvent{
			this._args = args;
			return this;
		}
		public function setTarget(target:ISimpleEventDispatcher):SimpleEvent{
			this._target = target;
			return this;
		}
		
		public function setType(type:String):SimpleEvent{
			this._type = type;
			return this;
		}
	}
}