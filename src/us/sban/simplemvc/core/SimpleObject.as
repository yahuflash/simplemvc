package us.sban.simplemvc.core
{
	use namespace simplemvc_internal;
	/**
	 * 
	 * @author sban
	 * 
	 */	
	public dynamic class SimpleObject extends Object implements ISimpleObject
	{
		public function SimpleObject(){}
		
		public function release():ISimpleObject{
			return $.objects.pushReleased(this) as ISimpleObject;
		}
		
		
	}
}