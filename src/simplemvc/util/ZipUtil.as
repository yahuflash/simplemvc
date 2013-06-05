package simplemvc.util
{
	import flash.utils.ByteArray;
	import nochump.util.zip.ZipFile;
	import nochump.util.zip.ZipEntry;

	/**文件压缩与解压缩工具类*/
	public final class ZipUtil
	{
		/**从压缩包中提取某文件的字节数组*/
		public static function getFileFromZipBytes(zipBytes:ByteArray,targetName:String):ByteArray{
			var zipFile:ZipFile = new ZipFile(zipBytes);
			var zipEntry:ZipEntry = zipFile.getEntry(targetName);
			return zipFile.getInput(zipEntry)
		}
		
		public function ZipUtil()
		{
		}
	}
}