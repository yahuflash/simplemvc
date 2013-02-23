package us.sban.simplemvc.util
{
	import flash.geom.Point;

	/**
	 * 关于碰撞检测的工具方法
	 *  
	 * @author sban
	 * 
	 */	
	public final class HitTestUtil
	{
		private static function hitTrianglePoint(p1:Point,p2:Point,p3:Point):int
		{
			if ((p2.x-p1.x)*(p2.y+p1.y)+(p3.x-p2.x)*(p3.y+p2.y)+(p1.x-p3.x)*(p1.y+p3.y)){
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 三角形顶点碰撞检测
		 * p1,p2,p3 为范围点
		 * p4为碰撞点。
		 * @return
		 */
		public static function hitPoint(p1:Point,p2:Point,p3:Point,p4:Point):Boolean
		{
			var a:int = hitTrianglePoint(p1,p2,p3);
			var b:int = hitTrianglePoint(p4,p2,p3);
			var c:int = hitTrianglePoint(p1,p2,p4);
			var d:int = hitTrianglePoint(p1,p4,p3);
			if ((b==a)&&(c==a)&&(d==a))
			{
				return true;
			}
			else
			{
				return false;
				
			}
		}
		
		public function HitTestUtil()
		{
		}
	}
}