package simplemvc.command
{
	import simplemvc.core.Promise;
	import simplemvc.util.Iterator;

	public class CommandPolicy implements ICommandPolicy
	{
		public function CommandPolicy(){}
		
		protected var numComplete :int=0;
		protected var numTotal :int = 0;
		protected var iterator :Iterator;
		protected var promise:Promise;
		
		public function start(iterator:Iterator,promise:Promise):void{
			numComplete=0;
			numTotal = iterator.count;
			this.iterator = iterator;
			this.promise = promise;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			promise=null;
			iterator=null;
		}
		
	}
}