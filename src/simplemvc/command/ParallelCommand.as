package simplemvc.command
{
	/**
	 * 并发 
	 * @author Optimus.Li
	 * 
	 */	
	public final class ParallelCommand extends ComplexCommand
	{
		public function ParallelCommand(...commands :Array)
		{
			super(new ParallelPolicy(), commands);
		}
	}
}