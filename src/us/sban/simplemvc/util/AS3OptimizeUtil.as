package us.sban.simplemvc.util
{
	public final class AS3OptimizeUtil
	{
		/**
		 * 当从一个数组或一个向量数组中引用一个对象的时候，索引转换为int类型，这样可以让AS3计算更快。
		 *  
		 * @param arr
		 * @param index
		 * @return 
		 * 
		 */		
		public static function getItemInArrayOrVector(arr:Object,index:int):Object
		{
			return arr[index];
		}
		
		public function AS3OptimizeUtil()
		{
		}
	}
}