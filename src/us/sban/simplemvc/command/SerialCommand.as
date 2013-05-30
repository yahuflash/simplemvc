package us.sban.simplemvc.command
{
	/**
	 * 串发指令
	 * @author sban
	 * 
	 */	
	public final class SerialCommand extends ComplexCommand
	{
		public function SerialCommand(commands :Array)
		{
			super(new SerialCommandPolicy(), commands);
		}
	}
}