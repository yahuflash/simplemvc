package us.sban.simplemvc.core.injection
{
	import us.sban.simplemvc.core.ISimpleObject;
	import us.sban.simplemvc.core.SimpleObject;
	import us.sban.simplemvc.core.simplemvc_internal;

	public class SimpleBean extends SimpleObject
	{
		/**
		 * Register a <code>Bean</code> by its <code>Class</code> or id.
		 */
		public function SimpleBean(){}
		
		public var instance:Object;
		public var id:String;
		
		override public function release():ISimpleObject{
			instance = null;
			id = null;
			return super.release();
		}
		
		public function add():SimpleBean{
			return this;
		}
		public function remove():SimpleBean{
			return this;
		}
		
		simplemvc_internal function setInstance(instance:Object):SimpleBean{
			this.instance = instance;
			return this;
		}
		
		public function setId(id:String):SimpleBean{
			this.id = id;
			return this;
		}
	}
}
