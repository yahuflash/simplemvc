package us.sban.simplemvc.view.ui
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	use namespace starling_internal;
	
	/**
	 * 该类由郭少瑞编写，下面是介绍链接：
	 * http://www.todoair.com/starling%E6%89%A9%E5%B1%95tabsprite-2012-06-17/
	 * 
	 * 使得方法:
	 * StarlingTabSprite，然后注册需要焦点管理的显示对象：
	 * <pre>
	 * touchedObjects.push(obj);
	 * </pre>
	 * 
	 * 一个容器，允许用户通过Tab键（或方向键的左右），来切换内部显示对象的焦点，按Enter代表确认（触发Touch事件）。
	 * 适用于一些不能Touch的场合（比如智能TV）。
	 * @author <a href="http://weibo.com/guoshaorui">NeoGuo</a>
	 */
	public class StarlingTabSprite extends Sprite
	{
		/**一个数组，包含可被焦点管理器管理的显示对象。
		 * 可接受类型为显示对象，或一个对象：{target:myMC,range:new Rectangle(0,0,100,100)}，通过后面的方法，可以指定一个对象的某个区域为焦点响应区域。
		 * 您可以把需要被焦点管理器管理的对象添加到这个数组，当显示对象处于显示列表之后，他们就可以用Tab键（或方向键的左右）进行控制。
		 */
		public var touchedObjects:Vector.<Object>;
		/**用户必须通过键盘先激活Tab模式*/
		protected var enabled:Boolean = false;
		/**处于焦点的索引*/
		protected var tabIndex:int = 0;
		/**处于焦点的显示对象*/
		protected var tabChild:DisplayObject;
		/**处于焦点的显示对象区域*/
		protected var tabChildRect:Rectangle;
		/**容纳四边形显示的容器*/
		protected var rectHostContainer:DisplayObjectContainer;
		/**显示四边形的Image*/
		protected var rectImage:Image;
		/**用于修正滚动容器中造成的计算误差，比如用了Foxhole库。如果没有用到这个类库，请忽略这个属性。*/
		protected var touchPointOffset:Point;
		/**
		 * CONSTRATOR
		 */
		public function StarlingTabSprite()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,initTabSprite);
			this.addEventListener(Event.REMOVED_FROM_STAGE,clearTabSprite);
			touchedObjects = new Vector.<Object>();
			rectHostContainer = this;
		}
		/**
		 * 初始化容器
		 */
		protected function initTabSprite(...args):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onSpriteKeyDown);
		}
		/**
		 * 临时清理容器
		 */
		protected function clearTabSprite(...args):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onSpriteKeyDown);
			clearTabRect();
		}
		/**
		 * 侦听键盘按下，切换焦点
		 * @param event KeyboardEvent
		 */
		protected function onSpriteKeyDown(event:KeyboardEvent):void
		{
			if(!visible || !touchable || touchedObjects == null || touchedObjects.length == 0 )
				return;
			if(event.keyCode == Keyboard.ENTER)
			{
				if(tabChild != null)
					touchCurrentChild();
				clearTabRect();
				return;
			}
			if(event.keyCode != Keyboard.TAB && event.keyCode != Keyboard.LEFT && event.keyCode != Keyboard.RIGHT)
				return;
			if(!enabled)
			{
				enabled = true;
				tabIndex = 0;
			}
			else if(event.keyCode == Keyboard.TAB || event.keyCode == Keyboard.RIGHT)
			{
				tabIndex++;
				if(tabIndex == touchedObjects.length)
					tabIndex = 0;
				onTabKeyPress();
			}
			else if(event.keyCode == Keyboard.LEFT)
			{
				tabIndex--;
				if(tabIndex < 0)
					tabIndex = touchedObjects.length-1;
				onTabKeyPress();
			}
			if(touchedObjects[tabIndex] is DisplayObject)
			{
				tabChild = touchedObjects[tabIndex] as DisplayObject;
				tabChildRect = null;
			}
			else
			{
				tabChild = touchedObjects[tabIndex]["target"];
				tabChildRect = touchedObjects[tabIndex]["range"];
			}
			if(tabChild == null || !tabChild.visible || !tabChild.touchable)
				return;
			showTabRect();
		}
		/**供继承类来实现*/
		protected function onTabKeyPress():void
		{
			
		}
		/**
		 * 当用户按下Enter键，模拟Touch
		 */
		private function touchCurrentChild():void
		{
			var position:Point;
			if(tabChildRect != null)
				position = new Point(tabChild.x+tabChildRect.x+tabChildRect.width/2,tabChild.y+tabChildRect.y+tabChildRect.height/2);
			else
				position = new Point(tabChild.x+tabChild.width/2,tabChild.y+tabChild.height/2);
			if(touchPointOffset != null)
			{
				position.x -= touchPointOffset.x;
				position.y -= touchPointOffset.y;
			}
			var touch:Touch = new Touch(0,position.x,position.y,TouchPhase.ENDED,this);
			touch.setTimestamp(Starling.current.juggler.elapsedTime);
			//touch.
			var touchs:Vector.<Touch> = new Vector.<Touch>();
			touchs.push(touch);
			var touchEvent:TouchEvent = new TouchEvent(TouchEvent.TOUCH,touchs,true,true,true);
			tabChild.dispatchEvent(touchEvent);
		}
		/**清理焦点显示*/
		protected function clearTabRect():void
		{
			if(rectImage == null)
				return;
			if(rectImage.parent != null)
				rectImage.removeFromParent();
			if(rectImage != null || rectImage.texture != null)
			{
				rectImage.texture.dispose();
				rectImage.dispose();
				rectImage = null;
			}
		}
		/**显示当前焦点区域*/
		protected function showTabRect():void
		{
			clearTabRect();
			//get rect
			var rect:Rectangle = tabChild.getBounds(this);
			if(tabChildRect != null)
			{
				rect.x += tabChildRect.x;
				rect.y += tabChildRect.y;
				rect.width = tabChildRect.width;
				rect.height = tabChildRect.height;
			}
			//draw
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(12,0xD9D919,1);
			shape.graphics.moveTo(0,0);
			shape.graphics.lineTo(rect.width,0);
			shape.graphics.lineTo(rect.width,rect.height);
			shape.graphics.lineTo(0,rect.height);
			shape.graphics.lineTo(0,0);
			var bmd:BitmapData = new BitmapData(rect.width,rect.height,true,0x000000);
			bmd.draw(shape);
			var texture:Texture = Texture.fromBitmapData(bmd,false);
			rectImage = new Image(texture);
			rectImage.touchable = false;
			rectImage.x = rect.x;
			rectImage.y = rect.y;
			rectHostContainer.addChild(rectImage);
			bmd.dispose();
		}
		/**
		 * 取消这个容器的Tab管理，和普通容器一致
		 */
		public function cancelTabManagement():void
		{
			touchedObjects = null;
			removeEventListener(Event.ADDED_TO_STAGE,initTabSprite);
			removeEventListener(Event.REMOVED_FROM_STAGE,clearTabSprite);
			if(stage != null)
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,onSpriteKeyDown);
			tabChild = null;
		}
		/**@private*/
		override public function dispose():void
		{
			touchedObjects = null;
			tabChild = null;
			removeEventListener(Event.ADDED_TO_STAGE,initTabSprite);
			removeEventListener(Event.REMOVED_FROM_STAGE,clearTabSprite);
			clearTabRect();
			super.dispose();
		}
	}
}