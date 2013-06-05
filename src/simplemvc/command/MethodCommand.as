package simplemvc.command
{
	import simplemvc.core.Promise;
	import simplemvc.util.DelayCall;

	/**同步方法的命令封装
	 * */
	public final class MethodCommand extends SimpleCommand
	{
		public function MethodCommand(method:Function,...params)
		{
			super();
			this.method=method;
			this.params=params;
		}
		
		private var method:Function;
		private var params:Array;
		private var thisObj:Object;
		
		/**设置this对象，如果method中使用this关键字，需要设置*/
		public function setThis(thisObj:Object):MethodCommand{
			this.thisObj=thisObj;
			return this;
		}
		
		override public function execute():Promise
		{
			// TODO Auto Generated method stub
			super.execute();
			method.apply(thisObj,params);
			DelayCall.add(setComplete);
			return promise;
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			this.method=null;
			this.params=null;
			this.thisObj=null;
			super.dispose();
		}
		
		
	}
}