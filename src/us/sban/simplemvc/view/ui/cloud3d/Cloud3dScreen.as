package us.sban.simplemvc.view.ui.cloud3d
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * Starling实现的3D云彩效果
	 * @author shaorui
	 */
	public class Cloud3dScreen extends Sprite
	{
		/**云彩的素材图片*/
		[Embed(source="cloud10.png")]
		protected const cloudImgClass:Class;
		
		/**承载纹理用*/
		protected var img:Image;
		/**用批次处理来显示*/
		private var quadBatch:QuadBatch;
		/**存储云朵信息*/
		private var imgArr:Vector.<CloudItem>;
		/**创建多少个云朵*/
		private var imgCount:int = 300;
		/**屏幕宽度*/
		private var screenWidth:Number = 960;
		/**屏幕高度*/
		private var screenHeight:Number = 640;
		/**缩放的阈值*/
		private var focal:Number=250;
		/**屏幕可见区域*/
		private var stageRect:Rectangle;
		/**@private*/
		private var vpX:Number;
		/**@private*/
		private var vpY:Number;
		
		/**@private*/
		public function Cloud3dScreen()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,initGame);
		}
		/**初始化*/
		private function initGame(...args):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,initGame);
			//计算Z轴用
			vpX=stage.stageWidth/2;
			vpY=stage.stageHeight/2;
			stageRect = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			centerPoint = new Point(screenWidth/2,screenHeight/4*3);
			//设置蓝天颜色
			stage.color = 0x0008a7;
			//创建一个注册点在中心的图片
			img = Image.fromBitmap(new cloudImgClass());
			img.pivotX = img.width/2;
			img.pivotY = img.height/2;
			//批次用于渲染
			quadBatch = new QuadBatch();
			addChild(quadBatch);
			//用数组存储云朵属性
			imgArr = new Vector.<CloudItem>();
			for (var i:int = 0; i < imgCount; i++)
			{
				var item:CloudItem = new CloudItem();
				item.rotation = Math.random()*Math.PI;
				setAShape(item);
				imgArr.push(item);
			}
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		/**重置位置*/
		private function setAShape(shape:CloudItem):void
		{
			shape.scale = 0.001;
			shape.startX=screenWidth*2*Math.random()-screenWidth;
			shape.startY=screenHeight/2+screenHeight/2*Math.random()-100;
			shape.x = shape.startX;
			shape.y = shape.startY;
			shape.zpos = Math.random()*800+400;
		}
		/**Z排序*/
		private function sortArray():void
		{
			imgArr.sort(zSortFunction);
		}
		/**排序方法*/
		private function zSortFunction(a:CloudItem,b:CloudItem):Number
		{
			if(a.zpos > b.zpos)
				return -1;
			else if(a.zpos < b.zpos)
				return 1;
			else
				return 0;
		}
		/**判断一个对象是否已经不在屏幕区域*/
		private function shapeAvisible(shape:CloudItem):Boolean
		{
			var shapeRect:Rectangle = shape.getBounds(this);
			return shapeRect.intersects(stageRect);
		}
		/**每帧调用*/
		private function enterFrameHandler(event:Event=null):void
		{
			quadBatch.reset();
			var xpos:Number;
			var ypos:Number;
			var item:CloudItem;
			for (var i:int = 0; i < imgCount; i++)
			{
				item = imgArr[i];
				//reset properties
				item.zpos-=4;
				var x1:Number = screenWidth-item.startX*2;
				var y1:Number = screenHeight/2-item.startY;
				if (item.zpos>-focal && shapeAvisible(item))
				{
					xpos=centerPoint.x-vpX-x1;//x维度
					ypos=centerPoint.y-vpY-y1;//y维度
					item.scale=focal/(focal+item.zpos);//缩放产生近大远小，取值在0-1之间；
					item.x=vpX+xpos*item.scale;
					item.y=vpY+ypos*item.scale;
				}
				else
				{
					setAShape(item);
				}
			}
			//每次进行Z排序
			sortArray();
			for (i = 0; i < imgCount; i++)
			{
				item = imgArr[i];
				img.x = item.x;
				img.y = item.y;
				img.scaleX = img.scaleY = item.scale;
				img.rotation = item.rotation;
				quadBatch.addImage(img);
			}
		}
		/**@private*/
		private var centerPoint:Point;
		/**触碰处理*/
		private function onTouchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch == null)
				return;
			if(touch.phase == TouchPhase.HOVER)
			{
				centerPoint.x = touch.globalX/4+screenWidth/8;
				centerPoint.y = touch.globalY/4+screenHeight/8+280;
			}
		}
	}
}

import flash.geom.Rectangle;
import starling.display.DisplayObject;

/**
 * 存储云朵属性的类
 * @author shaorui
 */
class CloudItem
{
	private var itemWidth:Number = 256;
	private var itemHeight:Number = 256;
	
	public var startX:Number;
	public var startY:Number;
	public var zpos:Number=0;
	
	public var x:Number = 0;
	public var y:Number = 0;
	public var scale:Number = 1;
	public var rotation:Number = 0;
	
	public function getBounds(targetSpace:DisplayObject):Rectangle
	{
		var w:Number = itemWidth*scale;
		var h:Number = itemHeight*scale;
		var rect:Rectangle = new Rectangle(x-w/2,y-h/2,w/2,h/2);
		return rect;
	}
}
