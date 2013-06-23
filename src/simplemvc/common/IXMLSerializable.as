package simplemvc.common
{
	public interface IXMLSerializable
	{
		function toXML():XML;
		function parseFromXML(data:XML):void;
	}
}