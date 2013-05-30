package us.sban.simplemvc.view
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.StageQuality;
	import flash.filters.BitmapFilter;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * starling dynamic texture/image
	 *  
	 * @author sban
	 * 
	 */	
	public class DynamicTexture extends Shape
	{
		public function DynamicTexture()
		{
			super();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function toTexture():Texture{
			var rect:Rectangle = this.getBounds(this);
//			trace(rect);
			var bmpData:BitmapData = new BitmapData(rect.width, rect.height, true, 0x0);
			if(filters!=null && filters.length > 0){
				var filterRect:Rectangle = rect.clone();
				for each (var filter:BitmapFilter in filters){
					filterRect = filterRect.union( bmpData.generateFilterRect(rect, filter) );
//					trace(filterRect);
				}
				bmpData = new BitmapData(filterRect.width, filterRect.height, true, 0x0);
			}
			bmpData.drawWithQuality(this,null,null,null,null,true,StageQuality.HIGH);
			var texture:Texture= Texture.fromBitmapData(bmpData);
			bmpData.dispose();
			return texture;
		}
		
		public function toImage():Image{
			return new Image(toTexture());
		}
	}
}