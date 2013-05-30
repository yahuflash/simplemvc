package simplemvc.command
{
	/**
	 * 串发 
	 * @author Optimus.Li
	 * 
	 */	
	public final class SerialCommand extends ComplexCommand
	{
		public function SerialCommand(...commands :Array)
		{
			super(new SerialPolicy(), commands);
		}
	}
}