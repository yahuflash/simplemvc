package simplemvc.command
{
	public final class CommandFacade{
		public function CommandFacade(){}
		
		public function func(withFunc :Function, ...others):FuncCommand{
			return FuncCommand.create(withFunc, others);
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