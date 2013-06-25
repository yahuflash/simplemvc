package simplemvc.command
{
	import simplemvc.common.Iterator;

	/**
	 * 复合指令
	 * @author sban
	 */
	public class ComplexCommand extends SimpleCommand implements IComplexCommand
	{
		internal var commands :Vector.<SimpleCommand>;
		internal var policy :CommandPolicy;
		
		override public function execute():Object{
			if (released) return this;
			policy.start(Iterator.create(commands), this);
			return this;
		}
		
		override public function release():void{
			commands.forEach(function(one:SimpleCommand,index:int=-1,vec:Vector.<SimpleCommand>=null):void{
				one.release();
			});
			commands=null;
			policy.release();
			policy=null;
			super.release();
		}
		
			
	}
}