package simplemvc.command
{
	/**
	 * 串发 
	 * @author Optimus.Li
	 * 
	 */	
	public final class SerialCommand extends ComplexCommand
	{
		public function SerialCommand(...commands)
		{
			super(new SerialPolicy(), commands);
		}
	}
}