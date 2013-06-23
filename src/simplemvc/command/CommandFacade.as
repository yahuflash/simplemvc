package simplemvc.command
{
	public final class CommandFacade{
		public function CommandFacade()
		{
		}
		
		public function async(withFunc :Function, ...others):AsyncCommand{
			return AsyncCommand.create(withFunc, others);
		}
		public function sync(withFunc :Function, ...withArgs):SyncCommand{
			return SyncCommand.create(withFunc,withArgs);
		}
		public function parallel(strict:Boolean=true,...commands):ParallelCommand{
			return ParallelCommand.create(commands,strict);
		}
		public function serial(strict:Boolean=true,...commands):SerialCommand{
			return SerialCommand.create(commands,strict);
		}
		public function circle(strict:Boolean=true,...commands):CirclineCommand{
			return CirclineCommand.create(commands,strict);
		}
	}
}