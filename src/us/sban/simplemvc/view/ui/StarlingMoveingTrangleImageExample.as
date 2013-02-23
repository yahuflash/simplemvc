package us.sban.simplemvc.view.ui
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.animation.IAnimatable;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.VertexData;
	/**
	 * 
	 * http://www.todoair.com/754-2012-11-09/
	 * STARLING中实现形状不规则的卷轴地图滚动
	 * 
	 * <pre>
	 * [Embed(source="../assets/bg.jpg")]
protected const bgClass:Class;
var img:TrangleImage = TrangleImage.fromBitmap(new bgClass() as Bitmap);
addChild(img);
Starling.juggler.add(img);
img = TrangleImage.fromBitmap(new bgClass() as Bitmap,2);
img.direction = "up";
addChild(img);
Starling.juggler.add(img);
	 * </pre>
	 * 
	 * 
	 * 继承Image类，但修改第2个顶点坐标，改为三角形显示
	 * 实现IAnimatable接口，控制UV坐标，实现卷轴滚动效果
	 * @author shaorui
	 */
	public class StarlingMoveingTrangleImageExample extends Image implements IAnimatable
	{
		/**向下*/
		public var direction:String = "down";
		/**
		 * 根据传入的位图对象创建一个包含纹理的Image。
		 * @param bitmap    位图对象
		 * @return
		 */
		public static function fromBitmap(bitmap:Bitmap,vetexIndex:int=1):StarlingMoveingTrangleImageExample
		{
			var tex:Texture = Texture.fromBitmap(bitmap);
			tex.repeat = true;
			return new StarlingMoveingTrangleImageExample(tex,vetexIndex);
		}
		/**@private*/
		public function StarlingMoveingTrangleImageExample(texture:Texture,vetexIndex:int=1)
		{
			super(texture);
			if (texture)
			{
				var frame:Rectangle = texture.frame;
				var w:Number  = frame ? frame.width/2  : texture.width/2;
				var h:Number = frame ? frame.height/2 : texture.height/2;
				//重置纹理的UV坐标
				resetTexCoords(vetexIndex);
				//将第二个顶点（索引是1）移动到中心点的位置
				mVertexData.setPosition(vetexIndex,width*0.5,height*0.5);
				//因为只需要显示整个纹理1/4的区域，索引将宽度和高度都除以2
				width = w;
				height = h;
				onVertexDataChanged();
			}
			else
			{
				throw new ArgumentError("Texture cannot be null");
			}
		}
		/**设置纹理的UV坐标为整个纹理左下角1/4的区域*/
		private function resetTexCoords(vetexIndex:int):void
		{
			mVertexData.setTexCoords(0, 0.0, 0.5);
			mVertexData.setTexCoords(1, 0.5, 0.5);
			mVertexData.setTexCoords(2, 0.0, 1.0);
			mVertexData.setTexCoords(3, 0.5, 1.0);
			if(vetexIndex == 1)
				mVertexData.setTexCoords(1, 0.25, 0.75);//注意这个点，因为是三角形，这个点也在1/4区域的中心点上
			else if(vetexIndex == 2)
				mVertexData.setTexCoords(2, 0.25, 0.75);
		}
		/**时间驱动的动画*/
		public function advanceTime(time:Number):void
		{
			//将4个点的UV坐标累加或累减，实现动画效果
			for (var i:int = 0; i < 4; i++)
			{
				var cp:Point = this.getTexCoords(i);
				if(direction == "down")
					this.setTexCoords(i,new Point(cp.x+0.001,cp.y-0.001));
				else
					this.setTexCoords(i,new Point(cp.x-0.001,cp.y+0.001));
			}
		}
		
	}
}