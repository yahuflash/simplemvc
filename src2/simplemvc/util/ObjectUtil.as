package simplemvc.util
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import simplemvc.common.IClonable;

	public final class ObjectUtil{
		
		/**复制对象*/
		public static function clone(source:*):*
		{
			if (source is Array){
				var r:Array = new Array();
				for (var j:int=0;j<source.length;j++)
					r[j]= ObjectUtil.clone( source[j] );
				return r;
			}
			
			if (source is IClonable)
				return (source as IClonable).clone();
			
			if (source is BitmapData)
				return (source as BitmapData).clone();
			
			var ba:ByteArray = new ByteArray();
			ba.writeObject(source);
			ba.position = 0;
			return ba.readObject();
		}
		
		public function ObjectUtil()
		{
		}
	}
}