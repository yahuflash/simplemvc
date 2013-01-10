package sban.simplemvc.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public final class DisplayUtil
	{
		/**
		 * 将静态的矢量对象转换为位置对象，删除原对象，在原位置插入静态位图
		 *  
		 * @param object
		 * @param appScale
		 * @param stage
		 * 
		 */		
		public static function convertVectorToBitmap(object:DisplayObject,appScale:Number,stage:Stage):void
		{
			// the original object's size (won't include glow effects!)
			var objectBounds:Rectangle = object.getBounds(object);
			objectBounds.x *= object.scaleX;
			objectBounds.y *= object.scaleY;
			objectBounds.width *= object.scaleX;
			objectBounds.height *= object.scaleY;
			
			// the target bitmap size
			var scaledBounds:Rectangle = objectBounds.clone();
			scaledBounds.x *= appScale;
			scaledBounds.y *= appScale;
			scaledBounds.width *= appScale;
			scaledBounds.height *= appScale;
			
			// scale and translate up-left to fit the entire object
			var matrix:Matrix = new Matrix();
			matrix.scale(object.scaleX, object.scaleY);
			matrix.scale(appScale, appScale);
			matrix.translate(-scaledBounds.x, -scaledBounds.y);
			
			// briefly increase stage quality while creating bitmapData
			stage.quality = StageQuality.HIGH;
			var bitmapData:BitmapData = new BitmapData(scaledBounds.width,
				scaledBounds.height, true);
			bitmapData.draw(object, matrix);
			stage.quality = StageQuality.LOW;
			
			// line up bitmap with the original object and replace it
			var bitmap:Bitmap = new Bitmap(bitmapData);
			bitmap.x = objectBounds.x + object.x;
			bitmap.y = objectBounds.y + object.y;
			object.parent.addChildAt(bitmap, object.parent.getChildIndex(object));
			object.parent.removeChild(object);
			
			// invert the scale of the bitmap so it fits within the original gui
			// this will be reversed when the entire application base is scaled
			bitmap.scaleX = bitmap.scaleY = (1 / appScale);
		}
		
		public function DisplayUtil()
		{
		}
	}
}