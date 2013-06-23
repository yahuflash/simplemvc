package simplemvc.command
{
	import simplemvc.common.DelayCallManager;
	import simplemvc.common.HandlerObject;
	import simplemvc.common.ObjectPool;

	/**
	 * 同步方法的指令封装
	 * 先调用方法，稍后派发完成事件
	 * 
	 * @author sban
	 * 
	 */
	public class SyncCommand extends SimpleCommand
	{
		/**仅保证执行，不保证得到期许的结果，
		 * withFunc example:function(...withArgs):void*/		
		public static function create(withFunc :Function, withArgs:Array):SyncCommand{
			var c:SyncCommand = ObjectPool.sharedObjectPool().retrieveNew(SyncCommand) as SyncCommand;
			c.handler = HandlerObject.create(withFunc,withArgs);
			return c;
		}
		public function SyncCommand(){}
		internal var handler:HandlerObject;
		
		override public function execute():Object{
			handler.call();
			DelayCallManager.sharedDelayCallManager().push( HandlerObject.create(complete) );
			return this;
		}
		
		override public function release():void{
			handler.release();
			super.release();
		}
		
	}
}