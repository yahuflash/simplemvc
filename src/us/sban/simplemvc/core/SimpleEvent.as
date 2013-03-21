package us.sban.simplemvc.core
{
	import starling.events.Event;

	use namespace simplemvc_internal;
	
	public final class SimpleEvent extends Event implements ISimpleObject
	{
		/** Event type for a display object that is added to a parent. */
		public static const ADDED:String = "added";
		/** Event type for a display object that is removed from its parent. */
		public static const REMOVED:String = "removed";
		
		public function SimpleEvent(type:String=null)
		{
			super(type);
		}
		
		public function release():ISimpleObject{
			return $.objects.pushReleased(this) as ISimpleObject;
		}
		
		public function dispatchIn(target:ISimpleEventDispatcher):SimpleEvent{
			target.dispatchEvent(this);
			return this;
		}
		public function dispatchInGlobal():SimpleEvent{
			$.globalDispatcher.dispatchEvent(this);
			return this;
		}
		public function setType(value:String):SimpleEvent{
			this.mType=value;
			return this;
		}
		public function setBubbles(value:Boolean):SimpleEvent{
			this.mBubbles=value;
			return this;
		}
		public function setData(value:Object):SimpleEvent{
			this.mData = value;
			return this;
		}
	}
}