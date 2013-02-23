package us.sban.simplemvc.util
{
	import flash.geom.Point;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.EventDispatcher;

	/**
	 * 优化starling应用的一些方法
	 * 
	 * 关于更多的优化技巧及方法，参见：
	 * <pre>
	 * http://www.todoair.com/starling%E6%80%A7%E8%83%BD%E4%BC%98%E5%8C%96%E6%8A%80%E5%B7%A7-2012-06-10/
	 * </pre>
	 *  
	 * @author sban
	 * 
	 */	
	public final class StarlingOptimizeUtil
	{
		/**
		 * Starling优化了未着色的图片的渲染代码，设置您的根对象的透明度为0.999，可以避免触发过多的状态变更。 
		 * @param stage
		 * 
		 */		
		public static function setStageAlpha(stage:Stage):void
		{
			stage.alpha = 0.999;
		}
		/**
		 *如果游戏背景是一个单独的颜色，请设置stage的颜色来代替添加一个纹理或一个着色的四边形。
		 *  
		 * @param stage
		 * @param color
		 * 
		 */		
		public static function setStageColor(stage:Stage,color:uint):void
		{
			stage.color = color;
		}
		/**
		 * Starling每一桢需要遍历所有的对象，检查它们的状态，然后上传它们的数据到GPU。
		 * 如果您的游戏中有一些内容是静态的，并且不会发生或很少改变，就可以调用这个Sprite容器的flatten方法。
		 * Starling将会预处理它的子元件，并上传它们的数据到GPU。
		 * 在后续的帧中，它们就可以马上被呈现，而 且不需要任何额外的GPU处理，也无需向GPU上传新的数据。
		 * 
		 * @param sprite
		 * 
		 */		
		public static function flattenOnStaticObject(sprite:Sprite):void
		{
			sprite.flatten();
		}
		
		/**
		 * 获取宽度和高度属性是一个昂贵的性能开销，特别是对于Sprite容器,首先矩阵进行计算，然后每一个子元件的每个顶点都和该矩阵相乘。
		 * 出于这个原因，请避免重复访问它们，特别在一个循环里面。
		 * 
		 * @param obj
		 * @param point
		 * @return 
		 * 
		 */		
		public static function getSizeOfContainer(obj:DisplayObjectContainer, point:Point=null):Point
		{
			if(!point) point = new Point();
			point.setTo(obj.width,obj.height);
			return point;
		}
		
		/**
		 * 对于不透明的矩形纹理，可以帮助GPU禁用那些纹理混合。这对于大背景图像特别有用。
		 *  
		 * @param img
		 * 
		 */		
		public static function setImageBlendModeNoneOnStaticObject(img:Image):void
		{
			img.blendMode = BlendMode.NONE;
		}
		/**
		 * 使用新的Starling事件模型,它会用对象池来缓存事件对象
		 * 
		 *  
		 * @param target
		 * @param type
		 * @param bubble
		 * 
		 */		
		public static function dispatchEventWith(target:EventDispatcher,type:String,bubble:Boolean):void
		{
			target.dispatchEventWith(type, bubble);
		}
		/**
		 * 让容器不可点击
		 * 当您在屏幕上移动您的光标/手指的时候，Starling就会寻找哪一个对象被点击了。
		 * 这可能是一项昂贵的操作，因为它需要遍历所有的显示对象，并调用hitTest方法。 
		 * 
		 * @param container
		 * 
		 */		
		public static function setContainerNotTouchable(container:DisplayObjectContainer):void
		{
			container.touchable = false;
		}
		
		public function StarlingOptimizeUtil()
		{
		}
	}
}