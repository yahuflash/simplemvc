package sban.simplemvc.command
{
	/**
	 * 并发指令 
	 * @author sban
	 * 
	 */	
	public final class ParallelCommand extends ComplexCommand
	{
		public function ParallelCommand(commands :Array)
		{
			super(new ParallelCommandPolicy(), commands);
		}
	}
}