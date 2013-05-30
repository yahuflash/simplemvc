package sban.simplemvc.core
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import sban.simplemvc.interfaces.IReusable;
	
	import starling.events.Event;
	
	/**
	 * 1,支持flash event与starling event
	 * 2,以flash event为主，支持由starling event转换过来，支持向starling event转换
	 * 
	 */
	public final class SimpleEvent extends flash.events.Event implements IReusable
	{
		public function SimpleEvent(type:String, data:Object=null)
		{
			super(type);
			if(data) _data = data;
		}
		private var _data:Object={};
		public function get data():Object{return _data;}
		/**转换为starling event*/
		public function toStarlingEvent():starling.events.Event{
			var r:starling.events.Event = new starling.events.Event(this.type, false, this.data);
			return r;
		}
		/**由starling event转换而来*/
		public static function fromStarlingEvent(e:starling.events.Event):SimpleEvent{
			var r:SimpleEvent = new SimpleEvent(e.type,e.data);
			return r;
		}
		
		//for objectReleasePool start
		
		/**SimpleEvent复用是以classType+eventType为key的，因flash event的构造器默认传入了参数type，且无法另写*/
		public function get reuseKey():String
		{
			// TODO Auto Generated method stub
			const key:String= flash.utils.getQualifiedClassName(this)+"::";
			return key+type;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			this._data=null;
		}
		/**type不需要传递，仅传递data即可*/
		public function init(...args):void
		{
			// TODO Auto Generated method stub
			if(args.length>0) this._data = args[0];
		}
		//for objectReleasePool end
		
	}
}