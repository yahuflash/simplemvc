package us.sban.simplemvc.core
{
	import flash.events.Event;
	
	/**
	 * 需要与已有的as3项目兼容，而不仅是starling项目。
	 * 1，提供对starling event的转换
	 * 2，有对象池机制
	 * 
	 */
	public final class SimpleEvent extends Event
	{
		public function SimpleEvent(type:String, data:Object=null)
		{
			super(type);
			if(data) _data = data;
		}
		
		private var _data:Object={};
		public function get data():Object{return _data;}
	}
}