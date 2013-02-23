package us.sban.simplemvc.core
{
	import us.sban.simplemvc.command.ComplexCommand;
	import us.sban.simplemvc.command.SerialCommandPolicy;

	/**
	 * 按先入先出的顺序，依次执行推入的指令，直接所有指令执行完毕
	 * 在停止后，如果有新指令推入，将启动新的执行序列
	 *  
	 * @author sban
	 * 
	 */	
	public class Stack extends ComplexCommand
	{
		public function Stack()
		{
			super(new SerialCommandPolicy(), []);
			
		}
		
		private var executing :Boolean = false;
		
		public function pushCommand(c:ICommand):void
		{
			commands.push(c);
			this.execute();
		}
		
		/**
		 * 推入新的指令集，将自动启动执行序列 
		 * @param commands
		 * 
		 */		
		public function pushCommands(...commands):void
		{
			commands.forEach(
				function(c:ICommand):void
				{
					commands.push(c);
				}
			);
			this.execute();
		}
		
		override public function execute():Promise
		{
			// TODO Auto Generated method stub
			if(!executing)
			{
				executing=true;
				this.promise = new Promise(this);
				this.promise.complete(policy_onComplete);
				policy.start(new Iterator(commands.splice(0, commands.length)), this.promise);
			}
			return this.promise;
		}
		
		protected function policy_onComplete(data :Object = null):void
		{
//			trace('commands.length',commands.length);
			executing=false;
			this.promise.dispose();
			if(commands.length > 0)
				this.execute();
		}
		
		
	}
}