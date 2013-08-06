package simplemvc.command
{
	import simplemvc.common.IClonable;
	import simplemvc.common.IReusable;
	import simplemvc.common.simplemvc_internal;
	import simplemvc.event.SimpleEventDispatcher;
	
	use namespace simplemvc_internal;
	
	public class SimpleCommand extends SimpleEventDispatcher implements ICommand,IClonable,IReusable{
		
		//在子类中实现static create方法
		
		/**args:{}*/
		public static const COMPLETE:String = "complete";
		/**args:{}*/
		public static const CANCEL:String = "cancel";
		/**args:{}*/
		public static const UNDO:String = "undo";
		
		public function SimpleCommand(){}
		internal var released:Boolean=false;
		
		/**别名于execute*/
		public function redo():Object{return execute();}
		virtual public function execute():Object{return this;}
		
		/**当成以后，不自动release，需手动调用*/
		public function complete():Object{
			dispatchEventWith(COMPLETE);
			return this;
		}
		public function cancel():Object{dispatchEventWith(CANCEL);return this;}
		public function undo():Object{dispatchEventWith(UNDO);return this;}
		
		public function clone():Object{return new SimpleCommand;}
		
		override public function release():void{
			released = true;
			super.release();
		}
		
	}
}